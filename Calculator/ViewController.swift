//
//  ViewController.swift
//  Calculator
//
//  Created by Augusto Spinelli on 09/11/16.
//  Copyright © 2016 Augusto Spinelli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping : Bool = false
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    var savedProgram : CalculatorBrain.PropertyList?
    @IBAction func save() {
        savedProgram = brain.program
    }

    @IBAction func load() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
        
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        print("touchDigit \(sender.currentTitle!)")
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            
            let displayedText = self.display!.text!
            display.text = displayedText + digit
        } else  {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
        
    }
    private var brain = CalculatorBrain()
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol: symbol)
        }
        displayValue = brain.result
        
    }

}

