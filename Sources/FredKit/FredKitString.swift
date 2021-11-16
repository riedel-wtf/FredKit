//
//  FredKitString.swift
//  FredKit
//
//  Created by Frederik Riedel on 10/12/18.
//  Copyright © 2018 Frederik Riedel. All rights reserved.
//

import Foundation
import CommonCrypto
import CoreGraphics

public extension String {
    var firstCharacterCapitalized: String {
        var result = self
        let substr1 = String(self[startIndex]).uppercased()
        result.replaceSubrange(...startIndex, with: substr1)
        return result
    }
    
    var sha1: String {
        let data = self.data(using: String.Encoding.utf8)!
        return data.sha1
    }
    
    subscript(index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
    
    func isAlmostEqualTo(otherString: String) -> Bool {
        return levenshtein(otherString) < 4
    }
    
    var urlEncodedQuery: String {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    var urlEncodedHost: String {
        self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

// https://gist.github.com/RuiCarneiro/82bf91214e3e09222233b1fc04139c86
public extension String {
    public func levenshtein(_ other: String) -> Int {
        let sCount = self.count
        let oCount = other.count
        
        guard sCount != 0 else {
            return oCount
        }
        
        guard oCount != 0 else {
            return sCount
        }
        
        let line : [Int]  = Array(repeating: 0, count: oCount + 1)
        var mat : [[Int]] = Array(repeating: line, count: sCount + 1)
        
        for i in 0...sCount {
            mat[i][0] = i
        }
        
        for j in 0...oCount {
            mat[0][j] = j
        }
        
        for j in 1...oCount {
            for i in 1...sCount {
                if self[i - 1] == other[j - 1] {
                    mat[i][j] = mat[i - 1][j - 1]       // no operation
                }
                else {
                    let del = mat[i - 1][j] + 1         // deletion
                    let ins = mat[i][j - 1] + 1         // insertion
                    let sub = mat[i - 1][j - 1] + 1     // substitution
                    mat[i][j] = min(min(del, ins), sub)
                }
            }
        }
        
        return mat[sCount][oCount]
    }
}

#if os(iOS)
import UIKit

//https://stackoverflow.com/questions/9976454/cgpathref-from-string
public extension String {
    func path(withFont font: UIFont) -> CGPath {
        let attributedString = NSAttributedString(string: self, attributes: [.font: font])
        let path = attributedString.path()
        return path
    }
}

public extension NSAttributedString {
    func path() -> CGPath {
        let path = CGMutablePath()

        // Use CoreText to lay the string out as a line
        let line = CTLineCreateWithAttributedString(self as CFAttributedString)

        // Iterate the runs on the line
        let runArray = CTLineGetGlyphRuns(line)
        let numRuns = CFArrayGetCount(runArray)
        for runIndex in 0..<numRuns {

            // Get the font for this run
            let run = unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), to: CTRun.self)
            let runAttributes = CTRunGetAttributes(run) as Dictionary
            let runFont = runAttributes[kCTFontAttributeName] as! CTFont

            // Iterate the glyphs in this run
            let numGlyphs = CTRunGetGlyphCount(run)
            for glyphIndex in 0..<numGlyphs {
                let glyphRange = CFRangeMake(glyphIndex, 1)

                // Get the glyph
                var glyph : CGGlyph = 0
                withUnsafeMutablePointer(to: &glyph) { glyphPtr in
                    CTRunGetGlyphs(run, glyphRange, glyphPtr)
                }

                // Get the position
                var position : CGPoint = .zero
                withUnsafeMutablePointer(to: &position) {positionPtr in
                    CTRunGetPositions(run, glyphRange, positionPtr)
                }

                // Get a path for the glyph
                guard let glyphPath = CTFontCreatePathForGlyph(runFont, glyph, nil) else {
                    continue
                }

                // Transform the glyph as it is added to the final path
                let t = CGAffineTransform(translationX: position.x, y: position.y)
                path.addPath(glyphPath, transform: t)
            }
        }

        return path
    }
}

#endif
