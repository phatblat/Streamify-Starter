//
//  Util.swift
//  Streamify
//
//  Created by Marin Todorov on 8/11/15.
//  Copyright (c) 2015 Underplot ltd. All rights reserved.
//

import UIKit

func skipIfSeen(sender: UIViewController, nextIdentifier: String) {
    let key = sender.classForCoder.description()
    let seen = NSUserDefaults.standardUserDefaults().boolForKey(key)
    if seen {
        if let nextVC = sender.storyboard?.instantiateViewControllerWithIdentifier(nextIdentifier) as? UIViewController {
            //println("seen \(key) skipping to \(nextIdentifier)")
            sender.navigationController?.pushViewController(nextVC, animated: false)
        }
    }
}

func markAsSeen(sender: UIViewController, seen: Bool) {
    //println("mark as seen \(sender.classForCoder.description()) to \(seen)")
    NSUserDefaults.standardUserDefaults().setBool(seen, forKey: sender.classForCoder.description())
    NSUserDefaults.standardUserDefaults().synchronize()
}

func delay(#seconds: Double, completion:()->()) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * seconds ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

protocol StarterProjectCode {}