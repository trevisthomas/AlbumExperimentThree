//
//  AlbumViewController.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/17/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class AlbumViewController: UICollectionViewController, UICollectionViewDelegateLeftAlignedLayout {

//    let cellInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 200.0, right: 0.0)
    var albumCellWidth : CGFloat!
    var albumCellHeight : CGFloat!
    var artistCellWidth : CGFloat!
    let artistCellHeight : CGFloat = 50.0
    
    //Segue must set this to an existing genre or things will go bad fast
    var genreData : GenreData! {
        didSet{
            self.title = genreData.title
        }
    }
    
    var indexedArtistData : [String : [AlbumData]]! {
        didSet{
            sections = indexedArtistData.keys.sort()
        }
    }
    
    var albumIds : [NSNumber] = []  //This is for when it is new album mode
    
    var sections : [String]!
    
    var indexView : BDKCollectionIndexView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(AlbumHistoryViewCell.self, forCellWithReuseIdentifier: "AlbumCell")

        // Do any additional setup after loading the view.
        
        if genreData.isNewAlbums {
//            indexedArtistData = ["Recient Additions": [AlbumData()]]
            indexedArtistData = [:]
            
            
//
//            
//            AppDelegate.getSavedData().determineNewAlbums() {
//                if self.indexedArtistData.isEmpty {
//                    var fauxIndex: [String : [AlbumData]] = [:]
//                    fauxIndex["Recient Additions"] = MusicLibrary.instance.queryAlbumsByPersistenceIDs($0)
//                    self.indexedArtistData = fauxIndex
//                } else {
////                    var albumsInSection = self.indexedArtistData["Recient Additions"]
//                    let ipZero = NSIndexPath(forRow: 0, inSection: 0)
//                    for albumId in $0 {
//                        let albumData = MusicLibrary.instance.queryAlbumByPersistenceID(albumId)
//                        self.indexedArtistData["Recient Additions"]!.insert(albumData, atIndex: 0)
//                        self.collectionView?.insertItemsAtIndexPaths([ipZero])
//                        //TREVIS! Some times the animation should be a move!
//                    }
//                }
//            }
            
            sections.append("A")
            AppDelegate.getSavedData().determineNewAlbums() {
                if self.albumIds.isEmpty {
                    self.albumIds.appendContentsOf($0)
                    self.collectionView?.reloadData() //?
                } else {
                    let ipZero = NSIndexPath(forRow: 0, inSection: 0)
                    for albumId in $0 {
                        self.albumIds.insert(albumId, atIndex: 0)
                        self.collectionView?.insertItemsAtIndexPaths([ipZero])
                    }
                }
                    
            }
            
        } else {
            indexedArtistData = MusicLibrary.instance.getArtistBundle(genreData.title)
        }
        
//        artistCellWidth = self.collectionView!.bounds.size.width - cellInsets.left - cellInsets.right
//        albumCellWidth = (calculateShortSide() - cellInsets.left - cellInsets.right) / 2.0
//        albumCellHeight = albumCellWidth //Same for now.  May make non square for titles
        
//        let contentInset = collectionView!.contentInset
//        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 50, right: contentInset.right)
        
        collectionView?.contentInset = contentInsets

        adjustCellDimensions(toOrientation: UIApplication.sharedApplication().statusBarOrientation)
        
        //https://gist.github.com/kreeger/4756030
        buildIndexView()
        indexView.indexTitles = sections
        view.addSubview(indexView) //This wasnt in the demo
        
        //Trevis, i'm not sure where to put this code.  
        let navBackgroundRect = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 64)
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = navBackgroundRect
        view.addSubview(blurEffectView)
        
        let navigationPlusStatusBackgroundView = UIView(frame: navBackgroundRect)
        navigationPlusStatusBackgroundView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        view.addSubview(navigationPlusStatusBackgroundView)
        
        //This was a quick change to remove section headers.
        collectionView?.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "EmptySection")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.tintColor = UIColor.blackColor()
        navigationController?.navigationBar.setStatusBarColor(UIColor.blackColor())
    }
    
    private func calculateShortSide() ->CGFloat{
        if(self.collectionView!.bounds.size.width < self.collectionView!.bounds.size.height){
            return self.collectionView!.bounds.size.width
        } else {
            return self.collectionView!.bounds.size.height
        }
    }
    
    private func calculateLongSide() ->CGFloat{
        if(self.collectionView!.bounds.size.width > self.collectionView!.bounds.size.height){
            return self.collectionView!.bounds.size.width
        } else {
            return self.collectionView!.bounds.size.height
        }
    }

    
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
//        var referenceWidth : CGFloat!
//        if(toInterfaceOrientation.isLandscape){
//            referenceWidth = self.collectionView!.bounds.size.height
//        } else {
//            referenceWidth = self.collectionView!.bounds.size.width
//        }
//        
//        artistCellWidth = referenceWidth - cellInsets.left - cellInsets.right
//        collectionView?.collectionViewLayout.invalidateLayout()
        
        
//        adjustCellDimensions(toOrientation: toInterfaceOrientation)
    }
    
    private func adjustCellDimensions(toOrientation orientation : UIInterfaceOrientation ){
        var referenceWidth : CGFloat!
        var itemsPerRow : CGFloat!
        if(orientation.isLandscape){
//            referenceWidth = self.collectionView!.bounds.size.height
            referenceWidth = calculateLongSide()
            itemsPerRow = 4.0
        } else {
//            referenceWidth = self.collectionView!.bounds.size.width
            referenceWidth = calculateShortSide()
            itemsPerRow = 3.0
        }
        
        albumCellWidth = (referenceWidth - contentInsets.left - contentInsets.right - (itemsPerRow * 4)) / itemsPerRow
        albumCellHeight = albumCellWidth +  (0.2 * albumCellWidth) //Same for now.  May make non square for titles
        
        artistCellWidth = referenceWidth - contentInsets.left - contentInsets.right
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if sender is AlbumHistoryViewCell {
            let cell = sender as! AlbumHistoryViewCell

            let indexPath = collectionView!.indexPathForCell(sender as! AlbumHistoryViewCell)!
//            let albumData = (indexedArtistData[sections[indexPath.section]])![indexPath.row]
            let albumData = getAlbumDataAtIndexPath(indexPath)

            let songViewController = segue.destinationViewController as! SongViewController
            songViewController.albumData = albumData
            
            
            songViewController.sourceAlbumBoxRect = cell.outerBoxView.boundsOnScreen()
            songViewController.sourceAlbumCoverRect = cell.artworkImageView.boundsOnScreen()

        } else {
            print(sender)
            //Something else.  I noticed that this method gets called when this view controller is loaded too.
        }
    }
    
    
//    //TODO, maybe move this to an extention?
//    private func convertToScreenRect( sourceView : UIView) -> CGRect{
//        let origin = sourceView.convertPoint(sourceView.bounds.origin, toView: nil)
//        let newRect = CGRect(origin: origin, size: sourceView.bounds.size)
//        return newRect
//    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sections.count
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (indexedArtistData.isEmpty) {
            return albumIds.count
        } else {
            return (indexedArtistData[sections[section]]?.count)!
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let albumData : AlbumData = getAlbumDataAtIndexPath(indexPath)
        
        
        if(albumData.type == AlbumData.DataType.ARTIST){
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ArtistNameCell", forIndexPath: indexPath) as! ArtistTitleCell
            cell.artistName = albumData.artist
//            cell.adjustSize(self.collectionView!.bounds.size)
            
            return cell

        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumCell", forIndexPath: indexPath) as! AlbumHistoryViewCell
            cell.albumData = albumData
            return cell
        }
    }
    
    private func getAlbumDataAtIndexPath(indexPath : NSIndexPath) -> AlbumData{
        if (indexedArtistData.isEmpty) {
            return MusicLibrary.instance.queryAlbumByPersistenceID(albumIds[indexPath.row])
        } else {
            return (indexedArtistData[sections[indexPath.section]])![indexPath.row]

        }

    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
//            let cell =
//            collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SectionHeaderCell", forIndexPath: indexPath) as! SectionHeaderCell
//            cell.title = sections[indexPath.section]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EmptySection" , forIndexPath:  indexPath)

            return cell
        }
        abort()
    }

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//
//        let albumData = (indexedArtistData[sections[indexPath.section]])![indexPath.row]
//        if(albumData.type == AlbumData.DataType.ARTIST){
//           return CGSize(width: artistCellWidth, height: artistCellHeight)
//        }
//        else {
//            return CGSize(width: albumCellWidth, height: albumCellHeight)
//        }
//    }

        func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
//            let albumData = (indexedArtistData[sections[indexPath.section]])![indexPath.row]
            
//            let albumData : AlbumData = getAlbumDataAtIndexPath(indexPath)
            
            
            if (indexedArtistData.isEmpty) {
                return CGSize(width: 125, height: 150)
            }
            
            let albumData = (indexedArtistData[sections[indexPath.section]])![indexPath.row]
            
            if(albumData.type == AlbumData.DataType.ARTIST){
               return CGSize(width: collectionView.frame.width, height: 40.0)
            }
            else {
                return CGSize(width: 125, height: 150)
            }
        }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
//        return cellInsets
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 4.0 //Between
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 4.0 //Under
//    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 100, height: 100) //An attempt to space the section header's out. Seems to work.
        return CGSize(width: 100, height: 10)
    }
    
    
    //MARK: Index View
    /**
    
    Trevis! Basically these two methods get it done for adding the index to your collection view.  Notice how
    indexViewValueChanged is just passed in as a string when the Objective C class is expecting a selector
    */
    func buildIndexView() -> BDKCollectionIndexView{
        if(indexView != nil){
            return indexView
        }
        let indexWidth : CGFloat = 20;
        let frame : CGRect = CGRectMake(CGRectGetWidth(self.collectionView!.frame) - indexWidth,
            CGRectGetMinY(self.collectionView!.frame) + 100,
            indexWidth,
            CGRectGetHeight(self.collectionView!.frame) - 200);  //Insetting the top and bottom of the index.  Dont forgget.  Looks horible in landscape.
        
        indexView = BDKCollectionIndexView(frame: frame, indexTitles: [String]())
        indexView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleLeftMargin]
        indexView.addTarget(self, action: "indexViewValueChanged:", forControlEvents: .ValueChanged)
        return indexView
    }
    
    func indexViewValueChanged(view : BDKCollectionIndexView){
        let path = NSIndexPath(forItem: 0, inSection: Int(view.currentIndex))
        collectionView?.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
        
        // I bump the y-offset up by 45 points here to account for aligning the top of
        // the section header view with the top of the collectionView frame. It's
        // hardcoded, but you get the idea.
        collectionView!.contentOffset = CGPointMake(self.collectionView!.contentOffset.x,
            self.collectionView!.contentOffset.y - 65);// Weird magic number stuff
    }
    

    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
