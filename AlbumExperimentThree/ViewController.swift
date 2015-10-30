//
//  ViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/23/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nowPlaying = NowPlayingViewController()
        nowPlaying.originFull = -50 //Negative height of mini
        nowPlaying.originMini = self.view.frame.height - 50 //Height of the mini player
        
        nowPlaying.view.frame = CGRect(x: 0, y: nowPlaying.originMini, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(nowPlaying.view)
        addChildViewController(nowPlaying)
        
        print("Width \(view.frame.width)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

