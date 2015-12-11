//
//  ViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/23/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var blurMask : UIView!
    var blurredBgImage : UIView!
    
    var nowPlaying : NowPlayingOverlayViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let nowPlaying = NowPlayingViewController()
//        let nowPlaying = NowPlayingOverlayViewController()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        nowPlaying = storyboard.instantiateViewControllerWithIdentifier("nowPlayingOverlayViewController") as! NowPlayingOverlayViewController
        
//        
//        nowPlaying.originFull = -50 //Negative height of mini
//        nowPlaying.originMini = self.view.frame.height - 50 //Height of the mini player
//        
//        nowPlaying.view.frame = CGRect(x: 0, y: nowPlaying.originMini, width: self.view.frame.width, height: self.view.frame.height + 50)
        self.view.addSubview(nowPlaying.view)
        addChildViewController(nowPlaying)
        
        
//        nowPlaying.adjustToFrame(self.view.frame)
        
//        print("Width \(view.frame.width)")
        
        
//I was playing with that blur tutorial but you cant put a scrollview over a collection view and expect to interact with it.
//        self.view.addSubview(createScrollView())
//        
//        blurredBgImage.backgroundColor = UIColor.blueColor() //TODO, make this a blurred image!
//        blurMask = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height-50, width: self.view.frame.size.width, height: 50))
//        blurMask.backgroundColor = UIColor.whiteColor()
//        blurredBgImage.layer.mask = blurMask.layer;
    }
    
    override func viewDidLayoutSubviews() {
        nowPlaying.adjustToFrame(self.view.frame)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createScrollView () -> UIView {
        let containerView = UIView(frame: self.view.frame)
        
        blurredBgImage = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 568))
        //TODO make this a UIImageView
        containerView.addSubview(blurredBgImage)
        
        let scrollView = UIScrollView(frame: self.view.frame)
        containerView.addSubview(scrollView)
        scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height * 2 - 110)
        scrollView.pagingEnabled = true
        scrollView.delegate = self;
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        let slideContentView = UIView(frame: CGRect(x: 0, y: 518, width: self.view.frame.size.width, height: 508))
        slideContentView.backgroundColor = UIColor.clearColor()
        scrollView.addSubview(slideContentView)
        
        
        return containerView
    }
    
}



extension ViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        blurMask.frame = CGRectMake(blurMask.frame.origin.x,
            self.view.frame.size.height - 50 - scrollView.contentOffset.y,
            blurMask.frame.size.width,
            blurMask.frame.size.height + scrollView.contentOffset.y)

    }
}
