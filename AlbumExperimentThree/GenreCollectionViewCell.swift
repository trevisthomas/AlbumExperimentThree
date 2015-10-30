//
//  GenreCollectionViewCell.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/28/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var tintView: UIView!
    @IBOutlet weak var genreTitleLabel: UILabel!
    @IBOutlet weak var genreDetailLabel: UILabel!
    private var colorCube = CCColorCube()
    
    var data : GenreData! {
        didSet {
            genreTitleLabel.text = data.title
            genreDetailLabel.text = data.detail
            artworkImageView.image = data.artwork
            
            //TODO:  This is kind of taxing.  Should precalculate these and put them into the data class
            let color = colorCube.extractColorsFromImage(data.artwork, flags: CCAvoidWhite.rawValue, count: 4)
//            print(color)
            tintView.backgroundColor = color[3] as? UIColor
            genreTitleLabel.textColor = color[0] as? UIColor
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
//        let minAlpha: CGFloat = 0.3
//        let maxAlpha: CGFloat = 0.75
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.95

        tintView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        //Scaling the text
        let scale = max(delta, 0.5)
        genreTitleLabel.transform = CGAffineTransformMakeScale(scale, scale)
//        genreTitleLabel.alpha = delta
        genreDetailLabel.alpha = delta
    }
    
}
