//
//  ResultCell.swift
//  MemoCards
//
//  Created by Ostin Ostwald on 2/1/18.
//  Copyright © 2018 Ostin Ostwald. All rights reserved.
//

import UIKit

final class ResultCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func setUpCell(name: String, difficulty: String, score: String) {
        nameLabel.text = name
        levelLabel.text = difficulty
        scoreLabel.text = score
    }
    
}
