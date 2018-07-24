//
//  ViewController.swift
//  RotorTests
//
//  Created by Lucas Santos on 23/07/18.
//  Copyright © 2018 Lucas Santos (https://github.com/lucas1295santos). All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var rotorPropertyValueLabel: UILabel!
    
    private var rotorPropertyValue: Int = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCustonRotor()
    }
    
    private func setupCustonRotor() {
        
        //Create a custor Rotor option, it has a name that will be read by voice over, and a action that is a
        //action called when this rotor option is interacted with.
        //The predicate gives you info about the state of this interaction
        let propertyRotorOption = UIAccessibilityCustomRotor.init(name: "Custon Property") { (predicate) -> UIAccessibilityCustomRotorItemResult? in
            
            //Get the direction of the movement when this rotor option is enablade
            let forward = predicate.searchDirection == UIAccessibilityCustomRotorDirection.next
            
            //You can do any kind of business logic processing here
            if forward {
                self.rotorPropertyValue += 5
            } else {
                self.rotorPropertyValue -= 5
            }
            
            self.rotorPropertyValueLabel.text = String(self.rotorPropertyValue)
            
            //Return the selection of voice over to the element rotorPropertyValueLabel
            //Use this return to select the desired selection that fills the purpose of its logic
            return UIAccessibilityCustomRotorItemResult.init(targetElement: self.rotorPropertyValueLabel , targetRange: nil)
        }
        
        //Add this rotor option to the iOS rotor, so the user can find it while in yor app
        self.accessibilityCustomRotors = [propertyRotorOption]
    }
    
    

}

