//
//  ViewController.swift
//  simple-calc-ios
//
//  Created by Xinyue Chen on 10/19/17.
//  Copyright © 2017 Xinyue Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var displayPanel: UITextField!
    var input: String = ""
    var operand: Int = 0
    var opSymbol: allOperators? = nil
    var operands:[Double] = []
    var noOpBefore: Bool = true
    var isDecimal: Bool = false
    var isRPNmode: Bool = false
    
    enum allOperators {
        case add
        case sub
        case mul
        case div
        case mod
        case count
        case avg
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func numberInput(_ sender: UIButton) {
        if !noOpBefore {
            input = ""
            noOpBefore = true
        }
        input += sender.currentTitle!
        displayPanel.text = input
    }
    
    @IBAction func operatorInput(_ sender: UIButton) {
        noOpBefore = false
        operands.append(Double(input)!)
        if !isRPNmode {
            input = sender.currentTitle!
            switch input {
            case "+": opSymbol = allOperators.add
            case "-": opSymbol = allOperators.sub
            case "×": opSymbol = allOperators.mul
            case "÷": opSymbol = allOperators.div
            case "%": opSymbol = allOperators.mod
            case "Count": opSymbol = allOperators.count
            case "Avg": opSymbol = allOperators.avg
            case "Fact":
                var fact = 1
                if isDecimal {
                    input = "Can't calculate the factorial of float"
                } else {
                    if operands[0] < 0 {
                        displayPanel.text = "Input should be non-negative."
                    } else if operands[0] == 0 {
                        displayPanel.text = "1"
                    } else {
                        for var i in 1...Int(operands[0]) {
                            fact = fact * i
                            i += 1
                        }
                        input = "\(fact)"
                    }
                    operands = []
                }
            default: NSLog("unknown operator")
            }
            displayPanel.text = input
        } else {
            if operands.count > 1 || sender.currentTitle! == "Fact" || sender.currentTitle! == "Avg" || sender.currentTitle! == "Count" {
                var result: Double = 0
                switch sender.currentTitle! {
                case "+": result = operands[0] + operands[1]
                case "-": result = operands[0] - operands[1]
                case "×": result = operands[0] * operands[1]
                case "÷": result = operands[0] / operands[1]
                case "%": result = operands[0].truncatingRemainder(dividingBy: operands[1])
                case "Count": result = Double(operands.count)
                case "Avg":
                    var sum: Double = 0
                    for num in operands {
                        sum += num
                    }
                    result = sum / Double(operands.count)
                case "Fact":
                    var fact = 1
                    if operands.count > 1 {
                        input = "Factorial can only accept one input."
                    } else if isDecimal {
                        input = "Can't calculate the factorial of float."
                    } else {
                        if operands[0] < 0 {
                            input = "Input should be non-negative."
                        } else if operands[0] == 0 {
                            result = 1
                        } else {
                            for var i in 1...Int(operands[0]) {
                                fact = fact * i
                                i += 1
                            }
                            result = Double(fact)
                        }
                    }
                default: NSLog("unknown operator")
                }
                if sender.currentTitle! == "Fact" && result == 0 {
                    displayPanel.text = input
                } else if isDecimal && opSymbol != .count || opSymbol == .div || opSymbol == .mod || opSymbol == .avg {
                    displayPanel.text = "\(result)"
                } else {
                    displayPanel.text = "\(Int(result))"
                }
            }
            operands = []
            isDecimal = false
        }
    }

    @IBAction func enterKeyPressed(_ sender: UIButton) {
        noOpBefore = false
        if input != "Avg" && input != "Count" {
            operands.append(Double(input)!)
        }
        if !isRPNmode {
            var result: Double = 0
            if operands.count > 1 || opSymbol == .count || opSymbol == .avg {
                switch opSymbol! {
                case .add: result = operands[0] + operands[1]
                case .sub: result = operands[0] - operands[1]
                case .mul: result = operands[0] * operands[1]
                case .div: result = operands[0] / operands[1]
                case .mod: result = operands[0].truncatingRemainder(dividingBy: operands[1])
                case .count: result = Double(operands.count)
                case .avg:
                    var sum: Double = 0
                    for num in operands {
                        sum += num
                    }
                    result = sum / Double(operands.count)
                }
                if isDecimal && opSymbol != .count || opSymbol == .div || opSymbol == .mod || opSymbol == .avg {
                    displayPanel.text = "\(result)"
                } else {
                    displayPanel.text = "\(Int(result))"
                }
            }
            operands = []
            isDecimal = false
        }
    }
    
    @IBAction func cleanThePanel(_ sender: UIButton) {
        input = ""
        displayPanel.text = ""
    }
    
    @IBAction func decimalIndicator(_ sender: UIButton) {
        input += sender.currentTitle!
        displayPanel.text = input
        isDecimal = true
    }
    
    @IBAction func changeRPNmode(_ sender: UISwitch) {
        isRPNmode = sender.isOn
    }
}
