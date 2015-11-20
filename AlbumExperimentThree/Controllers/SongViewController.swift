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
//    var colorPalette : ImageColorPalette!
    
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
        
        let customNavigationTitleView = DoubleNavigationTitleView(frame: navBackgroundRect)
//        customNavigationTitleView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        customNavigationTitleView.backgroundColor = UIColor.clearColor()
        customNavigationTitleView.title = albumData.title
        customNavigationTitleView.subTitle = albumData.artist
        customNavigationTitleView.textColor = colorPalette.headerTextColor
        view.addSubview(customNavigationTitleView)
        
        self.navigationController!.navigationBar.tintColor = colorPalette.secondaryTextColor
        navigationController?.navigationBar.setStatusBarColor(colorPalette.secondaryTextColor)
        
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
