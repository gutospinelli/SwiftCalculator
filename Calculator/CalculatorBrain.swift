//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Augusto Spinelli on 09/11/16.
//  Copyright © 2016 Augusto Spinelli. All rights reserved.
//

import Foundation


class CalculatorBrain {
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    var operations : Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI), // M_PI,
        "e" : Operation.Constant(M_E), // M_E
        "√" : Operation.Unary(sqrt),
        "cos" : Operation.Unary(cos),
        "sin" : Operation.Unary(sin),
        "+" : Operation.Binary({return $0 + $1 }),
        "÷" : Operation.Binary({return $0 / $1 }),
        "×" : Operation.Binary({return $0 * $1 }),
        "−" : Operation.Binary({return $0 - $1 }),
        "=": Operation.Equals
    ]
    
    enum Operation {
        case Constant(Double)
        case Unary((Double) -> Double)
        case Binary((Double,Double) -> Double)
        case Equals
    }
    
    private var pending: PendingBinary?
    
    struct PendingBinary {
        var function : (Double,Double) -> Double
        var op1: Double
    }
    
    typealias PropertyList = AnyObject
    var program : PropertyList {
        get { return internalProgram as CalculatorBrain.PropertyList }
        set {
            clear()
            if let arrayOps = newValue as? [AnyObject] {
                for op in arrayOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Binary(let function):
                executePending()
                pending = PendingBinary(function: function, op1: accumulator)
            case .Constant(let value):
                accumulator = value
            case .Equals:
                executePending()
            case .Unary(let function):
                accumulator = function(accumulator)
            }
        }
        
        
    }
    
    private func executePending(){
        if pending != nil {
            accumulator = (pending?.function((pending?.op1)!, accumulator))!
            pending = nil
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
