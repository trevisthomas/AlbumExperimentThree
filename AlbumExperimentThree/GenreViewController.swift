//
//  GenreViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/23/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class GenreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
    private let genreCellIdentifier = "GenreCell"
    @IBOutlet weak var heightConstraintForHistoryView: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    var originalY : CGFloat!
    var originalHeight : CGFloat!
    let navBarHeight : CGFloat = 44.0
    let heightOfHistoryView : CGFloat = 100.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalY = tableView.frame.origin.y //Stashing the original y position of the table frame
//        originalHeight = tableView.frame.height
        
//        tableView.del
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: genreCellIdentifier)
        title = "I am bob."
        
     //   containerViewNavigationController.navigationBar.topItem?.title = "Can you hear me now?"
        
//        let buttonItem = UIBarButtonItem(title: "Test", style: UIBarButtonItemStyle.Plain, target: self, action: "leftNavButtonPress")
//        
//        containerViewNavigationController.navigationBar.topItem?.leftBarButtonItem = buttonItem
    }
    
    override func viewDidLayoutSubviews() {
        originalHeight = tableView.bounds.height
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(genreCellIdentifier, forIndexPath: indexPath)
        cell.textLabel!.text = "Test \(indexPath.row)"
        return cell
    }
    
    //MARK: Trying to hide the history view when the table is scrolled
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //I think that the nav bar is 44px
        //TODO: Figure out how to get the height param out of heightConstraintForHistoryView.
        
        let yOffset = tableView.contentOffset.y
        if(yOffset < 0){
            tableView.frame.origin.y = originalY //144 //144 is the starting point
            tableView.frame.size = CGSize(width: tableView.frame.width, height: originalHeight)
        } else if yOffset < heightOfHistoryView  { //The 100.0 here is the height of the history view.  You should get this from the constraint
            tableView.frame.origin.y = originalY - tableView.contentOffset.y
            let newHeight = originalHeight + tableView.contentOffset.y
            print(newHeight)
            tableView.frame.size = CGSize(width: tableView.frame.width, height: newHeight)
        } else {
            tableView.frame.origin.y = navBarHeight
            let newHeight = originalHeight + heightOfHistoryView
            tableView.frame.size = CGSize(width: tableView.frame.width, height: newHeight)
        }
        print(tableView.frame)
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
