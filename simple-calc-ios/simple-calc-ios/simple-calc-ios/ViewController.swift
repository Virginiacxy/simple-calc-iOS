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
    var opSymbol: allOperators? = nil
    var operands:[Double] = []
    var noOpBefore: Bool = true
    var isDecimal: Bool = false
    var isRPNmode: Bool = false
    var history: [String] = []
    var histStr: String = ""
    var currentDisplay: String = ""
    
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
        displayPanel.text = currentDisplay
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
        addToHistory(input: sender.currentTitle!)
        displayPanel.text = input
    }
    
    func addToHistory(input: String) {
        if isRPNmode && histStr == "" {
            histStr = "RPN mode: "
        }
        histStr += input
        NSLog(histStr)
    }
    
    @IBAction func operatorInput(_ sender: UIButton) {
        addToHistory(input: " " + sender.currentTitle! + " ")
        noOpBefore = false
        NSLog(input)
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
                        input = "Input should be non-negative."
                        displayPanel.text = input
                    } else if operands[0] == 0 {
                        input = "1"
                        displayPanel.text = input
                    } else {
                        for var i in 1...Int(operands[0]) {
                            fact = fact * i
                            i += 1
                        }
                        input = "\(fact)"
                    }
                }
                operands = []
                isDecimal = false;
                addToHistory(input: "= \(input)")
                history.append(histStr)
                histStr = ""
            default: NSLog("unknown operator")
            }
            displayPanel.text = input
        } else {
            addToHistory(input: "= ")
            if operands.count > 1 || sender.currentTitle! == "Fact" || sender.currentTitle! == "Avg" || sender.currentTitle! == "Count" {
                var result: Double = 0
                switch sender.currentTitle! {
                case "+": result = operands[0] + operands[1]
                    opSymbol = allOperators.add
                case "-": result = operands[0] - operands[1]
                    opSymbol = allOperators.sub
                case "×": result = operands[0] * operands[1]
                    opSymbol = allOperators.mul
                case "÷": result = operands[0] / operands[1]
                    opSymbol = allOperators.div
                case "%": result = operands[0].truncatingRemainder(dividingBy: operands[1])
                    opSymbol = allOperators.mod
                case "Count": result = Double(operands.count)
                    opSymbol = allOperators.count
                case "Avg":
                    opSymbol = allOperators.avg
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
                if sender.currentTitle! == "Fact" {
                    if result == 0 {
                        displayPanel.text = input
                        addToHistory(input: input)
                    } else {
                        displayPanel.text = "\(Int(result))"
                        addToHistory(input: "\(Int(result))")
                    }
                } else if isDecimal && opSymbol != .count || opSymbol == .div || opSymbol == .mod || opSymbol == .avg {
                    displayPanel.text = "\(result)"
                    addToHistory(input: "\(result)")
                } else {
                    displayPanel.text = "\(Int(result))"
                    addToHistory(input: "\(Int(result))")
                }
            } else {
                addToHistory(input: " \(input)")
            }
            operands = []
            isDecimal = false
            history.append(histStr)
            histStr = ""
        }
    }

    @IBAction func enterKeyPressed(_ sender: UIButton) {
        noOpBefore = false
        if input != "Avg" && input != "Count" {
            operands.append(Double(input)!)
        }
        if !isRPNmode {
            histStr = histStr.trimmingCharacters(in: .whitespaces)
            addToHistory(input: " = ")
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
                    addToHistory(input: "\(result)")
                } else {
                    displayPanel.text = "\(Int(result))"
                    addToHistory(input: "\(Int(result))")
                }
                
            } else {
                addToHistory(input: "\(input)")
            }
            operands = []
            isDecimal = false
            history.append(histStr)
            histStr = ""
        } else {
            addToHistory(input: " ")
        }
    }
    
    @IBAction func cleanThePanel(_ sender: UIButton) {
        input = ""
        displayPanel.text = ""
    }
    
    @IBAction func decimalIndicator(_ sender: UIButton) {
        input += sender.currentTitle!
        addToHistory(input: ".")
        displayPanel.text = input
        isDecimal = true
    }
    
    @IBAction func changeRPNmode(_ sender: UISwitch) {
        isRPNmode = sender.isOn
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "HistSegue":
            let source = segue.source as! ViewController
            let destination = segue.destination as! HistoryViewController
            destination.history = source.history
            destination.histStr = source.histStr
            destination.opSymbol = source.opSymbol
            destination.input = source.input
            destination.operands = source.operands
            destination.noOpBefore = source.noOpBefore
            destination.isDecimal = source.isDecimal
            destination.isRPNmode = source.isRPNmode
            destination.currentDisplay = source.displayPanel.text!
            
        default: NSLog("Unkown segue identifier -- " + segue.identifier!)
        }
    }
}
