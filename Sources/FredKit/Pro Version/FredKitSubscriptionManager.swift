//
//  SubscriptionManager.swift
//  Homie
//
//  Created by Frederik Riedel on 11.07.20.
//
import Foundation
import SwiftyStoreKit
import StoreKit

@objc public protocol FredKitSubscriptionManagerDelegate {
    @objc func didFinishFetchingProducts(products: [SKProduct])
}

public enum MembershipStatus {
    case notPurchased, subscribed, expired
}

@objc public class FredKitSubscriptionManager: NSObject {
    
    @objc public static let shared = FredKitSubscriptionManager()
    
    private var sharedSecret: String!
    private var productIds: [String]!
    
    var delegate: FredKitSubscriptionManagerDelegate!
    
    public var cachedProducts = [SKProduct]()
    
    
    public typealias CachedProductsCompletionHandler = ([SKProduct]) -> (Void)
    
    private var cachedProductsCompletionHandlers: [CachedProductsCompletionHandler] = []
    public func waitForCachedProducts(completion: @escaping CachedProductsCompletionHandler) {
        if self.cachedProducts.isEmpty {
            cachedProductsCompletionHandlers.append(completion)
        } else {
            completion(cachedProducts)
        }
    }
    
    @objc public static func setup(productIds: [String], sharedSecret: String? = nil, delegate: FredKitSubscriptionManagerDelegate) {
        shared.productIds = productIds
        if let sharedSecret = sharedSecret {
            shared.sharedSecret = sharedSecret
        }
        shared.delegate = delegate
        shared.prefetchProducts()
        shared.completePendingTransactions()
    }
    
    
    
    private func prefetchProducts() {
        let productIdSet = Set<String>(self.productIds)
        SwiftyStoreKit.retrieveProductsInfo(productIdSet) { result in
            self.cachedProducts = Array(result.retrievedProducts)
            print(self.cachedProducts)
            self.delegate.didFinishFetchingProducts(products: self.cachedProducts)
            self.cachedProductsCompletionHandlers.forEach { completion in
                completion(self.cachedProducts)
            }
        }
    }
    
    public func product(forId id: String) -> SKProduct? {
        return self.cachedProducts.first { product in
            product.productIdentifier == id
        }
    }
    
    
    public func purchaseSubscription(forProduct product: SKProduct, completion: @escaping (Bool) -> Void) {
        SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchaseResult):
                self.updateExpirationDate {
                    completion(true)
                }
            case .error(let error):
                self.handlePurchaseError(error: error)
                print(error.localizedDescription)
                self.updateExpirationDate {
                    completion(false)
                }
            }
        }
    }
    
    private func handlePurchaseError(error: SKError) {
        switch error.code {
        case .unknown: print("Unknown error. Please contact support")
        case .clientInvalid: showPaymentDisabledError()
        case .paymentCancelled: print("Payment cancelled by user.")
        case .paymentInvalid: print("The purchase identifier was invalid")
        case .paymentNotAllowed: showPaymentDisabledError()
        case .storeProductNotAvailable: print("The product is not available in the current storefront")
        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
        case .cloudServiceNetworkConnectionFailed: showPurchaseFailedError()
        case .cloudServiceRevoked: showPaymentDisabledError()
        case .privacyAcknowledgementRequired: print("privacyAcknowledgementRequired")
        case .unauthorizedRequestData: print("unauthorizedRequestData")
        case .invalidOfferIdentifier: print("invalidOfferIdentifier")
        case .invalidSignature: print("invalidSignature")
        case .missingOfferParams: print("missingOfferParams")
        case .invalidOfferPrice: print("invalidOfferPrice")
        case .overlayTimeout: print("overlayTimeout")
        case .overlayCancelled: print("overlayCancelled")
        case .ineligibleForOffer: print("ineligibleForOffer")
        case .overlayInvalidConfiguration: print("overlayInvalidConfiguration")
//        case .unsupportedPlatform: print("unsupported platform")
        @unknown default:
            print("unknown error")
        }
    }
    
    
    public func restorePurchases(completion: @escaping (RestoreResults) -> Void) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            
            if results.restoreFailedPurchases.count > 0 {
                self.showRestoringPurchasesError()
                completion(results)
            } else if results.restoredPurchases.count > 0 {
                self.updateExpirationDate {
                    completion(results)
                }
            } else {
                self.showRestoringPurchasesError()
                completion(results)
            }
        }
    }
    
    func updateExpirationDate(completion: @escaping () -> ()) {
        
        var verificationType = AppleReceiptValidator.VerifyReceiptURLType.production
        
        #if DEBUG
        verificationType = AppleReceiptValidator.VerifyReceiptURLType.sandbox
        #endif
        
        
        
        let appleValidator = AppleReceiptValidator(service: verificationType, sharedSecret: self.sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                
                // Verify the purchase of a Subscription
                var expirationDates = [Date]()
                
                self.productIds.forEach({ (productId) in
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .autoRenewable,
                        productId: productId,
                        inReceipt: receipt)
                    
                    switch purchaseResult {
                    case .purchased(_, let items):
                        let expireDate = items.latestExpirationDate
                        expirationDates.append(expireDate)
                    case .expired(_, let items):
                        let expireDate = items.latestExpirationDate
                        expirationDates.append(expireDate)
                    case .notPurchased:
                        print("The user has never purchased \(productId)")
                    }
                })
                
                
                if expirationDates.count > 0 {
                    expirationDates.sort()
                    expirationDates.reverse()
                    let defaults = UserDefaults.standard
                    let membershipInformation = ["expirationDate": expirationDates.first!]
                    defaults.set(membershipInformation, forKey: "membershipStatus")
                    defaults.synchronize()
                }
                completion()
                
            case .error(let error):
                print("Receipt verification failed: \(error)")
                completion()
            }
        }
    }
    
    var membershipExpirationDate: Date? {
        let defaults = UserDefaults.standard
        
        if let membershipInformation = defaults.object(forKey: "membershipStatus") as? [String: Any] {
            if let expirationDate = membershipInformation["expirationDate"] as? Date {
                return expirationDate
            }
        }
        
        return nil
    }
    
    public var currentMembershipStatus: MembershipStatus {
        
        if CommandLine.arguments.contains("-subscribed") {
            return .subscribed
        }
        
        #if DEBUG
        if CommandLine.arguments.contains("-expired") {
            return .expired
        }
        return .subscribed
        #else
        
        if let expirationDate = self.membershipExpirationDate {
            // give one week of grace period
            var gracePeriod = TimeInterval.week
            #if DEBUG
            gracePeriod = 0
            #endif
            if Date().timeIntervalSince(expirationDate) < gracePeriod {
                return .subscribed
            } else {
                return .expired
            }
        }
        return .notPurchased
        #endif
    }
    
    @objc public var isCurrentlySubscribed: Bool {
        return self.currentMembershipStatus == .subscribed
    }
    
    func completePendingTransactions() {
        SwiftyStoreKit.shouldAddStorePaymentHandler = { (_ payment: SKPayment, _ product: SKProduct) in
            return true
        }
        
        SwiftyStoreKit.completeTransactions(atomically: false) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
    }
}

@available(iOS 11.2, *)
public extension SKProductSubscriptionPeriod {
    
    var localizedDurationVerbose: String {
        let isPlural = !(numberOfUnits == 1)
        var periodType = isPlural ? NSLocalizedString("Weeks", comment: "") : NSLocalizedString("Week", comment: "");
        
        switch unit {
        case .day:
            periodType = isPlural ? NSLocalizedString("Days", comment: "") : NSLocalizedString("Day", comment: "");
        case .week:
            periodType = isPlural ? NSLocalizedString("Weeks", comment: "") : NSLocalizedString("Week", comment: "");
        case .month:
            periodType = isPlural ? NSLocalizedString("Months", comment: "") : NSLocalizedString("Month", comment: "");
        case .year:
            periodType = isPlural ? NSLocalizedString("Years", comment: "") : NSLocalizedString("Year", comment: "");
        @unknown default:
            periodType = "Unknown"
        }
        
        if !isPlural {
            return periodType
        }
        
        return "\(numberOfUnits) \(periodType)"
    }
}

public extension SKProduct {
    var localizedPriceString: String? {
        let numberFormatter = NumberFormatter()
        let locale = priceLocale
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        return numberFormatter.string(from: price)
    }
    
    
    var hasFreeTrial: Bool {
        if #available(iOS 12.2, *) {
            let subscriptionOffers = self.discounts
            
            return subscriptionOffers.reduce(false) { partialResult, discount in
                return discount.price == 0 || partialResult
            }
        }
        
        return false
    }
}

public extension Array where Element == SKProduct {
    var withoutTips: [SKProduct] {
        return self.filter { product in
            !product.localizedTitle.contains("Tip")
        }
    }
}

@available(iOS 11.2, *)
public extension SKProductDiscount {
    var localizedPriceString: String? {
        let numberFormatter = NumberFormatter()
        let locale = priceLocale
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        return numberFormatter.string(from: price)
    }
}


public extension Array where Element == ReceiptItem {
    var latestExpirationDate: Date {
        var latestExpirationDate = Date(timeIntervalSince1970: 0)
        for item in self {
            if let expirationDate = item.subscriptionExpirationDate {
                if expirationDate > latestExpirationDate {
                    latestExpirationDate = expirationDate
                }
            }
        }
        return latestExpirationDate
    }
}


import SafariServices
public extension FredKitSubscriptionManager {
    func showPaymentDisabledError() {
        let alert = UIAlertController.init(title: "Purchase Failed", message: "Couldn't purchase the “Pro Membership”. Maybe your device has set restrictions on such purchases or you disabled In-App puchases.", preferredStyle: .alert)
        let learnMore = UIAlertAction.init(title: "Learn More", style: .default, handler: { (_) in
            let sfSVC = SFSafariViewController.init(url: URL.init(string: "https://support.apple.com/en-us/HT204396")!)
            UIViewController.topViewController()?.present(sfSVC, animated: true, completion: nil)
        })
        let ok = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(learnMore)
        UIViewController.topViewController()?.present(alert, animated: true)
    }
    
    func showRestoringPurchasesError() {
        let alert = UIAlertController.init(title: "Restoring Failed", message: "Couldn't restore the In App Purchases.", preferredStyle: .alert)
        let learnMore = UIAlertAction.init(title: "Learn More", style: .default, handler: { (_) in
            let sfSVC = SFSafariViewController.init(url: URL.init(string: "https://support.apple.com/en-us/HT204530")!)
            UIViewController.topViewController()?.present(sfSVC, animated: true, completion: nil)
        })
        let ok = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(learnMore)
        UIViewController.topViewController()?.present(alert, animated: true)
    }
    
    func showPurchaseFailedError() {
        let alert = UIAlertController.init(title: "Purchase Failed", message: "Couldn't purchase the “Pro Membership”. Please make sure that your phone is connected to the Internet and try again.", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        UIViewController.topViewController()?.present(alert, animated: true)
    }
}

