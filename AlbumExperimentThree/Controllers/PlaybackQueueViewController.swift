//
//  PlaybackQueueViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 12/11/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaybackQueueViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableFooterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(0 ,0, determineFooterPaddingHeight(), 0)
        
        let ip = NSIndexPath(forRow: 0, inSection: 1)
        tableView.scrollToRowAtIndexPath(ip, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        
        registerMediaPlayerNotifications()
    }
 
    //Doesnt work. No idea why
    private func determineFooterPaddingHeight() -> CGFloat {
        let tableHeight = tableView.frame.height
        
        //Calculate the height of the sections that you want to be fully visable
        let rectSect2 = tableView.rectForSection(2)

        let needed = tableHeight - rectSect2.height
        
        if needed > 0 {
            return needed
        } else {
            return 0
        }
//        return 401
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePlaybackQueue(sender: UIButton) {
      //  performSegueWithIdentifier("presentNowPlayingQueue", sender: self)
//        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func registerMediaPlayerNotifications() {
        let nc = NSNotificationCenter.defaultCenter()
        
//        //Last param is optional
//        nc.addObserver(self, selector: "onTimeElapsed:", name: MusicPlayer.MusicPlayerTimeUpdate, object: MusicPlayer.instance)
        
        nc.addObserver(self, selector: "onMusicPlayerNowPlayingDidChange:", name: MusicPlayer.MusicPlayerNowPlayingItemDidChange, object: MusicPlayer.instance)
        
    }
    
    
//    func onTimeElapsed(notification: NSNotification) {
//        let dict = notification.userInfo!
//        let currentPlaybackTime = dict[MusicPlayer.TIME_ELAPSED_KEY] as! Double
//        
//        if currentPlaybackTime > playbackThresholdForHistoryInSeconds && historyCandidateItem != nil{
//            AppDelegate.getSavedData().playbackHistory.append(NSNumber(unsignedLongLong: historyCandidateItem!.persistentID))
//        }
//    }
    
//    let playbackThresholdForHistoryInSeconds : Double = 5
//    var historyCandidateItem : MPMediaItem? = nil
    func onMusicPlayerNowPlayingDidChange(notification: NSNotification){
//        historyCandidateItem = MusicPlayer.instance.nowPlayingMediaItem()
        tableView.reloadData()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}

extension PlaybackQueueViewController : UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return AppDelegate.getSavedData().playbackHistory.count
        case 1:
            let item = MusicPlayer.instance.nowPlayingMediaItem()
            return item == nil ? 0 : 1
        case 2:
            return MusicPlayer.instance.remainingMediaItemsInQueue().count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "History"
        case 1:
            return "Now Playing"
        case 2:
            return "Next Up"
        default:
            return "Error"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SongHistoryTableViewCell", forIndexPath: indexPath) as! SongHistoryTableViewCell
        
//        var item : MPMediaItem!
        switch indexPath.section {
            case 0:
                let historyItems = MusicLibrary.instance.queryMediaItemsByPersistenceIDs(AppDelegate.getSavedData().playbackHistory)
                cell.mediaItem = historyItems[indexPath.row]
            case 1:
                cell.mediaItem = MusicPlayer.instance.nowPlayingMediaItem()
            case 2:
                cell.mediaItem = MusicPlayer.instance.remainingMediaItemsInQueue()[indexPath.row]
            default: return cell; //Should never happen
        }
        
//        cell.mediaItem = item
        
        return cell
    }
    
    
}



extension PlaybackQueueViewController : UITableViewDelegate {
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        <#code#>
//    }
}
