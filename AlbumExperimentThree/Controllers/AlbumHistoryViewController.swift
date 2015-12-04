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
    var albums : [AlbumData] = []
  
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var overlayTint: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var snapshot : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        albums = []
        
        for albumId in AppDelegate.getSavedData().lastPlayedAlbums {
            albums.append(MusicLibrary.instance.queryAlbumByPersistenceID(albumId))
        }
        //albums = MusicLibrary.instance.mostRecientlyAddedAlbums()
        
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
        let nc = NSNotificationCenter.defaultCenter()
        
        //Last param is optional
        nc.addObserver(self, selector: "onMusicPlayerNowPlayingDidChange:", name: MusicPlayer.MusicPlayerNowPlayingItemDidChange, object: MusicPlayer.instance)
//        nc.addObserver(self, selector: "onMusicPlayerStateChange:", name: MusicPlayer.MusicPlayerStateDidChange, object: MusicPlayer.instance)
//        nc.addObserver(self, selector: "onTimeElapsed:", name: MusicPlayer.MusicPlayerTimeUpdate, object: MusicPlayer.instance)
        
//        let notificationCenter = NSNotificationCenter.defaultCenter()
        
//        let notificationCenter = NSNotificationCenter.defaultCenter()
//        notificationCenter.addObserver(self, selector: "handleNowPlaingItemChanged:", name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification, object: mediaPlayerController)
//        
//        notificationCenter.addObserver(self, selector: "handlePlaybackStateChanged:", name: MPMusicPlayerControllerPlaybackStateDidChangeNotification, object: mediaPlayerController)
//        
//        
//        //Trevis, you may want to unregister at some point?
//        mediaPlayerController.beginGeneratingPlaybackNotifications()
        
    }

    
}

extension AlbumHistoryViewController : UICollectionViewDataSource {
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("albums: \(albums.count)")
        return albums.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        print(indexPath.row)
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
    func onMusicPlayerNowPlayingDidChange(notification: NSNotification){
//        print("handleNowPlaingItemChanged")
//        let mediaItem =  mediaPlayerController.nowPlayingItem
//        
//        if mediaItem == nil {
//            return //Nothing is playing
//        }
//        
//        let albumId = mediaItem?.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as! NSNumber
        
        let dict = notification.userInfo!
        let nowPlayingItem = dict[MusicPlayer.MEDIA_ITEM_KEY] as! MPMediaItem
        
        let albumId = nowPlayingItem.getAlbumId()
        
//        let albumId = nowPlayingItem.valueForProperty(MPMediaItemPropertyAlbumPersistentID) as! NSNumber
        
        let album = MusicLibrary.instance.queryAlbumByPersistenceID(albumId)
        
//        removeAlbumIfExists(album)
        
        let indexPathZero = NSIndexPath(forItem: 0, inSection: 0)
        
        if albums.isEmpty || !doesAlbumExist(album){
            //Empty, or not in the list?  just add it
            albums.insert(album, atIndex: 0)
            collectionView.insertItemsAtIndexPaths([indexPathZero])
        } else { // List is not empty and the album exists already.  Move it
            let ndx = removeAlbumIfExists(album)!
            albums.insert(album, atIndex: 0)
            collectionView.moveItemAtIndexPath(NSIndexPath(forItem: ndx, inSection: 0), toIndexPath: indexPathZero)
        }
        
        saveAlbumHistory()
        
//        if(doesAlbumExist(album)){
//            print ("albumExists")
//        }
//        
//        if albums.isEmpty || albums.first?.albumId != album.albumId {
//            //The first album needs to be changed.
//            albums.insert(album, atIndex: 0)
//            
//            
//            //collectionView.reloadData()
//            
//            //This forcable thread jump was because it wasnt realoading for some reason. Stackoverflow suggestion
////            dispatch_async(dispatch_get_main_queue()){
////                self.collectionView.reloadData()
////            }
//            
////            collectionView.reloadData()
////            collectionView.reloadItemsAtIndexPaths(collectionView.indexPathsForVisibleItems())
////            collectionView.reloadData()
////            collectionView.invalidateIntrinsicContentSize()
//            
//            let ip0 = NSIndexPath(forItem: 0, inSection: 0)
//            collectionView.insertItemsAtIndexPaths([ip0])
//
////            collectionView.setNeedsLayout()
////            collectionView.reloadData()
//            
//        
//            
//            
//            
//            saveAlbumHistory()
//        }
        
        
        
        print("\(album)")
    }
    
    func saveAlbumHistory(){
        
        AppDelegate.getSavedData().lastPlayedAlbums.removeAll()
        for album in albums {
            AppDelegate.getSavedData().lastPlayedAlbums.append(album.albumId)
        }
        
//        if(AppDelegate.getSavedData().lastPlayedAlbums.isEmpty || AppDelegate.getSavedData().lastPlayedAlbums[0] != albumId){
//            AppDelegate.getSavedData().lastPlayedAlbums.insert(albumId, atIndex: 0)
//        }
    }
    
    func removeAlbumIfExists(albumToRemove : AlbumData) -> Int?{
        let ndx = indexOfAlbum(albumToRemove)
        if ndx != nil {
            albums.removeAtIndex(ndx!)
        }
        
        return ndx
    }
    
    func doesAlbumExist(albumToFind : AlbumData) -> Bool{
        return indexOfAlbum(albumToFind) != nil
    }
    
    func indexOfAlbum(albumToFind : AlbumData) -> Int?{
        //returns nil if it's not here
        let ndx = albums.find {
            $0.albumId == albumToFind.albumId
        }
        return ndx
    }
    
//    func handlePlaybackStateChanged(notification: NSNotification){
//        print("handlePlaybackStateChanged")
//    }
    
}
