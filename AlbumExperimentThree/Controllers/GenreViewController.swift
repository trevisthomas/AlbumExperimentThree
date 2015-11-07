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
    
    private let statusBarHeight : CGFloat = 20
    private let navBarHeight : CGFloat = 44.0

    override func viewDidLoad() {
        super.viewDidLoad()
        genreData = MusicLibrary.instance.getGenreBundle()
        
       title = "Album Experiment"
        
//        let debug = MusicLibrary.instance.mostRecientlyAddedAlbums()
        
//        StretchingFocusLayoutConstants.Cell.featuredHeight = collectionView.frame.width
        
//        navigationController?.navigationBar.alpha = 0.5
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        
        
//        collectionView.frame.insetInPlace(dx: 0, dy: 100)
//        collectionView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        
        
//        UIApplication.sharedApplication().statusBarStyle = .LightContent
//        navigationController?.navigationBar.barStyle = .BlackTranslucent
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
//        navigationController?.navigationBar.barStyle = .BlackTranslucent
        
        originalHeight = collectionView.bounds.height
        containerOriginalHeight = historyContainerView.bounds.height
        
        //After a lot of fussing.  I ended up setting the height of the collection view to be taller than the screen in interface builder (i bound the bottom to -204 so that i dont have to change the height of that view as the History hides
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    
    override func viewDidLayoutSubviews() {
        //If i did this in viewDidLoad the size wasnt correct yet!
       // var test =  view.frame.height
       // print (test)
//        originalHeight = collectionView.bounds.height
        //originalHeight = view.frame.height
//        containerOriginalHeight = historyContainerView.bounds.height
        
        originalY = 224
        containerOriginalY = 0
        
//        originalY = collectionView.frame.origin.y //Stashing the original y position of the table frame
//        
//        containerOriginalY = historyContainerView.frame.origin.y
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
        adjustHistoryViewBecauseScrollChangedAllTheWay()
    }
    
//    func adjustHistoryViewBecauseScrollChanged(){
//        //I think that the nav bar is 44px
//        //TODO: Figure out how to get the height param out of heightConstraintForHistoryView.
//        
//        let yOffset = collectionView.contentOffset.y
//        if(yOffset < 0){
//            collectionView.frame.origin.y = originalY //144 //144 is the starting point
//            collectionView.frame.size = CGSize(width: collectionView.frame.width, height: originalHeight)
//            historyContainerView.frame.origin.y = containerOriginalY
////            historyContainerView.frame.origin.y = originalY - originalHeight
//        } else if yOffset < historyHeightConstraint.constant  {
//            collectionView.frame.origin.y = originalY - collectionView.contentOffset.y
//            historyContainerView.frame.origin.y = containerOriginalY - collectionView.contentOffset.y
//            let newHeight = originalHeight + collectionView.contentOffset.y
//            //            print(newHeight)
//            collectionView.frame.size = CGSize(width: collectionView.frame.width, height: newHeight)
//        } else {
//            collectionView.frame.origin.y = navBarHeight
//            let newHeight = originalHeight + historyHeightConstraint.constant
//            collectionView.frame.size = CGSize(width: collectionView.frame.width, height: newHeight)
//            historyContainerView.frame.origin.y = 44 + -containerOriginalHeight
//        }
//        //        print(collectionView.frame)
//        print(historyContainerView.frame.origin.y)
//    }
    
    func adjustHistoryViewBecauseScrollChangedAllTheWay(){
        let yOffset = collectionView.contentOffset.y
        if(yOffset < 0){
            collectionView.frame.origin.y = originalY //144 //144 is the starting point
            historyContainerView.frame.origin.y = containerOriginalY
            navigationController?.navigationBar.alpha = 1
        } else if yOffset < historyHeightConstraint.constant + containerOriginalY - statusBarHeight{
            collectionView.frame.origin.y = originalY - collectionView.contentOffset.y
            historyContainerView.frame.origin.y = containerOriginalY - collectionView.contentOffset.y
//            let delta = 1 - ((featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight))
//            navigationController?.navigationBar.alpha.
            
        } else {
            collectionView.frame.origin.y = 0 + statusBarHeight
            historyContainerView.frame.origin.y = -containerOriginalHeight + statusBarHeight
            navigationController?.navigationBar.alpha = 0
        }
    }
}

//extension GenreViewController : UICollectionViewDelegateFlowLayout {
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 10.0
//    }
//}

