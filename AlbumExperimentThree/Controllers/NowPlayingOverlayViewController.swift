//
//  NowPlayingOverlayViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 12/11/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit
import MediaPlayer

class NowPlayingOverlayViewController: UIViewController {

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
    
    @IBOutlet weak var nowPlayingAlbumCoverImageView: UIImageView!
    @IBOutlet weak var nowPlayingSongTitleLabel: UILabel!
    @IBOutlet weak var nowPlayingArtistLabel: UILabel!
    @IBOutlet weak var nowPlayingPlayPauseProgressButton: PlayPauseProgressButton!
    
    
    private let dragTranslationThreshold : CGFloat = 100.0
//    private var currentTimer : NSTimer!
    
    //    var audioPlayer : AVAudioPlayer
    
    //    let mediaPlayerController : MPMusicPlayerController = MusicLibrary.instance.musicPlayer
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
//        performRemainingInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // this implementation is called because i am creating this view from the storyboard
//        fatalError("init(coder:) has not been implemented")
//        performRemainingInit()
        

    }
    
    func performRemainingInit(){
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
        self.view.gestureRecognizers = [panRecognizer]
        
        let miniViewTapRecognizer = UITapGestureRecognizer(target: self, action: "miniViewTapped:")
        miniView.gestureRecognizers = [miniViewTapRecognizer]
        
        self.view.backgroundColor = UIColor.clearColor()

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performRemainingInit()
        
        registerMediaPlayerNotifications()
        
        dragFromY = self.view.frame.origin.y// This saves me from a weird nil error.
        
        //        let nowPlayingItem = mediaPlayerController.nowPlayingItem
        
        let nowPlayingItem = MusicPlayer.instance.nowPlayingMediaItem()
        loadMediaItemData(nowPlayingItem)
        
        miniPlayPauseButton.isPlaying = MusicPlayer.instance.isPlaying()
        
        nowPlayingPlayPauseProgressButton.isPlaying = MusicPlayer.instance.isPlaying()
        
        //Oh and dont forget.  Putting your finger on a button and dragging reaps havok!
    }
    
    
    //    override func viewDidUnload() {
    //        unregisterMediaPlayerNotifications()
    //    }
    
    func loadMediaItemData(nowPlayingItem : MPMediaItem?){
        if nowPlayingItem == nil{
            miniViewTitleLabel.text = ""
            miniViewDetailLabel.text = ""
            nowPlayingAlbumCoverImageView.image = nil
            nowPlayingSongTitleLabel.text = ""
            nowPlayingArtistLabel.text = ""
        } else {
            miniViewTitleLabel.text = nowPlayingItem?.title
            miniViewDetailLabel.text = nowPlayingItem?.artist
            
            nowPlayingAlbumCoverImageView?.image = nowPlayingItem?.artwork?.imageWithSize(nowPlayingAlbumCoverImageView.bounds.size)
            nowPlayingSongTitleLabel.text = nowPlayingItem?.title
            nowPlayingArtistLabel.text = nowPlayingItem?.artist
            
            nowPlayingPlayPauseProgressButton.duration = nowPlayingItem?.valueForProperty(MPMediaItemPropertyPlaybackDuration)?.doubleValue
        }
        
    }
    
    func adjustToFrame(parentFrame: CGRect){
        let miniViewHeight = miniViewHeightConstraint.constant
        
        self.originFull = -miniViewHeight //Negative height of mini
        self.originMini = parentFrame.height - miniViewHeight //Height of the mini player
        
        print(parentFrame)
        
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
        let nc = NSNotificationCenter.defaultCenter()
        
        //Last param is optional
        nc.addObserver(self, selector: "onMusicPlayerNowPlayingDidChange:", name: MusicPlayer.MusicPlayerNowPlayingItemDidChange, object: MusicPlayer.instance)
        nc.addObserver(self, selector: "onMusicPlayerStateChange:", name: MusicPlayer.MusicPlayerStateDidChange, object: MusicPlayer.instance)
        nc.addObserver(self, selector: "onTimeElapsed:", name: MusicPlayer.MusicPlayerTimeUpdate, object: MusicPlayer.instance)
        
        //        let notificationCenter = NSNotificationCenter.defaultCenter()
        //        notificationCenter.addObserver(self, selector: "handleNowPlaingItemChanged:", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: mediaPlayerController)
        //
        //        notificationCenter.addObserver(self, selector: "handlePlaybackStateChanged:", name: MPMusicPlayerControllerPlaybackStateDidChangeNotification, object: mediaPlayerController)
        //
        //        notificationCenter.addObserver(self, selector: "handleVolumeChanged:", name: MPMusicPlayerControllerVolumeDidChangeNotification, object: mediaPlayerController)
        //
        //        //Trevis, you may want to unregister at some point?
        //        mediaPlayerController.beginGeneratingPlaybackNotifications()
        //
        //        currentTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "onTimer:", userInfo: nil, repeats: true)
        
        
        
    }
    
    //
    //    //Trevis, when to call this?
    //    func unregisterMediaPlayerNotifications(){
    //        let notificationCenter = NSNotificationCenter.defaultCenter()
    //
    //        mediaPlayerController.endGeneratingPlaybackNotifications()
    //        notificationCenter.removeObserver(self)
    //    }
    //
    
    
    @IBAction func nextButtonAction(sender: UIButton) {
        MusicPlayer.instance.skipToNextItem()
    }
    
    @IBAction func playPauseButtonAction(sender: UIButton) {
        if MusicPlayer.instance.isPlaying() {
            MusicPlayer.instance.pause()
        } else {
            MusicPlayer.instance.play()
        }
    }
    
    @IBAction func previousButtonAction(sender: UIButton) {
        MusicPlayer.instance.skipToPreviousItem()
    }

    @IBAction func showNowPlayingQueue(sender: UIButton) {
        performSegueWithIdentifier("presentNowPlayingQueue", sender: self)
    }
}

extension NowPlayingOverlayViewController {
    func onMusicPlayerNowPlayingDidChange(notification: NSNotification){
        let nowPlayingItem = MusicPlayer.instance.nowPlayingMediaItem()
        loadMediaItemData(nowPlayingItem)
        
        let duration = nowPlayingItem?.valueForProperty(MPMediaItemPropertyPlaybackDuration)?.doubleValue
        progresBarView.duration = duration
        nowPlayingPlayPauseProgressButton.duration = duration
    }
    
    func onTimeElapsed(notification: NSNotification) {
        let dict = notification.userInfo!
        let currentPlaybackTime = dict[MusicPlayer.TIME_ELAPSED_KEY] as! Double
        
        progresBarView.progress = currentPlaybackTime //MiniPlayer progress
        nowPlayingPlayPauseProgressButton.currentPlaybackTime = currentPlaybackTime
    }

    
    func onMusicPlayerStateChange(notification: NSNotification){
        miniPlayPauseButton.isPlaying = MusicPlayer.instance.isPlaying()
        nowPlayingPlayPauseProgressButton.isPlaying = MusicPlayer.instance.isPlaying()
    }
    //    func handleVolumeChanged(notification: NSNotification){
    //        print("handleVolumeChanged")
    //    }
}

extension NowPlayingOverlayViewController {
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent?) { // *
        let rc = event!.subtype
        let p = MusicPlayer.instance
        print("received remote control \(rc.rawValue)") // 101 = pause, 100 = play
        switch rc {
        case .RemoteControlTogglePlayPause:
            if p.isPlaying() {
                p.pause()
            } else {
                p.play()
            }
        case .RemoteControlPlay:
            p.play()
        case .RemoteControlPause:
            p.pause()
        case .RemoteControlNextTrack:
            p.skipToNextItem()
        case .RemoteControlPreviousTrack:
            p.skipToPreviousItem()
        default:break
        }
        
    }
}
