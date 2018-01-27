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
    private var selectedIndexes: [IndexPath] = []
    
    private lazy var cards = {
        return Card.generateCards(size: numOfCells)
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("Hello I have to create \(numOfCells)")
        

        // Do any additional setup after loading the view.
    }
    
    private func compare(selectedCards: [Card]) {
        if selectedCards[0].compareWith(card: selectedCards[1]) {
            cards[selectedIndexes[0].row].isHidden = true
            cards[selectedIndexes[1].row].isHidden = true
            selectedIndexes = []
        } else {
            for index in selectedIndexes {
                let card = self.cards[index.row]
                card.isChoosed = false
            }
            selectedIndexes = []
        }
        collView.reloadData()
    }
    
}

extension CardsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.reloadItems(at: [indexPath])
        }
    
        if selectedIndexes.count == 2 {
            let card1 = cards[selectedIndexes[0].row]
            let card2 = cards[selectedIndexes[1].row]
            compare(selectedCards: [card1, card2])
        }
        let card = cards[indexPath.row]
        card.isChoosed = true
        selectedIndexes.append(indexPath)
        if selectedIndexes.count == 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                guard self.selectedIndexes.count == 2 else {
                    return
                }
                let card1 = self.cards[self.selectedIndexes[0].row]
                let card2 = self.cards[self.selectedIndexes[1].row]
                self.compare(selectedCards: [card1, card2])
            })
        }
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
            cell.isHidden = card.isHidden
            if card.isChoosed {
                cell.backgroundColor = UIColor.clear
                cell.image.image = UIImage(named: card.assetName)
            } else {
                cell.image.image = UIImage(named: cell.card.cardBackIm)
                cell.backgroundColor = UIColor.cyan
            }
        }
        return cell
    }
}
