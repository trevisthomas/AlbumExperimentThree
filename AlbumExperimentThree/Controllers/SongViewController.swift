//
//  SongViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/15/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class SongViewController: UIViewController {

    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var blurredCover: UIImageView!
    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var headerAlbumArtView: UIView!
    
    var headerBlurOverlay : UIImageView!
//    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
//    var colorPalette : ImageColorPalette!
    
//    private var originalY : CGFloat!
//    private var originalHeight : CGFloat!
//    private var containerOriginalY : CGFloat!
//    private var containerOriginalHeight : CGFloat!
//    private let statusBarHeight : CGFloat = 20 + 44
//    private let navBarHeight : CGFloat = 44.0
    
    var customNavigationTitleView : DoubleNavigationTitleView!
    
    private var headerAlbumArtViewHeight : CGFloat = 348; //TODO: use the constraint to get the value from IB
    
    var albumData : AlbumData! {
        didSet {
            
        }
    }
    
    //These rects are for the transition animation.  
    var sourceAlbumCoverRect : CGRect!
    var sourceAlbumBoxRect : CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewComponents()

        // Do any additional setup after loading the view.
    }
    
    private func initViewComponents(){
        
        albumCover.image = albumData.albumArtWithSize(albumCover.bounds.size)
        
//        let colors = albumCover.image?.extractColorsUsingColorCubeSimple(numberOfColorsToExtract: 3)
//        view.backgroundColor = colors![0]
//        blurredCover.backgroundColor = colors![0]
        
//        colorPalette = ImageColorPalette(fromImage: albumCover.image!)
        
        let colorPalette = albumData.colorPalette
        view.backgroundColor = colorPalette.backgroundColor
        blurredCover.backgroundColor = colorPalette.backgroundColor

        
        //Blur
        //Create a small image so that the blur is fast
        let blurSource = albumData.albumArtWithSize(CGSize(width: 64, height: 64))
        //Blur using UIImage+ImageEffects
        let blurredImage = blurSource.applyBlurWithRadius(15, tintColor: view.backgroundColor?.colorWithAlphaComponent(0.3), saturationDeltaFactor: 1.8, maskImage: nil)
        //Generate a mask so that the blurred image fades nicely into the background
        let maskImage = UIImage.generateAlbumCoverVignette(blurredCover.frame)
        //Assign the blurred image
        blurredCover.image = blurredImage.maskImageWithMask(maskImage)
        
        
        let navBackgroundRect = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 64)
//        let blurEffect = UIBlurEffect(style: .Light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = navBackgroundRect
//        view.addSubview(blurEffectView)
        
        self.customNavigationTitleView = DoubleNavigationTitleView(frame: navBackgroundRect)
//        customNavigationTitleView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        customNavigationTitleView.backgroundColor = colorPalette.backgroundColor //UIColor.clearColor()
        customNavigationTitleView.title = albumData.title
        customNavigationTitleView.subTitle = albumData.artist
        customNavigationTitleView.textColor = colorPalette.headerTextColor
        customNavigationTitleView.alpha = 0 //Start off hidden
        view.addSubview(customNavigationTitleView)
        
        self.navigationController!.navigationBar.tintColor = colorPalette.secondaryTextColor
        navigationController?.navigationBar.setStatusBarColor(colorPalette.secondaryTextColor)
        
        
//        originalHeight = songTableView.bounds.height
//        containerOriginalHeight = headerAlbumArtView.bounds.height
////        originalY = headerHeightConstraint.constant
//        originalY = 348
//        containerOriginalY = 0
        
        //Not sure why i couldnt set this inset in IB, it would work there.
//        songTableView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
        
        //This remove readd hack is for stretching
        songTableView.tableHeaderView = nil
        songTableView.addSubview(headerAlbumArtView)
        
        songTableView.contentInset = UIEdgeInsets(top: -64 + headerAlbumArtViewHeight, left: 0, bottom: 0, right: 0)
        songTableView.contentOffset = CGPoint(x: 0, y: -headerAlbumArtViewHeight)
        
        updateHeaderView()
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

extension SongViewController : UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // albumData.
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SongCell", forIndexPath: indexPath)
        return cell
    }
}

extension SongViewController : UITableViewDelegate {
    
}

extension SongViewController : UIScrollViewDelegate {
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        
//        let yOffset = songTableView.contentOffset.y
//        //        let navBarY = -yOffset + statusBarHeight
//        //        print("NavY \(navBarY)")
//        //        if(navBarY <= statusBarHeight){
//        //            navigationController?.navigationBar.frame.origin.y = navBarY
//        //        } else {
//        //            navigationController?.navigationBar.frame.origin.y = statusBarHeight
//        //        }
//        print("\(yOffset)")
//        if(yOffset <= 0){
//            print("first ")
//            songTableView.frame.origin.y = originalY //144 //144 is the starting point
//            headerAlbumArtView.frame.origin.y = containerOriginalY
//            
//            //            albumHistoryViewController.endBlur()
//            //                        albumHistoryViewController.overlayImageView.hidden = true
//            //            navigationController?.navigationBar.alpha = 1
//        } else if yOffset < 348/*headerHeightConstraint.constant*/ + containerOriginalY - statusBarHeight{
//            print("mid")
//            songTableView.frame.origin.y = originalY - songTableView.contentOffset.y
//            headerAlbumArtView.frame.origin.y = containerOriginalY - songTableView.contentOffset.y
//            
//            //            let delta = yOffset / (containerOriginalHeight - statusBarHeight)
//            ////            print ()
//            //
//            //            albumHistoryViewController.applyBlur(delta * 20)
//            
//            //            let image = albumHistoryViewController.view.getSnapshot()
//            //            let blured = image.pr_boxBlurredImageWithRadius(10)
//            //            albumHistoryViewController.overlayImageView.hidden = false
//            //            albumHistoryViewController.overlayImageView.image = blured
//            //
//            
//            //            UICont
//            //            let views = historyContainerView.
//            //            historyContainerView.overlayImageView.hidden = false
//            
//            
//            //            let imageView = UIImageView(image: blured)
//            //            historyContainerView.addSubview(imageView)
//            
//            //            let delta = 1 - ((featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight))
//            //            navigationController?.navigationBar.alpha.
//            
//            
//            
//        } else {
//            print("thurd")
//            songTableView.frame.origin.y = 0 + statusBarHeight
//            headerAlbumArtView.frame.origin.y = -containerOriginalHeight + statusBarHeight
//            
//            //            albumHistoryViewController.endBlur()
//            //            albumHistoryViewController.overlayImageView.hidden = true
//            //            navigationController?.navigationBar.alpha = 0
//        }
//    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func updateHeaderView(){
        var headerRect = CGRect(x: 0, y: -headerAlbumArtViewHeight, width: songTableView.bounds.width, height: headerAlbumArtViewHeight)
        
        print("offset \(songTableView.contentOffset.y) compare \(-headerAlbumArtViewHeight)")
        if songTableView.contentOffset.y < -headerAlbumArtViewHeight {
            headerRect.origin.y = songTableView.contentOffset.y
            headerRect.size.height = -songTableView.contentOffset.y
            print(headerRect)
        }
        headerAlbumArtView.frame = headerRect
        
        let offset = -songTableView.contentOffset.y
        
        var alpha : CGFloat = 1
        if (offset <= 0) {
            alpha = 0
        }
        else if(offset > 0 && offset < headerAlbumArtViewHeight) {
            alpha = offset / headerAlbumArtViewHeight
            
            

        } else {
            alpha = 1
        }
//                    print("delta: \(delta)")

        blurredCover.alpha = alpha
        albumCover.alpha = alpha
        
        customNavigationTitleView.alpha = 1 - alpha

//        headerAlbumArtView

    }
}
