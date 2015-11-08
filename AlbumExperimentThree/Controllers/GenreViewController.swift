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
    
    override func viewDidLayoutSubviews() {
        //These may not have to be here.  Older versions got them dynamically
        originalY = 224
        containerOriginalY = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if sender is UICollectionViewCell {
            let indexPath = collectionView.indexPathForCell(sender as! UICollectionViewCell)!
            let data = genreData![indexPath.row]
            
            if data.isPodcast{
        // Incomplete
        //            let viewController = segue.destinationViewController as! PodcastListViewController
        //            //Acually, there's nothing to set.
        //            viewController.title = bundle.title
            } else {
                let albumViewController = segue.destinationViewController as! AlbumViewController
                albumViewController.genreData = data
            }
        } else {
            
            //Something else.  I noticed that this method gets called when this view controller is loaded too.
        }
    }


}

extension GenreViewController{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GenreCell", forIndexPath: indexPath) as! GenreCollectionViewCell
        
        cell.data = genreData[indexPath.row]
        return cell
    }
}

extension GenreViewController {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        adjustHistoryViewBecauseScrollChangedAllTheWay()
    }
    
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
