//
//  AddButtonDelegate.swift
//  Hint.e
//
//  Created by Emily Lynam on 9/21/16.
//  Copyright © 2016 Emily Lynam. All rights reserved.
//

import Foundation
import UIKit

protocol AddPlayerTableViewControllerDelegate: class {
    func addPlayerTableViewController(controller: AddPlayerTableViewController, didFinishAddingPlayer names: [String])
    
}
