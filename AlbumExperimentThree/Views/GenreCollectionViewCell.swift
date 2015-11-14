//
//  GenreCollectionViewCell.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/28/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var lineSeperatorView: LineSeperatorView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var tintView: UIView!
    @IBOutlet weak var genreTitleLabel: UILabel!
    @IBOutlet weak var genreDetailLabel: UILabel!
    @IBOutlet weak var blurVisualEffectView: UIVisualEffectView!
    @IBOutlet weak var genreTitleStandard: UILabel!
    @IBOutlet weak var genreDetailStandard: UILabel!
    
    private var colorCube = CCColorCube()
    
    var data : GenreData! {
        didSet {
            genreTitleLabel.text = data.title
            genreDetailLabel.text = data.detail
            artworkImageView.image = data.artwork
            
            
            genreDetailStandard.text = data.detail
            genreTitleStandard.text = data.title
//            artworkImageView.image = data.art.imageWithSize(CGSize(width: 500,height: 500))
            //TODO:  This is kind of taxing.  Should precalculate these and put them into the data class
//            let color = colorCube.extractColorsFromImage(data.artwork, flags: CCAvoidWhite.rawValue | CCAvoidBlack.rawValue, count: 4)
//            print(color)

//            tintView.backgroundColor = data.colorsInArtwork[3]
         //   genreTitleLabel.textColor = data.colorsInArtwork[0]
        }
    }
    
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        //1
        let standardHeight = StretchingFocusLayoutConstants.Cell.standardHeight
        let featuredHeight = StretchingFocusLayoutConstants.Cell.featuredHeight
        
        //2
        let delta = 1 - ((featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight))
        
        //3
//        tintView.alpha.scaleYourself(withDelta: delta, minAlpha: 0.35, maxAlpha: 0.50)
//         tintView.alpha.scaleYourself(withDelta: delta, minAlpha: 0.5, maxAlpha: 1.0)
        
        tintView.alpha = 0
        artworkImageView.alpha.scaleYourself(withDelta: 1 - delta, minAlpha: 0.0, maxAlpha: 0.3)
        
        //blurVisualEffectView.alpha.scaleYourself(withDelta: delta, minAlpha: 0.0, maxAlpha: 0.90)
        blurVisualEffectView.alpha = 0
        
        lineSeperatorView.alpha.scaleYourself(withDelta: delta, minAlpha: 0.0, maxAlpha: 1.0)
        
        //Scaling the text
        let scale = max(delta, 0.5)
        
        genreTitleLabel.transform = CGAffineTransformMakeScale(scale, scale)
//        scale = max(1 + delta, 1.0)
        genreDetailLabel.transform = CGAffineTransformMakeScale(scale, scale)
        
        //Hiding the standard titles
        genreTitleStandard.alpha = 1 - delta
        genreDetailStandard.alpha = 1 - delta
        

        //Showing the growing title
        genreDetailLabel.alpha = delta
        genreTitleLabel.alpha = delta
        
     
    }
    
    
    
}
