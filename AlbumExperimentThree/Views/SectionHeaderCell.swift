//
//  SectionHeaderCell.swift
//  Album Experiment
//
//  Created by Trevis Thomas on 10/17/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class SectionHeaderCell: UICollectionViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    var title : String!{
        didSet{
//            headerLabel.text = title.uppercaseString
            headerLabel.text = title
        }
    }
    
//    override func prepareForReuse(){
//        headerLabel.hidden = true
//        frame.size.height = 0
//    }
}
