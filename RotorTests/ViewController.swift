//
//  ViewController.swift
//  RotorTests
//
//  Created by Lucas Santos on 23/07/18.
//  Copyright © 2018 Lucas Santos (https://github.com/lucas1295santos). All rights reserved.
//  Look up WWDC Session (https://developer.apple.com/videos/play/wwdc2016/202/) for more on the subject
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rotorPropertyValueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var searchDistance: Int = 5
    
    //Tableview data
    private var iceCreamList = [IceCream]()
    private var filteredIceCreamList = [IceCream]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableviewData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let distanceRotor = self.setupDistanceRotor()
        let chocolateRotor = self.setupChocolateRotor()
        
        //Add this rotor option to the iOS rotor, so the user can find it while in yor app
        self.accessibilityCustomRotors = [distanceRotor, chocolateRotor]
        
        self.filterIceCreamList()
    }
    
    private func setupDistanceRotor() -> UIAccessibilityCustomRotor {
        
        //Create a custor Rotor option, it has a name that will be read by voice over, and a action that is a
        //action called when this rotor option is interacted with.
        //The predicate gives you info about the state of this interaction
        let propertyRotorOption = UIAccessibilityCustomRotor.init(name: "Filter distance") { (predicate) -> UIAccessibilityCustomRotorItemResult? in
            
            //Get the direction of the movement when this rotor option is enablade
            let forward = predicate.searchDirection == UIAccessibilityCustomRotorDirection.next
            
            //You can do any kind of business logic processing here
            if forward {
                self.searchDistance += 1
            } else {
                self.searchDistance -= 1
            }
            
            self.filterIceCreamList()
            
            self.rotorPropertyValueLabel.text = String(self.searchDistance)
            
            //Return the selection of voice over to the element rotorPropertyValueLabel
            //Use this return to select the desired selection that fills the purpose of its logic
            return UIAccessibilityCustomRotorItemResult.init(targetElement: self.rotorPropertyValueLabel , targetRange: nil)
        }
        
        return propertyRotorOption
    }
    
    private func setupChocolateRotor() -> UIAccessibilityCustomRotor {
        
        let chocolateRotor = UIAccessibilityCustomRotor.init(name: "Find chocolate") { (predicate) -> UIAccessibilityCustomRotorItemResult? in
            
            //Get the direction of the movement when this rotor option is enablade
            let forward = predicate.searchDirection == UIAccessibilityCustomRotorDirection.next
            
            /// Prepare for starting the cell inspection botton to top or top to botton
            var currentRow = forward ? -1 : self.iceCreamList.count

            /// Find the current element selected by Voice Over
            if let currentElement = predicate.currentItem.targetElement {
                if let cell = currentElement as? IceCreamTableViewCell {
                    currentRow = self.tableView.indexPath(for: cell)?.row ?? currentRow
                }
            }
            
            /// Helper to make navigation easier back and forth
            let nextSearchRow = { (row: Int) -> Int in
                return forward ? row + 1 : row - 1
            }
            
            var searchRow = nextSearchRow(currentRow)
            
            /// Iterates through the cell finding elements that match the Chocolate filter
            while searchRow >= 0 && searchRow < self.iceCreamList.count {
                if self.iceCreamList[searchRow].flavor.contains("Chocolate") {
                    let indexPath = IndexPath(row: searchRow, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .none, animated: false)
                    let cell = self.tableView.cellForRow(at: indexPath)!
                    
                    //Returns the cell as the new target for Voice Over to focus on
                    return UIAccessibilityCustomRotorItemResult(targetElement: cell, targetRange: nil)
                }
                searchRow = nextSearchRow(searchRow)
            }
            
            /// No elements suitable to focus. A nil return gives a audible feedback to the user that there Over
            ///  are no more elements for Voice to focus on
            return nil
        }
        
        return chocolateRotor
    }
    
    private func filterIceCreamList() {
        self.filteredIceCreamList = self.iceCreamList.filter { (iceCream) -> Bool in
            return iceCream.distance <= Double(self.searchDistance)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /// Simple mockup table view setup
    private func setupTableviewData() {
        self.iceCreamList.append(IceCream(flavor: "Strawberry", distance: 7))
        self.iceCreamList.append(IceCream(flavor: "Crunchy Chocolate", distance: 3))
        self.iceCreamList.append(IceCream(flavor: "Lemon", distance: 8))
        self.iceCreamList.append(IceCream(flavor: "Chocolate and mint", distance: 2))
        self.iceCreamList.append(IceCream(flavor: "Bacon", distance: 1))
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredIceCreamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? IceCreamTableViewCell
        
        guard let iceCreamCell = cell else {
            return UITableViewCell()
        }
        
        iceCreamCell.flavorLabel.text = self.filteredIceCreamList[indexPath.row].flavor
        iceCreamCell.distanceLabel.text = String(format: "%.2f", self.filteredIceCreamList[indexPath.row].distance) + "Km"
        
        return iceCreamCell
    }


}

