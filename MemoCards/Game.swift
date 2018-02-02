//
//  Game.swift
//  MemoCards
//
//  Created by Ostin Ostwald on 1/30/18.
//  Copyright © 2018 Ostin Ostwald. All rights reserved.
//

import Foundation

final class Game {
    
    //MARK: - Properties
    
    var difficulty: String
    var score: String
    var name: String

    init(difficulty: Int, time: Int, name: String) {
        self.difficulty = "\(difficulty)"
        let result = 500 + difficulty - time
        if result > 500{
            self.score = "500"
        } else {
            self.score = "\(result)"
        }
        self.name = name
    }
}

