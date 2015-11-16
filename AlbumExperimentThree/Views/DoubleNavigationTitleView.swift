//
//  DoubleNavigationTitleView.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 11/16/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class DoubleNavigationTitleView: UIView {

    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var subTitle : String! {
        didSet {
            subTitleLabel.text = subTitle
        }
    }
    
    var title : String! {
        didSet {
            titleLabel.text = title
        }
    }
    
    var textColor : UIColor!{
        didSet {
            subTitleLabel.textColor = textColor
            titleLabel.textColor = textColor
        }
    }
    
    // Our custom view from the XIB file
    var view: UIView!
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
//        let nib = UINib(nibName: "\(NSStringFromClass(self.classForCoder)).xib" , bundle: bundle)
//        let nib = UINib(nibName: "DoubleNavigationTitleView.xib" , bundle: bundle)
        let nib = UINib(nibName: "DoubleNavigationTitleView" , bundle: bundle)
        
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView

        return view
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    
    
    
//    init(frame: CGRect) {
//        self = NSBundle.mainBundle().loadNibNamed("Games-New", owner: nil, options: nil)[0]
//    }
//    
//    - (id)initWithFrame:(CGRect)frame
//    {
//    self = [NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil][0];
//    if (self)
//    {
//    self.frame = frame;
//    }
//    return self;
//    }
    
    
    
//    did

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
