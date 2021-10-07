//
//  FredKitFilemanager.swift
//  FredKit
//
//  Created by Frederik Riedel on 10/23/19.
//  Copyright © 2019 Frederik Riedel. All rights reserved.
//

import Foundation

public extension FileManager {
    static var documentsDirectory: URL {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return URL(fileURLWithPath: documents)
    }
    
    static func ensureFolderExists(folderPath: String) {
        if !FileManager.default.fileExists(atPath: folderPath) {
            try? FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true)
        }
    }
}
