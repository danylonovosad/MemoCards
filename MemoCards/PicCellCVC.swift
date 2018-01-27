//
//  PicCellCVC.swift
//  MemoCards
//
//  Created by Ostin Ostwald on 1/15/18.
//  Copyright © 2018 Ostin Ostwald. All rights reserved.
//

import UIKit

class PicCellCVC: UICollectionViewCell {
    public var card: Card!
    public var isChoosed: Bool = false
    @IBOutlet weak var image: UIImageView!
}
