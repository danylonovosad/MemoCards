//
//  ScoreVC.swift
//  MemoCards
//
//  Created by Ostin Ostwald on 2/1/18.
//  Copyright © 2018 Ostin Ostwald. All rights reserved.
//

import UIKit
import CoreData

final class ScoreVC: UIViewController {
    
    //MARK: - Private Properties
    private var leaderbord: [NSManagedObject] = []
    
    //MARK: - Private IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    
    //MARK: - Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib.init(nibName: "ResultCell", bundle: nil), forCellReuseIdentifier: "ResultCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Leaderboard")
        
        do {
            leaderbord = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Private Functions
    private func shareApp(){
        let someText:String = "Hello! Let me introduce to you a beautiful game made by SoftServe ITA student. For a small donation on this card(5375 4141 0051 0600) he can install it on your device. You can ask him about that game on his facebook page: "
        let objectsToShare:URL = URL(string: "http://www.facebook.com/novosad.danylo")!
        let sharedObjects:[AnyObject] = [someText as AnyObject, objectsToShare as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: - Private IBActions
    @IBAction private func shareBtn(_ sender: UIBarButtonItem) {
        shareApp()
    }

}

extension ScoreVC: UITableViewDelegate, UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderbord.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = leaderbord[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell",
                                          for: indexPath) as! ResultCell
        guard let name = result.value(forKeyPath: "name") as? String,
            let difficulty = result.value(forKeyPath: "difficulty") as? String,
            let score = result.value(forKeyPath: "score") as? String else {
                return UITableViewCell()
        }
        cell.setUpCell(name: name, difficulty: difficulty, score: score)
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
