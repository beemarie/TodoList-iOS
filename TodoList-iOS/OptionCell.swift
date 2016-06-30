//
//  OptionCell.swift
//  TodoList-iOS
//
//  Created by Aaron Liberatore on 6/29/16.
//  Copyright © 2016 Swift@IBM Engineering. All rights reserved.
//
import UIKit

class OptionCell: UITableViewCell {
    @IBOutlet var showButton: UIButton!

    @IBAction func onShowCompleted(sender: UIButton) {
        print(showButton.titleLabel?.text!)
        if showButton.titleLabel?.text! == "Show Completed" {
            showButton.titleLabel?.text! = "Hide Completed"
        } else {
            showButton.titleLabel?.text! = "Show Completed"
        }
        print(showButton.titleLabel?.text!)
    }
}
