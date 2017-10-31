//
//  HistoryViewController.swift
//  simple-calc-ios
//
//  Created by Xinyue Chen on 10/26/17.
//  Copyright © 2017 Xinyue Chen. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    var history: [String] = []
    var size = 0
    var input: String = ""
    var opSymbol: ViewController.allOperators? = nil
    var operands:[Double] = []
    var noOpBefore: Bool = true
    var isDecimal: Bool = false
    var isRPNmode: Bool = false
    var histStr: String = ""
    var currentDisplay: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.backgroundColor = UIColor.black
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 945)
        if history.count > 20 {
            size = history.count - 20
        }
        var index = 0
        for num in size..<history.count {
            index += 1
            let label = UILabel(frame: CGRect(x: 30, y: index * 45, width: 350, height: 50))
            label.textColor = UIColor.white
            label.text = history[num]
            self.scrollView.addSubview(label)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "CalcSegue":
            let source = segue.source as! HistoryViewController
            let destination = segue.destination as! ViewController
            destination.history = source.history
            destination.histStr = source.histStr
            destination.opSymbol = source.opSymbol
            destination.input = source.input
            destination.operands = source.operands
            destination.noOpBefore = source.noOpBefore
            destination.isDecimal = source.isDecimal
            destination.isRPNmode = source.isRPNmode
            destination.currentDisplay = source.currentDisplay
            
        default: NSLog("Unkown segue identifier -- " + segue.identifier!)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
