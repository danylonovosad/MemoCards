//
//  ChoiceVC.swift
//  MemoCards
//
//  Created by Ostin Ostwald on 1/10/18.
//  Copyright © 2018 Ostin Ostwald. All rights reserved.
//

import UIKit

class ChoiceVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerValue: Int = 6 // тому що якщо зразу кнопку нажати то воно а не зайде в didSelectRow


    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerValue = (Int (difPickerData[row]))!   // костиль виправити "!" || хоча не дуже костиль тому що пікер завжди в якомусь положені так що все ок ніби
        print(pickerValue)
    
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
  
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return difPickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return difPickerData[row]
    }
    @IBAction func goBtn(_ sender: UIButton) {
     print(pickerValue)
        performSegue(withIdentifier: "toGame", sender: self)
    }
    
    @IBOutlet weak var difPicker: UIPickerView!
    var difPickerData: [String] = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.difPicker.delegate = self
        self.difPicker.dataSource = self
        difPickerData = ["6","12","18","22"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame"
        {
            if let destinationVC = segue.destination as? CardsVC {
                destinationVC.numOfCells = pickerValue

            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
