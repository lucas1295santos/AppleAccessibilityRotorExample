//
//  ViewController.swift
//  RotorTests
//
//  Created by Lucas Santos on 23/07/18.
//  Copyright © 2018 Lucas Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rotorPropertyValueLabel: UILabel!
    
    private var rotorPropertyValue: Int = 50
    var customRotor: [UIAccessibilityCustomRotor]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let propertyRotorOption = UIAccessibilityCustomRotor.init(name: "Custon Property") { (predicate) -> UIAccessibilityCustomRotorItemResult? in
            
            let forward = predicate.searchDirection == UIAccessibilityCustomRotorDirection.next
            
            if forward {
                self.rotorPropertyValue += 5
            } else {
                self.rotorPropertyValue -= 5
            }
            
            self.rotorPropertyValueLabel.text = String(self.rotorPropertyValue)
            
            
            return UIAccessibilityCustomRotorItemResult.init(targetElement: self.rotorPropertyValueLabel , targetRange: nil)
        }
        
        self.accessibilityCustomRotors = [propertyRotorOption]
    }
    
    
    
//    @objc private func changeValueMethod() {
//        self.rotorPropertyValue += 5
//        self.rotorPropertyValueLabel.text = String(self.rotorPropertyValue)
//    }

}

