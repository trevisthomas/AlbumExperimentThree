//
//  AlbumHistoryViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/29/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class AlbumHistoryViewController: UIViewController {
    var albums : [AlbumData]!
  
    @IBOutlet weak var overlayImageView: UIImageView!
    @IBOutlet weak var overlayTint: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var snapshot : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albums = MusicLibrary.instance.mostRecientlyAddedAlbums()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func willBlur(){
        overlayImageView.hidden = true //Just make sure that it's hidden first.  This seemed to make things better.  
        snapshot = view.getSnapshot()
        overlayImageView.hidden = false
        overlayTint.hidden = false
        overlayTint.alpha = 0
    }
    
    func applyBlur(radius : CGFloat, alpha :CGFloat){
        if snapshot == nil {
            return // Cant do it
        }
        overlayTint.hidden = false
        overlayTint.alpha = alpha
        overlayImageView.hidden = false
        overlayImageView.image = snapshot!.pr_boxBlurredImageWithRadius(radius)
    }

    func endBlur(){
        overlayImageView.hidden = true
        overlayTint.hidden = true
        overlayTint.alpha = 1
//        snapshot = nil
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

extension AlbumHistoryViewController : UICollectionViewDataSource {
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumHistoryCell", forIndexPath: indexPath) as! AlbumHistoryViewCell
        
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
