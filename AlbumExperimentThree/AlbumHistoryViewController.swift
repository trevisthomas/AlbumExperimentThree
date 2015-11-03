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
  
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albums = MusicLibrary.instance.mostRecientlyAddedAlbums()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
