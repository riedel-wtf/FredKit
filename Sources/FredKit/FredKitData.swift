//
//  FredKitData.swift
//  FredKit
//
//  Created by Frederik Riedel on 10/12/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation
import CommonCrypto

public extension Data {
    
    var sha1: String {
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}
