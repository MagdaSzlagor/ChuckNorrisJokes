//
//  String+CNJ.swift
//  ChuckNorrisJokes
//
//  Created by Magdalena Szlagor on 05/05/2018.
//  Copyright © 2018 Magdalena Szlagor. All rights reserved.
//

import Foundation

extension String {
    func trailingTrim(_ characterSet : CharacterSet) -> String {
        if let range = rangeOfCharacter(from: characterSet, options: [.anchored, .backwards]) {
            return String(self[..<range.lowerBound]).trailingTrim(characterSet)
        }
        return self
    }
}
