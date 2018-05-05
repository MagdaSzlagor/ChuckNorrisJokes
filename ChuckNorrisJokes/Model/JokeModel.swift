//
//  DataModel.swift
//  ChuckNorris
//
//  Created by Magdalena Szlagor on 04/05/2018.
//  Copyright © 2018 Magdalena Szlagor. All rights reserved.
//

import Foundation

class JokeModel: FAAutoCode {
    var jokeId: Int = 0
    var jokeText: String = ""
    var likedByUser: Bool = false
    
    override func setValue(_ value: Any?, forKey key: String) {
        if let _value = value {
            if key == "id" {
                jokeId = _value as! Int
            }
            else if key == "joke" {
                jokeText = _value as! String
            }
            else if key == "likedByUser" {
                likedByUser = _value as! Bool
            }
        }
    }
}
