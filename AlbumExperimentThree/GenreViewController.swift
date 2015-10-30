//
//  GenreViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/28/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class GenreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var historyContainerView: UIView!
    @IBOutlet weak var historyHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    private var genreData : [GenreData]!
    private var originalY : CGFloat!
    private var originalHeight : CGFloat!
    
    private var containerOriginalY : CGFloat!
    private var containerOriginalHeight : CGFloat!
    
    private let navBarHeight : CGFloat = 44.0
//    private let heightOfHistoryView : CGFloat
    
//    let computers = [
//                ["Name" : "MacBook Air", "Color" : UIColor.blueColor()],
//                ["Name" : "MacBook Pro", "Color" : UIColor.purpleColor()],
//                ["Name" : "iMac", "Color" : UIColor.yellowColor()],
//                ["Name" : "Mac Mini", "Color" : UIColor.redColor()],
//                ["Name" : "Mac Pro", "Color" : UIColor.greenColor()],
//                ["Name" : "MacBook Air", "Color" : UIColor.blueColor()],
//                ["Name" : "MacBook Pro", "Color" : UIColor.purpleColor()],
//                ["Name" : "iMac", "Color" : UIColor.yellowColor()],
//                ["Name" : "Mac Mini", "Color" : UIColor.redColor()],
//                ["Name" : "Mac Pro", "Color" : UIColor.greenColor()],
//                ["Name" : "MacBook Air", "Color" : UIColor.blueColor()],
//                ["Name" : "MacBook Pro", "Color" : UIColor.purpleColor()],
//                ["Name" : "iMac", "Color" : UIColor.yellowColor()],
//                ["Name" : "Mac Mini", "Color" : UIColor.redColor()],
//                ["Name" : "Mac Pro", "Color" : UIColor.greenColor()]        
//            ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genreData = MusicLibrary.instance.getGenreBundle()
        originalY = collectionView.frame.origin.y //Stashing the original y position of the table frame
        
        containerOriginalY = historyContainerView.frame.origin.y
       
        
//        let debug = MusicLibrary.instance.mostRecientlyAddedAlbums()
        
//        StretchingFocusLayoutConstants.Cell.featuredHeight = collectionView.frame.width
    }
    
    override func viewDidLayoutSubviews() {
        //If i did this in viewDidLoad the size wasnt correct yet!
        originalHeight = collectionView.bounds.height
        containerOriginalHeight = historyContainerView.bounds.height
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

extension GenreViewController{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreData.count
//        return computers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GenreCell", forIndexPath: indexPath) as! GenreCollectionViewCell
        
//        cell.backgroundColor = computers[indexPath.row]["Color"] as? UIColor
        
        
        cell.data = genreData[indexPath.row]
        return cell
    }
    
//    col
}

extension GenreViewController {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        adjustHistoryViewBecauseScrollChanged()
    }
    
    func adjustHistoryViewBecauseScrollChanged(){
        //I think that the nav bar is 44px
        //TODO: Figure out how to get the height param out of heightConstraintForHistoryView.
        
        let yOffset = collectionView.contentOffset.y
        if(yOffset < 0){
            collectionView.frame.origin.y = originalY //144 //144 is the starting point
            collectionView.frame.size = CGSize(width: collectionView.frame.width, height: originalHeight)
            historyContainerView.frame.origin.y = containerOriginalY
//            historyContainerView.frame.origin.y = originalY - originalHeight
        } else if yOffset < historyHeightConstraint.constant  {
            collectionView.frame.origin.y = originalY - collectionView.contentOffset.y
            historyContainerView.frame.origin.y = containerOriginalY - collectionView.contentOffset.y
            let newHeight = originalHeight + collectionView.contentOffset.y
            //            print(newHeight)
            collectionView.frame.size = CGSize(width: collectionView.frame.width, height: newHeight)
        } else {
            collectionView.frame.origin.y = navBarHeight
            let newHeight = originalHeight + historyHeightConstraint.constant
            collectionView.frame.size = CGSize(width: collectionView.frame.width, height: newHeight)
            historyContainerView.frame.origin.y = -containerOriginalHeight
        }
        //        print(collectionView.frame)
    }
}

