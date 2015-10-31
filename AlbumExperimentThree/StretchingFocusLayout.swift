//
//  StretchingFocusCollectionViewLayout.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/28/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//   
//  This custom layout is based on UltravisualLayout.swift by Mic Pringle
//
//

import UIKit

/* The heights are declared as constants outside of the class so they can be easily referenced elsewhere */
struct StretchingFocusLayoutConstants {
    struct Cell {
        /* The height of the non-featured cell */
        static let standardHeight: CGFloat = 80
        /* The height of the first visible cell */
        static let featuredHeight: CGFloat = 200
     
    }
}

class StretchingFocusLayout: UICollectionViewLayout {
    // MARK: Properties and Variables
    
    /* The amount the user needs to scroll before the featured cell changes */
//    let dragOffset: CGFloat = 180.0 //Trevis, this controls the speed.
    let dragOffset: CGFloat = 160+44 //Trevis, this controls the speed. (for some reason i had to increae this to get my first scroll to hide my entire header
    
    var cache = [UICollectionViewLayoutAttributes]()
    
    /* Returns the item index of the currently featured cell */
    var featuredItemIndex: Int {
        get {
            /* Use max to make sure the featureItemIndex is never < 0 */
            return max(0, Int(collectionView!.contentOffset.y / dragOffset))
        }
    }
    
    /* Returns a value between 0 and 1 that represents how close the next cell is to becoming the featured cell */
    var nextItemPercentageOffset: CGFloat {
        get {
            return (collectionView!.contentOffset.y / dragOffset) - CGFloat(featuredItemIndex)
        }
    }
    
    /* Returns the width of the collection view */
    var width: CGFloat {
        get {
            return CGRectGetWidth(collectionView!.bounds)
        }
    }
    
    /* Returns the height of the collection view */
    var height: CGFloat {
        get {
            return CGRectGetHeight(collectionView!.bounds)
        }
    }
    
    /* Returns the number of items in the collection view */
    var numberOfItems: Int {
        get {
            return collectionView!.numberOfItemsInSection(0)
        }
    }
    
    // MARK: UICollectionViewLayout
    
    /* Return the size of all the content in the collection view */
    override func collectionViewContentSize() -> CGSize {
        let contentHeight = (CGFloat(numberOfItems) * dragOffset) + (height - dragOffset)
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepareLayout() {
        cache.removeAll(keepCapacity: false)
        
        let standardHeight = StretchingFocusLayoutConstants.Cell.standardHeight
        let featuredHeight = StretchingFocusLayoutConstants.Cell.featuredHeight
        var frame = CGRectZero
        var y : CGFloat = 0
        
        for item in 0..<numberOfItems {
            //1
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            
            //2
            attributes.zIndex = item
            var height = standardHeight
            
            //3
            if indexPath.item == featuredItemIndex {
                //4
                let yOffset = standardHeight * nextItemPercentageOffset
                y = collectionView!.contentOffset.y - yOffset
                height = featuredHeight
            } else if indexPath.item == (featuredItemIndex + 1) && indexPath.item != numberOfItems{
                //5
                let maxY = y + standardHeight
                height = standardHeight + max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
                y = maxY - height
                
            }
            
            //Trevis:  This pins the top cell to the top of the scrollpane during a pulldown
            if(indexPath.row == 0){
                if y < 0 {
                    height = height + -y
                    y = collectionView!.contentOffset.y
                }
            }
            
            //6
            frame = CGRect(x: 0, y: y, width: width, height: height)
            attributes.frame = frame
            cache.append(attributes)
            y = CGRectGetMaxY(frame)
        }
        
    }
    
    /* Return all attributes in the cache whose frame intersects with the rect passed to the method */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    /* Return true so that the layout is continuously invalidated as the user scrolls */
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    //What the article called smooth scrolling. Basically it causes the closest item to the top to roll to the top when you stop dragging.
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.y / dragOffset)
        let yOffset = itemIndex * dragOffset
        return CGPoint(x: 0, y: yOffset)
    }
}