//
//  PlaylistsViewController.swift
//  Streamify
//
//  Created by Marin Todorov on 8/13/15.
//  Copyright (c) 2015 Underplot ltd. All rights reserved.
//

import UIKit

class PlaylistsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var playlists: [PlaylistModel] = []
    var lastSelectedIndexPath: NSIndexPath?
        
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? SongsViewController {
            destination.playlist = playlists[lastSelectedIndexPath!.row]
        }
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        lastSelectedIndexPath = indexPath
        return indexPath
    }
    
    @IBAction func actionUpgrade(sender: AnyObject) {
        
    }
}

// MARK: navigation controller - custom transition methods

// MARK: - Starter project code
extension PlaylistsViewController: StarterProjectCode {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlists = PlaylistModel.allPlaylists()
    }
    
    @IBAction func actionLogout(sender: AnyObject) {
        navigationController!.delegate = nil
        
        markAsSeen(navigationController!.viewControllers[navigationController!.viewControllers.count-2] as! UIViewController, false)
        markAsSeen(navigationController!.viewControllers.last as! UIViewController, false)
        navigationController?.popToRootViewControllerAnimated(true)
    }
}

extension PlaylistsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistCell") as! PlaylistCell
        
        let item = playlists[indexPath.row]
        cell.name.text = item.name
        cell.style.text = item.style
        cell.songs.text = "\(item.songs.count) songs"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
