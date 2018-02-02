//
//  CardsVC.swift
//  MemoCards
//
//  Created by Ostin Ostwald on 1/15/18.
//  Copyright © 2018 Ostin Ostwald. All rights reserved.
//

import UIKit
import CoreData

class CardsVC: UIViewController {
    
    public var numOfCells = 6
    private var screenShotFlag = false
    private var counter: Int = 0
    private var timer: Timer = Timer()
    private var selectedIndexes: [IndexPath] = []
    private var reloadThread: DispatchWorkItem?
    
    private lazy var cards = {
        return Card.generateCards(size: numOfCells)
    }()
    
    @IBOutlet private weak var collView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRandomCards()
        NotificationCenter.default.addObserver(self, selector: #selector(test), name: .UIApplicationUserDidTakeScreenshot, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.incrementTimer), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    @IBAction func gameRefresh(_ sender: UIBarButtonItem) {
        getRandomCards()
        counter = 0
        collView.reloadData()
    }
    
    @objc private func incrementTimer(){
        counter += 1
    }
    
    @objc private func test() {
       
        if screenShotFlag {
         let ac = UIAlertController(title: "You are cheating!", message: nil, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Yeap", style: .destructive){  _ in
                self.navigationController?.popViewController(animated: true)
                }
                 ac.addAction(submitAction)
                 present(ac, animated: true)
            
        }else{
            let ac = UIAlertController(title: "Why did you take a screenshot? Are you cheating?", message: nil, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Yeap", style: .destructive){  _ in
                self.navigationController?.popViewController(animated: true)
            }
            let cancelAction = UIAlertAction(title: "Nope", style: .default){ _ in
                self.screenShotFlag = true
            }
            ac.addAction(submitAction)
            ac.addAction(cancelAction)
            present(ac, animated: true)
        }
    }
    
    private func getRandomCards() {
        cards = Card.generateCards(size: numOfCells)
    }
    
    private func didFinishGame() -> Bool {
        for card in cards {
            if !(card.isHidden || card.isChoosed) {
                return false
            }
        }
        
        return true
    }
    
    private func saveToCoreData(game: Game) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Leaderboard",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(game.name, forKeyPath: "name")
        person.setValue(game.difficulty, forKey: "difficulty")
        person.setValue(game.score, forKey: "score")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func finishGame() {
        
        
        let ac = UIAlertController(title: "Enter your name:", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){ [unowned ac] _ in
            let gamerNameField = ac.textFields![0]
            if let name = gamerNameField.text {
                if name == "" {
                    let score = Game(difficulty: self.numOfCells, time: self.counter, name: "No Name")
                    self.saveToCoreData(game:  score)
                } else {
                    let score = Game(difficulty: self.numOfCells, time: self.counter, name: name)
                    self.saveToCoreData(game:  score)
                }
            } else {
                let score = Game(difficulty: self.numOfCells, time: self.counter, name: "No Name")
                self.saveToCoreData(game: score)
        
            self.navigationController?.popViewController(animated: true)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ [unowned ac] _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        
       present(ac, animated: true)
        }
    
    private func compare(selectedCards: [Card]) {
        
        if selectedCards[0].compareWith(card: selectedCards[1]) {
            cards[selectedIndexes[0].row].isHidden = true
            cards[selectedIndexes[1].row].isHidden = true
        } else {
            for index in selectedIndexes {
                let card = self.cards[index.row]
                card.isChoosed = false
            }
        }
        selectedIndexes = []
        collView.reloadData()
    }
}

extension CardsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        defer {
            collectionView.reloadData()
            if didFinishGame() {
                finishGame()
            }
        }
        let card = cards[indexPath.row]
        guard !card.isChoosed else {
            return
        }
        reloadThread?.cancel()
        if selectedIndexes.count == 2 {
            let card1 = cards[selectedIndexes[0].row]
            let card2 = cards[selectedIndexes[1].row]
            compare(selectedCards: [card1, card2])
        }
        card.isChoosed = true
        selectedIndexes.append(indexPath)
        if selectedIndexes.count == 2 {
            reloadThread = DispatchWorkItem(block: {
                guard self.selectedIndexes.count == 2 else {
                    return
                }
                let card1 = self.cards[self.selectedIndexes[0].row]
                let card2 = self.cards[self.selectedIndexes[1].row]
                self.compare(selectedCards: [card1, card2])
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: reloadThread ?? DispatchWorkItem(block: {}))
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
        
        let card = cards[indexPath.item]
        cell.isHidden = card.isHidden
        if card.isChoosed {
            cell.backgroundColor = UIColor.clear
            cell.image.image = UIImage(named: card.assetName)
        } else {
            cell.image.image = UIImage(named: cell.card.cardBackIm)
            
        }
        return cell
    }
}

extension CardsVC: UICollectionViewDelegateFlowLayout{
    func cellsRowAndColomn() -> (cellInRow: Int, cellInColomn: Int){
        var cellInRow = Int(floor(sqrt(Double(numOfCells))))
        while (numOfCells % cellInRow != 0) {
            cellInRow -= 1
            if (cellInRow == 1) {
                break
            }
        }
        let cellInColomn = numOfCells / cellInRow
        return (cellInRow, cellInColomn)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        let screenHeight = collectionView.frame.height
        let cell = cellsRowAndColomn()
        if (screenWidth < screenHeight) {
            return CGSize(width: screenWidth/CGFloat(cell.cellInRow) - 10, height: screenHeight/CGFloat(cell.cellInColomn) - 10)
        } else {
            return CGSize(width: screenWidth/CGFloat(cell.cellInColomn) - 10, height: screenHeight/CGFloat(cell.cellInRow) - 10)
        }
    }
}

