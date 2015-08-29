//
//  OnBoardingViewController.swift
//  Streamify
//
//  Created by Marin Todorov on 8/11/15.
//  Copyright (c) 2015 Underplot ltd. All rights reserved.
//

import UIKit

private let signupText = "Sign up for free with your email or get our paid subscription for up to 5 family members"
private let signupTextDetails = "Deal valid when subscription pre-paid for 37 months and extra family members aren't interested in music. \n\n If switching from a different music service you will receive a tap on the shoulder"

class OnBoardingViewController: UIViewController {
    
    @IBOutlet var signupView: UIView!
    @IBOutlet var signupDetails: UILabel!

    @IBOutlet var mixView: UIView!
    @IBOutlet var listenView: UIView!

    var startButton: UIButton!
    
    var views: [UIView]!
    
    var selectedView: UIView?
    var deselectCurrentView: (()->())?

    func showStartButton() {
        startButton = UIButton(type: .Custom)
        startButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9)
        startButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        startButton.setTitle("Start", forState: .Normal)
        startButton.titleLabel?.font = UIFont.systemFontOfSize(22.0)
        startButton.layer.cornerRadius = listenView.bounds.size.width/6
        startButton.layer.masksToBounds = true
        startButton.translatesAutoresizingMaskIntoConstraints = false

        startButton.addTarget(self, action: "actionStartListening:", forControlEvents: .TouchUpInside)
        
        listenView.addSubview(startButton)

        let conX = NSLayoutConstraint(item: startButton, attribute: .CenterX, relatedBy: .Equal, toItem: listenView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)

        let conY = NSLayoutConstraint(item: startButton, attribute: .Bottom, relatedBy: .Equal, toItem: listenView, attribute: .Bottom, multiplier: 0.67, constant: view.frame.size.height * 0.33)

        let conWidth = NSLayoutConstraint(item: startButton, attribute: .Width, relatedBy: .Equal, toItem: listenView, attribute: .Width, multiplier: 0.33, constant: 0.0)
        let conHeight = NSLayoutConstraint(item: startButton, attribute: .Height, relatedBy: .Equal, toItem: listenView, attribute: .Width, multiplier: 0.33, constant: 0.0)

        NSLayoutConstraint.activateConstraints([conX, conY, conWidth, conHeight])

        startButton.layoutIfNeeded()

        UIView.animateWithDuration(1.33, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [.BeginFromCurrentState, .AllowUserInteraction], animations: {
            conY.constant = 0.0
            self.startButton.layoutIfNeeded()
            }, completion: nil)
    }

    func hideStartButton() {
        startButton.removeFromSuperview()
    }

    func adjustHeights(viewToSelect: UIView) {
        for constraint in viewToSelect.superview!.constraints {
            if constraint.identifier == "StripHeight" {
                constraint.active = false

                let multiplier =
                    (viewToSelect == constraint.firstItem as! UIView)
                    ? 0.55 : 0.23

                let con = NSLayoutConstraint(item: constraint.firstItem, attribute: .Height, relatedBy: .Equal, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: CGFloat(multiplier), constant: 0)

                con.identifier = "StripHeight"
                con.active = true
            }
        }
    }

    func toggleView(tap: UITapGestureRecognizer) {
        deselectCurrentView?()
        deselectCurrentView = nil

        selectedView = tap.view!

        adjustHeights(tap.view!)

        UIView.animateWithDuration(1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func toggleSignup(tap: UITapGestureRecognizer) {
        if selectedView == tap.view! {
            return
        }
        
        toggleView(tap)

    }
    
    func toggleMix(tap: UITapGestureRecognizer) {
        if selectedView == tap.view! {
            return
        }
        
        toggleView(tap)
        deselectCurrentView = nil
    }
    
    func toggleListen(tap: UITapGestureRecognizer) {
        if selectedView == tap.view! {
            return
        }
        
        toggleView(tap)

        showStartButton()

        deselectCurrentView = {
            self.hideStartButton()
        }
    }
    
    func actionStartListening(sender: AnyObject) {
        performSegueWithIdentifier("showPlaylists", sender: sender)
    }
}

//MARK: - Starter project code
extension OnBoardingViewController: StarterProjectCode {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skipIfSeen(self, nextIdentifier: "PlaylistsViewController")
        
        views = [signupView, mixView, listenView]
        
        let singupTap = UITapGestureRecognizer(target: self, action: Selector("toggleSignup:"))
        signupView.addGestureRecognizer(singupTap)
        
        let mixTap = UITapGestureRecognizer(target: self, action: Selector("toggleMix:"))
        mixView.addGestureRecognizer(mixTap)
        
        let listenTap = UITapGestureRecognizer(target: self, action: Selector("toggleListen:"))
        listenView.addGestureRecognizer(listenTap)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        markAsSeen(self, seen: true)
    }
    
    @IBAction func actionLogout(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
        markAsSeen(navigationController!.viewControllers.last!, seen: false)
    }
}
