//
//  NowPlayingViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/23/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController {
    var originMini : CGFloat!
    var originFull : CGFloat!
    var dragFromY : CGFloat!
    var draggingFromMini = true
    
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var miniView: UIView!
    private let dragTranslationThreshold : CGFloat = 100.0
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan:")
        self.view.gestureRecognizers = [panRecognizer]
        
//        UITapGestureRecognizer
        
        let miniViewTapRecognizer = UITapGestureRecognizer(target: self, action: "miniViewTapped:")
        miniView.gestureRecognizers = [miniViewTapRecognizer]
        
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func detectPan(recognizer : UIPanGestureRecognizer){
        let translation = recognizer.translationInView(self.view.superview)
        
        print(translation.y)
        
        if recognizer.state == UIGestureRecognizerState.Began {
//            print("Begin: \(self.view.frame.origin.y)")
            draggingFromMini = originMini == self.view.frame.origin.y
            print("Dragging from mini \(draggingFromMini)")
        }
        
        if recognizer.state == UIGestureRecognizerState.Ended {
            //if(translation.y > 0){
            if(draggingFromMini){
                //Now playing is opened and the user is pulling it down
                if(abs(translation.y) < dragTranslationThreshold){
                    animateToPosition(originMini)
                } else{
                    animateToPosition(originFull)
                }
            } else {
                //Now playing is mini and the user is pulling it up
                if(translation.y > dragTranslationThreshold){
                    animateToPosition(originMini)
                } else {
                    animateToPosition(originFull)
                }
                
            }
        } else {
            
            if(draggingFromMini && translation.y > 0.0){
                return //Rejected.  Dont let them drag the mini even lower!
            } else if (!draggingFromMini && translation.y < 0.0){
                return //Rejected.  Dont let them drag the full player higher!
            } else {
                //Good to go
                self.view.frame.origin.y = dragFromY + translation.y
            }
        }
    }
    
    
    func miniViewTapped(recognizer : UITapGestureRecognizer){
        animateToPosition(originFull)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dragFromY = self.view.frame.origin.y
    }
    
    private func animateToPosition(newPosition : CGFloat){
        print("Animating to \(newPosition)")
        UIView.animateWithDuration(0.25, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseInOut], animations: {
            self.view.frame.origin.y = newPosition
            self.view.layoutIfNeeded()
            }, completion: nil)
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
