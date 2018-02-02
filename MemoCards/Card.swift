//
//  Card.swift
//  MemoCards
//
//  Created by Ostin Ostwald on 1/17/18.
//  Copyright © 2018 Ostin Ostwald. All rights reserved.
//

import Foundation

class Card {
    var assetName: String
    var isHidden: Bool = false
    let cardBackIm = "cardBack"
    var isChoosed: Bool = false
    
    init (assetName: String) {
        self.assetName = assetName
    }
    
  internal static func generateCards(size: Int) -> [Card] {
        var cardArray = [Card]()
        for i in 0..<Int(size/2) {
            let card1 = Card(assetName: "Card\(i)")
            let card2 = Card(assetName: "Card\(i)")
            cardArray.append(card1)
            cardArray.append(card2)
        }
        
        cardArray.shuffle()
        return cardArray
    }
    
  internal func compareWith(card: Card) -> Bool {
        return self.assetName == card.assetName
    }
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}
