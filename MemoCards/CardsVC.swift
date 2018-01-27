//
//  CardsVC.swift
//  MemoCards
//
//  Created by Ostin Ostwald on 1/15/18.
//  Copyright © 2018 Ostin Ostwald. All rights reserved.
//

import UIKit

class CardsVC: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    public var numOfCells = 6
    private var openedCardIndex: Int?
    private var comparingCardIndex: Int?
    private var selectedIndexes: [IndexPath] = []
    private var isReloaded: Bool = false
    private var cardsToHide: [Card] = []
    private var cardsFounded = 0
    private var isFinished: Bool = true
    
    private lazy var cards = {
        return Card.generateCards(size: numOfCells)
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("Hello I have to create \(numOfCells)")
        

        // Do any additional setup after loading the view.
    }

}

extension CardsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard isFinished else {
            return
        }
        defer {
            collectionView.reloadItems(at: [indexPath])
        }
    
//        if self.selectedIndexes.count == 2 {
//            for index in self.selectedIndexes {
//                let card = self.cards[index.row]
//                card.isChoosed = false
//            }
//            self.openedCardIndex = nil
//            selectedIndexes = []
//            isReloaded = true
//            if cardsToHide.count == 2 {
//                for card in cardsToHide {
//                    card.isHidden = true
//                }
//                cardsToHide = []
//            }
//            collectionView.reloadData()
//        }
        
        let card = cards[indexPath.row]
        card.isChoosed = true
        
        selectedIndexes.append(indexPath)
        
        if selectedIndexes.count == 1 {
            openedCardIndex = indexPath.row
        }
        
        if selectedIndexes.count == 2 {
            isFinished = false
            if card.compareWith(card: cards[openedCardIndex!]) {
                let openIndex = openedCardIndex

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    self.isFinished = true
//                    guard self.cardsToHide.count == 2 else {
//                        self.cardsToHide = []
//                        return
//                    }
                    card.isHidden = true
                    self.cards[openIndex!].isHidden = true
                    for index in self.selectedIndexes {
                        let card = self.cards[index.row]
                        card.isChoosed = false
                    }
                    self.openedCardIndex = nil
                    self.selectedIndexes = []
                    collectionView.reloadData()
                })
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    self.isFinished = true
//                    guard !self.isReloaded else {
//                        self.isReloaded = false
//                        return
//                    }
                    for index in self.selectedIndexes {
                        let card = self.cards[index.row]
                        card.isChoosed = false
                    }
                    self.openedCardIndex = nil
                    self.selectedIndexes = []
                    collectionView.reloadData()
                })
            }
        }
        
//        if selectedIndexes.count == 2 {
//            isFinished = false
//            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
//                self.isFinished = true
//                guard !self.isReloaded else {
//                    self.isReloaded = false
//                    return
//                }
//                for index in self.selectedIndexes {
//                    let card = self.cards[index.row]
//                    card.isChoosed = false
//                }
//                self.openedCardIndex = nil
//                self.selectedIndexes = []
//                collectionView.reloadData()
//            })
//        }
        
        
        
//        if let openedIndex = openedCardIndex {
//            let comparingCard = cards[openedIndex]
//
//
//            if card.compareWith(card: comparingCard) {
//                self.comparingCardIndex = indexPath.row
//                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
//                    card.isHidden = true
//                    comparingCard.isHidden = true
//                    collectionView.reloadData()
//                    if self.numberOfCardSelected == 2 {
//                        self.numberOfCardSelected = 0
//                    }
//                })
//            } else {
//                comparingCardIndex = indexPath.row
//                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
//                    self.openedCardIndex = nil
//                    self.comparingCardIndex = nil
//                    collectionView.reloadData()
//                    if self.numberOfCardSelected == 2 {
//                        self.numberOfCardSelected = 0
//                    }
//                })
//            }
//        } else {
//            openedCardIndex = indexPath.row
//        }
    }
}

extension CardsVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return numOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PicCellCVC
        cell.card = cards[indexPath.row]
        if(numOfCells > 20){
            cell.backgroundColor = UIColor.black
            cell.frame.size = CGSize(width: 95, height: 85 )
        }else{
            let card = cards[indexPath.item]
            //cell.backgroundColor = UIColor.cyan
            if card.isHidden {
                cell.isHidden = true
            } else {
                cell.isHidden = false
            }
            if card.isChoosed {
                cell.backgroundColor = UIColor.clear
                cell.image.image = UIImage(named: card.assetName)
            } else {
                cell.image.image = UIImage(named: cell.card.cardBackIm)
                cell.backgroundColor = UIColor.cyan
            }
            
//            if openedCardIndex == indexPath.row || comparingCardIndex == indexPath.row {
//                cell.image.image = UIImage(named: card.assetName)
//                cell.backgroundColor = UIColor.clear
//            } else {
//                cell.image.image = nil
//                cell.backgroundColor = UIColor.cyan
//            }
        }
        
        return cell
    }
}
