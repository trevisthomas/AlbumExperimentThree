//
//  NowPlayingViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/23/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit
import MediaPlayer

class NowPlayingViewController: UIViewController {
    var originMini : CGFloat!
    var originFull : CGFloat!
    var dragFromY : CGFloat!
    var draggingFromMini = true
    
    @IBOutlet weak var progresBarView: MiniProgressBarView!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var miniView: UIView!
    @IBOutlet weak var miniViewTitleLabel: UILabel!
    @IBOutlet weak var miniViewDetailLabel: UILabel!
    @IBOutlet weak var miniPlayPauseButton: PlayPauseButton!
    @IBOutlet weak var miniNextButton: NextPreviousButton!
    @IBOutlet weak var miniPreviousButton: NextPreviousButton!
    
    @IBOutlet weak var miniViewHeightConstraint: NSLayoutConstraint!
    
    private let dragTranslationThreshold : CGFloat = 100.0
    private var currentTimer : NSTimer!
    
//    var audioPlayer : AVAudioPlayer
    
    var mediaPlayerController : MPMusicPlayerController!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
        self.view.gestureRecognizers = [panRecognizer]
        
        let miniViewTapRecognizer = UITapGestureRecognizer(target: self, action: "miniViewTapped:")
        miniView.gestureRecognizers = [miniViewTapRecognizer]
        
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaPlayerController = MPMusicPlayerController.systemMusicPlayer()
        
        registerMediaPlayerNotifications()
        
        dragFromY = self.view.frame.origin.y// This saves me from a weird nil error.  
        
        let nowPlayingItem = mediaPlayerController.nowPlayingItem
        loadMediaItemData(nowPlayingItem)
        
        //Oh and dont forget.  Putting your finger on a button and dragging reaps havok!
        
     
        
     
        
    }
    
//    override func viewDidUnload() {
//        unregisterMediaPlayerNotifications()
//    }
    
    func loadMediaItemData(nowPlayingItem : MPMediaItem?){
        if nowPlayingItem == nil{
            miniViewTitleLabel.text = ""
            miniViewDetailLabel.text = ""
        } else {
            miniViewTitleLabel.text = nowPlayingItem?.title
            miniViewDetailLabel.text = nowPlayingItem?.artist
        }
        
    }
    
    func adjustToFrame(parentFrame: CGRect){
        let miniViewHeight = miniViewHeightConstraint.constant
        
        self.originFull = -miniViewHeight //Negative height of mini
        self.originMini = parentFrame.height - miniViewHeight //Height of the mini player
        
        self.view.frame = CGRect(x: 0, y: self.originMini, width: parentFrame.width, height: parentFrame.height + miniViewHeight)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func detectPan(recognizer : UIPanGestureRecognizer){
        let translation = recognizer.translationInView(self.view.superview)
        
//        print(translation.y)
        
        if recognizer.state == UIGestureRecognizerState.Began {
//            print("Begin: \(self.view.frame.origin.y)")
            draggingFromMini = originMini == self.view.frame.origin.y
//            print("Dragging from mini \(draggingFromMini)")
        }
        
        if recognizer.state == UIGestureRecognizerState.Ended {
            //if(translation.y > 0){
            if(draggingFromMini){
                //Now playing is opened and the user is pulling it down
                if(abs(translation.y) < dragTranslationThreshold){
                    animateToPosition(originMini)
                } else{
                    animateToPosition(originFull)
                }
            } else {
                //Now playing is mini and the user is pulling it up
                if(translation.y > dragTranslationThreshold){
                    animateToPosition(originMini)
                } else {
                    animateToPosition(originFull)
                }
                
            }
        } else {
            
            if(draggingFromMini && translation.y > 0.0){
                return //Rejected.  Dont let them drag the mini even lower!
            } else if (!draggingFromMini && translation.y < 0.0){
                return //Rejected.  Dont let them drag the full player higher!
            } else {
                //Good to go
                //Trevis! this is where that crash was coming from.   Found on 11/4.  dragFromY was nil.  I was setting it in touches began which appearently hadn't been called yet.  Going to try to set it somewhere else.
                self.view.frame.origin.y = dragFromY + translation.y
            }
        }
    }
    
    
    func miniViewTapped(recognizer : UITapGestureRecognizer){
        animateToPosition(originFull)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dragFromY = self.view.frame.origin.y
    }
    
    private func animateToPosition(newPosition : CGFloat){
        print("Animating to \(newPosition)")
        UIView.animateWithDuration(0.25, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseInOut], animations: {
            self.view.frame.origin.y = newPosition
            self.view.layoutIfNeeded()
            }, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func registerMediaPlayerNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleNowPlaingItemChanged:", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: mediaPlayerController)
        
        notificationCenter.addObserver(self, selector: "handlePlaybackStateChanged:", name: MPMusicPlayerControllerPlaybackStateDidChangeNotification, object: mediaPlayerController)
        
        notificationCenter.addObserver(self, selector: "handleVolumeChanged:", name: MPMusicPlayerControllerVolumeDidChangeNotification, object: mediaPlayerController)
        
        //Trevis, you may want to unregister at some point?
        mediaPlayerController.beginGeneratingPlaybackNotifications()
        
        currentTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "onTimer:", userInfo: nil, repeats: true)
        

        
    }

    
    //Trevis, when to call this?
    func unregisterMediaPlayerNotifications(){
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        mediaPlayerController.endGeneratingPlaybackNotifications()
        notificationCenter.removeObserver(self)
    }
    
    func onTimer( timer : NSTimer) {
        let currentPlaybackTime = mediaPlayerController.currentPlaybackTime
        
//        print(String.convertSecondsToHHMMSS(currentPlaybackTime))
        
        progresBarView.progress = currentPlaybackTime
    }
    
    
    @IBAction func nextButtonAction(sender: UIButton) {
        mediaPlayerController.skipToNextItem()
    }
    
    @IBAction func playPauseButtonAction(sender: UIButton) {
        if mediaPlayerController.playbackState == .Playing {
            mediaPlayerController.pause()
        } else {
            mediaPlayerController.play()
        }
    }
    
    @IBAction func previousButtonAction(sender: UIButton) {
        mediaPlayerController.skipToPreviousItem()
    }
}

extension NowPlayingViewController {
    func handleNowPlaingItemChanged(notification: NSNotification){
        let nowPlayingItem = mediaPlayerController.nowPlayingItem
        loadMediaItemData(nowPlayingItem)
        
        progresBarView.duration = nowPlayingItem?.valueForProperty(MPMediaItemPropertyPlaybackDuration)?.doubleValue
        
        
    }
    func handlePlaybackStateChanged(notification: NSNotification){
        print("handlePlaybackStateChanged")
        
        let state = mediaPlayerController.playbackState
        
        switch state {
            case .Playing:
                miniPlayPauseButton.isPlaying = true
                
            case .Paused:
                miniPlayPauseButton.isPlaying = false
            
            case .Stopped:
                miniPlayPauseButton.isPlaying = false
                mediaPlayerController.stop() //Saw this in an example.  Not sure why this would be needed though.
            
            default: break
            
        }
    }
    func handleVolumeChanged(notification: NSNotification){
        print("handleVolumeChanged")
    }
}