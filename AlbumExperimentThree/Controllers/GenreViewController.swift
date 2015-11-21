//
//  GenreViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/28/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class GenreViewController: UIViewController, UICollectionViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var historyContainerView: UIView!
    @IBOutlet weak var historyHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    private var genreData : [GenreData]!
    private var originalY : CGFloat!
    private var originalHeight : CGFloat!
    
    private var containerOriginalY : CGFloat!
    private var containerOriginalHeight : CGFloat!
    
    private let statusBarHeight : CGFloat = 20 + 44
    private let navBarHeight : CGFloat = 44.0
    private var albumHistoryViewController : AlbumHistoryViewController!

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
        
        self.navigationController!.navigationBar.tintColor = UIColor.blackColor()
        navigationController?.navigationBar.setStatusBarColor(UIColor.blackColor())

        
        originalHeight = collectionView.bounds.height
        containerOriginalHeight = historyContainerView.bounds.height
        originalY = 224
        containerOriginalY = 0

        for vc in self.childViewControllers {
            if let _ = vc as? AlbumHistoryViewController{
                albumHistoryViewController = vc as! AlbumHistoryViewController
            }
        }
        
        //After a lot of fussing.  I ended up setting the height of the collection view to be taller than the screen in interface builder (i bound the bottom to -204 so that i dont have to change the height of that view as the History hides
    }
    
    override func viewDidLayoutSubviews() {
//        //These may not have to be here.  Older versions got them dynamically
//        originalY = 224
//        containerOriginalY = 0
        
        //Calling this here for when the view is restored from segue.  If i didnt do this, the nowPlaying guy would be expanded no matter where the scrollbar was!
        adjustHistoryViewBecauseScrollChangedAllTheWay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        
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
            print(sender)
            //Something else.  I noticed that this method gets called when this view controller is loaded too.
        }
    }
    
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        if sender is UICollectionViewCell {
//            let indexPath = collectionView.indexPathForCell(sender as! UICollectionViewCell)!
//            
//            let layout = collectionView.collectionViewLayout as! StretchingFocusLayout
//            print("IP \(indexPath.item)")
//            let offset = layout.dragOffset * CGFloat(indexPath.row)
//            if collectionView.contentOffset.y != offset {
//                collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
//                return false;
//            } else {
//                //            performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
////                navigationController?.pushViewController(AlbumViewController(), animated: true)
//                return true;
//            }
//            
//            var test = genreData[indexPath.row]
//            print(test.title)
//        }
//        
//        else {
//            return true
//        }
//    }
//    

}

extension GenreViewController : UICollectionViewDataSource {
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
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let layout = collectionView.collectionViewLayout as! StretchingFocusLayout
        let offset = layout.dragOffset * CGFloat(indexPath.row)
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
    }
}


extension GenreViewController {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//                print ("Began")
        adjustHistoryViewBecauseScrollChangedAllTheWay()
        applyBlur()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        print ("Will begin scroll")
        
        
        //The willBlur method causes the aera to flash
//        albumHistoryViewController.willBlur()
    }
    
    func adjustHistoryViewBecauseScrollChangedAllTheWay(){
        let yOffset = collectionView.contentOffset.y
//        let navBarY = -yOffset + statusBarHeight
//        print("NavY \(navBarY)")
//        if(navBarY <= statusBarHeight){
//            navigationController?.navigationBar.frame.origin.y = navBarY
//        } else {
//            navigationController?.navigationBar.frame.origin.y = statusBarHeight
//        }
        
        if(yOffset <= 0){

            collectionView.frame.origin.y = originalY //144 //144 is the starting point
            historyContainerView.frame.origin.y = containerOriginalY
            
//            albumHistoryViewController.endBlur()
//                        albumHistoryViewController.overlayImageView.hidden = true
//            navigationController?.navigationBar.alpha = 1
        } else if yOffset < historyHeightConstraint.constant + containerOriginalY - statusBarHeight{
            collectionView.frame.origin.y = originalY - collectionView.contentOffset.y
            historyContainerView.frame.origin.y = containerOriginalY - collectionView.contentOffset.y
            
//            let delta = yOffset / (containerOriginalHeight - statusBarHeight)
////            print ()
//            
//            albumHistoryViewController.applyBlur(delta * 20)
            
//            let image = albumHistoryViewController.view.getSnapshot()
//            let blured = image.pr_boxBlurredImageWithRadius(10)
//            albumHistoryViewController.overlayImageView.hidden = false
//            albumHistoryViewController.overlayImageView.image = blured
//            
            
//            UICont
//            let views = historyContainerView.
//            historyContainerView.overlayImageView.hidden = false
            
            
//            let imageView = UIImageView(image: blured)
//            historyContainerView.addSubview(imageView)
            
//            let delta = 1 - ((featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight))
//            navigationController?.navigationBar.alpha.
            
 
            
        } else {
            collectionView.frame.origin.y = 0 + statusBarHeight
            historyContainerView.frame.origin.y = -containerOriginalHeight + statusBarHeight
            
//            albumHistoryViewController.endBlur()
//            albumHistoryViewController.overlayImageView.hidden = true
//            navigationController?.navigationBar.alpha = 0
        }
    }
    
    private func applyBlur(){
        let yOffset = collectionView.contentOffset.y
        if(yOffset <= 0){
            //View is fully extended
            albumHistoryViewController.endBlur(true)
        } else if yOffset < historyHeightConstraint.constant + containerOriginalY {
            //view is partially shown
            let delta = (yOffset / (containerOriginalHeight))
            albumHistoryViewController.applyBlur(delta.exponentialDelta() * 100, alpha: delta)
        } else {
            //history view is closed
            albumHistoryViewController.endBlur(false)
        }
    }
    
    
}

