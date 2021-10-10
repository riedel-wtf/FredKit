//
//  File.swift
//  
//
//  Created by Frederik Riedel on 10/9/21.
//

import Foundation
import UIKit

struct App {
    let name: String
    let url: String
    let icon: UIImage
    let subtitle: String
    let bundleId: String
}

@available(iOS 13.0, *)
struct FredKitApps {
    static let apps = [
        App(name: "one sec", url: "https://apps.apple.com/app/apple-store/id1532875441?pt=120233067&ct=riedel-wtf-share&mt=8&at=1001l37Wi", icon: UIImage(named: "one sec logo", in: Bundle.module, with: nil)!, subtitle: "Break social media habits with Shortcut Automations.", bundleId: "wtf.riedel.one-sec"),
        App(name: "Homie", url: "https://apps.apple.com/app/apple-store/id1533590432?pt=120233067&ct=riedel-wtf-share&mt=8&at=1001l37Wi", icon: UIImage(named: "homie-icon", in: Bundle.module, with: nil)!, subtitle: "HomeKit in your Mac‘s Menu Bar.", bundleId: "wtf.riedel.homie"),
        App(name: "Processing for iOS", url: "https://apps.apple.com/app/apple-store/id648955851?pt=1178886&ct=riedel-wtf-share&mt=8&at=1001l37Wi", icon: UIImage(named: "processing logo", in: Bundle.module, with: nil)!, subtitle: "Processing and p5.js to go.", bundleId: "com.polarapps.processing"),
        App(name: "Redpoint", url: "https://itunes.apple.com/app/apple-store/id1324072645?pt=1178886&ct=riedel-wtf-share&mt=8&at=1001l37Wi", icon: UIImage(named: "redpoint-logo", in: Bundle.module, with: nil)!, subtitle: "Bouldering and Climbing Tracker for Apple Watch.", bundleId: "io.frogg.Boulder-Buddy"),
        App(name: "iRedstone", url: "https://apps.apple.com/app/apple-store/id533247882?pt=1178886&ct=riedel-wtf-share&mt=8&at=1001l37Wi", icon: UIImage(named: "iredstone logo", in: Bundle.module, with: nil)!, subtitle: "Learn the Basics of Electrical Engineering and Computer Science in Minecraft.", bundleId: "com.polarapps.iredstone"),
        App(name: "TrackList", url: "https://apps.apple.com/us/app/tracklist-analyze-dj-sets/id1585989360?at=1001l37Wi&ct=riedel-wtf-share", icon: UIImage(named: "icon-tracklist", in: Bundle.module, with: nil)!, subtitle: "Analyze DJ sets within seconds—fully automatic!", bundleId: "io.frogg.TrackID"),
        App(name: "Shortcut Remote Control", url: "https://apps.apple.com/de/app/shortcut-remote-control/id1511009307?l=en&at=1001l37Wi&ct=riedel-wtf-share", icon: UIImage(named: "shortcut remote control app icon", in: Bundle.module, with: nil)!, subtitle: "Remote-Control your Mac with Siri, Shortcuts, and AppleScript.", bundleId: "io.frogg.Shortcut-Remote"),
        App(name: "QuickScreen", url: "https://apps.apple.com/app/apple-store/id1278168661?pt=120233067&ct=riedel-wtf-share&mt=8&at=1001l37Wi", icon: UIImage(named: "quickscreen icon", in: Bundle.module, with: nil)!, subtitle: "Mirror your phone‘s screen to your computer with ease.", bundleId: "io.frogg.quickscreen"),
        App(name: "Focus Bar", url: "https://apps.apple.com/us/app/focus-bar-quickly-add-todos/id1556900097?ct=riedel-wtf-share&mt=8&at=1001l37Wi", icon: UIImage(named: "focus bar icon", in: Bundle.module, with: nil)!, subtitle: "Quickly add Reminders without getting distracted.", bundleId: "wtf.riedel.Focus-Bar-App"),
    ]
    
    static func app(for bundleID: String) -> App? {
        return apps.first { app in
            app.bundleId == bundleID
        }
    }
    
    static var appsExcludingCurrentApp: [App] {
        return apps.filter { app in
            app.bundleId != UIApplication.shared.bundleID
        }
    }
}
