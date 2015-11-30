//
//  AlbumHistoryViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/29/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit
import MediaPlayer

class AlbumHistoryViewController: UIViewController {
    var albums : [AlbumData]!
  
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var overlayTint: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    let mediaPlayerController : MPMusicPlayerController = MusicLibrary.instance.musicPlayer
    
    var snapshot : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albums = MusicLibrary.instance.mostRecientlyAddedAlbums()
        
        registerMediaPlayerNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func willBlur(){
        overlayImageView.hidden = true //Just make sure that it's hidden first.  This seemed to make things better.  
        overlayTint.hidden = true //Just like the above
        snapshot = view.getSnapshot()
        overlayImageView.hidden = false
        overlayTint.hidden = false
        overlayTint.alpha = 0
    }
    
    func applyBlur(radius : CGFloat, alpha :CGFloat){
        if snapshot == nil {
//            return // Cant do it
            willBlur()
        }
        overlayTint.hidden = false
        overlayTint.alpha = alpha
        overlayImageView.hidden = false
        overlayImageView.image = snapshot!.pr_boxBlurredImageWithRadius(radius)
    }

    func endBlur(endBlurWithOverlayVisible : Bool){
        overlayImageView.hidden = endBlurWithOverlayVisible
        overlayTint.hidden = endBlurWithOverlayVisible
        overlayTint.alpha = 1
        snapshot = nil
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if sender is AlbumHistoryViewCell {
            let cell = sender as! AlbumHistoryViewCell
            
            let indexPath = collectionView!.indexPathForCell(sender as! AlbumHistoryViewCell)!
            let albumData = albums[indexPath.row] //(indexedArtistData[sections[indexPath.section]])![indexPath.row]
            
            let songViewController = segue.destinationViewController as! SongViewController
            songViewController.albumData = albumData
            
            
            songViewController.sourceAlbumBoxRect = cell.outerBoxView.boundsOnScreen()
            songViewController.sourceAlbumCoverRect = cell.artworkImageView.boundsOnScreen()
            
        } else {
            print(sender)
            //Something else.  I noticed that this method gets called when this view controller is loaded too.
        }
    }
    
    func registerMediaPlayerNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleNowPlaingItemChanged:", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: mediaPlayerController)
        
        notificationCenter.addObserver(self, selector: "handlePlaybackStateChanged:", name: MPMusicPlayerControllerPlaybackStateDidChangeNotification, object: mediaPlayerController)
        
        
        //Trevis, you may want to unregister at some point?
        mediaPlayerController.beginGeneratingPlaybackNotifications()
        
    }

    
}

extension AlbumHistoryViewController : UICollectionViewDataSource {
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumHistoryViewCell
        
        cell.albumData = albums[indexPath.row]
        return cell
    }
    
}

extension AlbumHistoryViewController : UICollectionViewDelegate{
    
}

extension AlbumHistoryViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 125, height: 150)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return UIEdgeInsetsZero
        return UIEdgeInsetsMake (-44, 0, 0, 0) //This -44 is wiggity wack.  I have no idea why it's like this.
    }
}

extension AlbumHistoryViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
       // print("Offset \(scrollView.contentOffset.y)")
    }
}

extension AlbumHistoryViewController {
    func handleNowPlaingItemChanged(notification: NSNotification){
//        print("handleNowPlaingItemChanged")
        let mediaItem =  mediaPlayerController.nowPlayingItem
        
        if mediaItem == nil {
            return //Nothing is playing
        }
        
        let albumId = mediaItem?.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as! NSNumber
        
        let album = MusicLibrary.instance.queryAlbumByPersistenceID(albumId)
        
        removeAlbumIfExists(album)
        
        if albums.first?.albumId != album.albumId {
            //The first album needs to be changed.
            albums.insert(album, atIndex: 0)
            collectionView.reloadData()
        }
        
        print("\(album)")
    }
    
    func removeAlbumIfExists(albumToRemove : AlbumData){
        let ndx = albums.find {
            $0.albumId == albumToRemove.albumId
        }
        
        if ndx != nil && ndx > 0{
            albums.removeAtIndex(ndx!)
        }
    }
    
    func handlePlaybackStateChanged(notification: NSNotification){
        print("handlePlaybackStateChanged")
    }
    
}
