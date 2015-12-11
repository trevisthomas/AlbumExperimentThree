//
//  PlaybackQueueViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 12/11/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class PlaybackQueueViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePlaybackQueue(sender: UIButton) {
        performSegueWithIdentifier("presentNowPlayingQueue", sender: self)
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
