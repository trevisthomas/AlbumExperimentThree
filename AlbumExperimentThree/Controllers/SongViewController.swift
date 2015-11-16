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
    var colorPalette : ImageColorPalette!
    
    var albumData : AlbumData! {
        didSet {
            
        }
    }
    
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
        
        colorPalette = ImageColorPalette(fromImage: albumCover.image!)
        
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
