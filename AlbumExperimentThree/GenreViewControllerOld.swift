//
//  GenreViewController.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/23/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit

class GenreViewControllerOld: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{
//    private let cellIdentifier = "GenreCell"
    @IBOutlet weak var heightConstraintForHistoryView: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    //These are for sizing the History area
    var originalY : CGFloat!
    var originalHeight : CGFloat!
    let navBarHeight : CGFloat = 44.0
//    let heightOfHistoryView : CGFloat = 100.0
    var heightOfHistoryView : CGFloat!
    
    //These are for resizing cells
    var growPath : NSIndexPath!
    var growPath2 : NSIndexPath!
    
    static let defaultHeight : Float = 80.0
    static let expandedHeight  : Float = 160.0
    var heightCellZero = expandedHeight
    var heightCellOne = defaultHeight
    
    
    var genreData : [GenreData]!
    
    
//    let computers = [
//        ["Name" : "MacBook Air", "Color" : UIColor.blueColor()],
//        ["Name" : "MacBook Pro", "Color" : UIColor.purpleColor()],
//        ["Name" : "iMac", "Color" : UIColor.yellowColor()],
//        ["Name" : "Mac Mini", "Color" : UIColor.redColor()],
//        ["Name" : "Mac Pro", "Color" : UIColor.greenColor()],
//        ["Name" : "MacBook Air", "Color" : UIColor.blueColor()],
//        ["Name" : "MacBook Pro", "Color" : UIColor.purpleColor()],
//        ["Name" : "iMac", "Color" : UIColor.yellowColor()],
//        ["Name" : "Mac Mini", "Color" : UIColor.redColor()],
//        ["Name" : "Mac Pro", "Color" : UIColor.greenColor()],
//        ["Name" : "MacBook Air", "Color" : UIColor.blueColor()],
//        ["Name" : "MacBook Pro", "Color" : UIColor.purpleColor()],
//        ["Name" : "iMac", "Color" : UIColor.yellowColor()],
//        ["Name" : "Mac Mini", "Color" : UIColor.redColor()],
//        ["Name" : "Mac Pro", "Color" : UIColor.greenColor()]        
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalY = tableView.frame.origin.y //Stashing the original y position of the table frame
        
//        tableView.registerClass(GenreTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        title = "My Collection"
        
        heightOfHistoryView = heightConstraintForHistoryView.constant
        
        genreData = MusicLibrary.instance.getGenreBundle()
        
        tableView.separatorColor = UIColor.clearColor()
        
//        let buttonItem = UIBarButtonItem(title: "Test", style: UIBarButtonItemStyle.Plain, target: self, action: "leftNavButtonPress")
//        
//        containerViewNavigationController.navigationBar.topItem?.leftBarButtonItem = buttonItem
    }
    
    override func viewDidLayoutSubviews() {
        //If i did this in viewDidLoad the size wasnt correct yet!
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
//        return 100
//        return computers.count + 1
        return genreData.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(genreCellIdentifier, forIndexPath: indexPath)
//        cell.textLabel!.text = "Test \(indexPath.row)"
//        return cell
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GenreCell", forIndexPath: indexPath) as! GenreTableViewCell
        cell.genreArtImageView.image = nil //Just resetting this
        
        if(indexPath.row >= genreData.endIndex){
            cell.renderAsSpacer = true
//
//            cell.genreNameLabel!.text = "Fin Row: \(indexPath.row)"
//            cell.backgroundColor = UIColor.clearColor()
            
        } else {
//            let rowData = genreData[indexPath.row]
            cell.genreNameLabel.text = genreData[indexPath.row].title
            
            if genreData[indexPath.row].art != nil {
                
                let size = cell.genreArtImageView.bounds.size
                cell.genreArtImageView.image = genreData[indexPath.row].art.imageWithSize(size)
            }
//            let value = rowData["Name"]! as! String
//            cell.genreNameLabel!.text = "\(value) row: \(indexPath.row)"
//            cell.backgroundColor = rowData["Color"] as? UIColor
        }
        updateCells() //Not sure why i had to do this
        
        return cell
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        adjustHistoryViewBecauseScrollChanged()
        adjustCellsBecauseScrollChanged()
        
//        print(tableView.contentOffset.y)
//        let cells = tableView.visibleCells
//        let topCell = cells[0]
//        
//        if(tableView.indexPathForCell(topCell)!.row == 0){
//            var newFrame : CGRect = CGRect(x: topCell.frame.origin.x, y: 0, width: topCell.frame.width, height: 160)
//            
//            if tableView.contentOffset.y < 0 {
//                newFrame.origin.y = tableView.contentOffset.y
//                newFrame.size.height = 160 + -tableView.contentOffset.y
//            }
//            topCell.frame = newFrame
//        }
        
    }
    
    
    //MARK: Trying to hide the history view when the table is scrolled
    func adjustHistoryViewBecauseScrollChanged(){
        //I think that the nav bar is 44px
        //TODO: Figure out how to get the height param out of heightConstraintForHistoryView.
        
        let yOffset = tableView.contentOffset.y
        if(yOffset < 0){
            tableView.frame.origin.y = originalY //144 //144 is the starting point
            tableView.frame.size = CGSize(width: tableView.frame.width, height: originalHeight)
        } else if yOffset < heightOfHistoryView  { //The 100.0 here is the height of the history view.  You should get this from the constraint
            tableView.frame.origin.y = originalY - tableView.contentOffset.y
            let newHeight = originalHeight + tableView.contentOffset.y
//            print(newHeight)
            tableView.frame.size = CGSize(width: tableView.frame.width, height: newHeight)
        } else {
            tableView.frame.origin.y = navBarHeight
            let newHeight = originalHeight + heightOfHistoryView
            tableView.frame.size = CGSize(width: tableView.frame.width, height: newHeight)
        }
//        print(tableView.frame)
    }
    

    //MARK: Methods for resizing cells
    private func adjustCellsBecauseScrollChanged(){
        let cells = tableView.visibleCells as! [GenreTableViewCell]
        
        //This hack handels the top row differently.  It was a hack to cover how badly it worked before.  This whole thing should be rethought.
//        if(tableView.indexPathForCell(cells[0])!.row == 0){
//            var newFrame : CGRect = CGRect(x: cells[0].frame.origin.x, y: 0, width: cells[0].frame.width, height: 160)
//
//            if tableView.contentOffset.y < 0 {
//                newFrame.origin.y = tableView.contentOffset.y
//                newFrame.size.height = 160 + -tableView.contentOffset.y
//            
//            }
//
//            cells[0].frame = newFrame
//            cells[0].cellHeight = CGFloat(newFrame.size.height)
//            
//            return;
//        }
        
        
//        if tableView.indexPathForCell(cells[0])!.row == 0 && tableView.contentOffset.y < 0 {
//            var newFrame : CGRect = CGRect(x: cells[0].frame.origin.x, y: 0, width: cells[0].frame.width, height: 160)
//            newFrame.origin.y = tableView.contentOffset.y
//            //newFrame.size.height = 160 + -tableView.contentOffset.y
//            cells[0].frame = newFrame
//            cells[0].cellHeight = CGFloat(newFrame.size.height)
//            return
//        }
        
//        tableView.beginUpdates() //Trevis! when you moved this up top, the cell got all twitchy. Hmm
        updateCells()
        
        
        
        
        if(cells.count <= 1){
            //Table is empty or has one cell. Note The below were added to handle when it's scrolled so far below the last cell that there are no visible cells.
            heightCellZero = GenreViewController.expandedHeight
            heightCellOne = GenreViewController.defaultHeight
//            tableView.endUpdates()
            return
        }
        let cellOne = cells[1]
        let distFromTop = distanceFromTop(tableView.indexPathForCell(cellOne)!)
        
        
        
        let remainder = GenreViewController.expandedHeight - distFromTop
//        print("Dist from top \(distFromTop) remainder: \(remainder)")
        
        
        if(cells.count == 0){
            heightCellZero = GenreViewController.expandedHeight
            heightCellOne = Float(tableView.frame.height) - GenreViewController.expandedHeight
        }
        
        let path = tableView.indexPathForCell(cells[0])
        if(path?.row == genreData.endIndex - 1){
            heightCellZero = GenreViewController.expandedHeight
            heightCellOne = GenreViewController.defaultHeight
//            tableView.endUpdates()
            return
        }
        
        tableView.beginUpdates()
        
        heightCellZero = distFromTop
        
//        if tableView.contentOffset.y < 0  {
//            var newFrame : CGRect = CGRect(x: cells[0].frame.origin.x, y: 0, width: cells[0].frame.width, height: 160)
//            newFrame.origin.y = tableView.contentOffset.y
//           // cells[0].frame = newFrame
//            
////            cells[0].frame.height = 
//            cells[0].frame.origin.y = tableView.contentOffset.y
////            cells[0].frame.size.height = 160 + -tableView.contentOffset.y
//            cells[0].frame.size.height = cells[1].frame.origin.y
//
//        }
        heightCellOne = GenreViewController.defaultHeight + remainder
        
        if(heightCellZero < GenreViewController.defaultHeight){
            heightCellZero = GenreViewController.defaultHeight
        }
        if(heightCellOne > GenreViewController.expandedHeight){
            heightCellOne = GenreViewController.expandedHeight
        }
        //The below situation happend when i was scrolling backwards to the top
        if(heightCellOne < GenreViewController.defaultHeight){
            heightCellOne = GenreViewController.defaultHeight
        }
        if(heightCellZero > GenreViewController.expandedHeight){
            heightCellZero = GenreViewController.expandedHeight
        }
        
        
        //This cell height garbage is just for the font size.  Maybe just calculate that and set it explicitly
        for cell in cells{
            cell.cellHeight = 80
        }
        
        cells[0].cellHeight = CGFloat(heightCellZero)
        cells[1].cellHeight = CGFloat(heightCellOne)
        
        
        
        //Remaindre below zero means that it's being pulled down.  The code below pins the cell to the top and stretches it vertically to fill the space
//        if(remainder < 0){
//            cells[0].frame.origin.y = tableView.contentOffset.y
//            cells[0].frame.size.height = CGFloat(distFromTop)
//        }
        
        
        
//            if(tableView.indexPathForCell(cells[0])!.row == 0){
//                var newFrame : CGRect = CGRect(x: cells[0].frame.origin.x, y: 0, width: cells[0].frame.width, height: 160)
//                
//                if tableView.contentOffset.y < 0 {
//                    newFrame.origin.y = tableView.contentOffset.y
//                    newFrame.size.height = 160 + -tableView.contentOffset.y
//                }
//                cells[0].frame = newFrame
//            }

        
        
//        print("zero: \(heightCellZero) one: \(heightCellOne)")
        
        tableView.endUpdates()

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        //Fixed height for fake spacer cell
        if(indexPath.row == genreData.endIndex){
            return tableView.frame.height - CGFloat(GenreViewController.expandedHeight)
        }
        
        var height : CGFloat
        if(indexPath.row == 0){
            height = CGFloat(heightCellZero)
        } else if(indexPath.row == 1){
            height = CGFloat(heightCellOne)
        } else if(growPath != nil && indexPath.row == growPath.row) {
            height = CGFloat(heightCellZero)
        } else if(growPath2 != nil && indexPath.row == growPath2.row){
            height = CGFloat(heightCellOne)
        } else {
            height = CGFloat(GenreViewController.defaultHeight)
        }
        
//        var height : CGFloat
//        
//        if(indexPath.row == 0){
//            height = CGFloat(GenreViewController.expandedHeight)
//        }
//        if(growPath2 != nil && indexPath.row == growPath2.row) {
//            height = CGFloat(GenreViewController.expandedHeight)
//        } else {
//            height = CGFloat(GenreViewController.defaultHeight)
//        }
        
//        var height : CGFloat
//        if(indexPath.row == 0){
//            height = CGFloat(GenreViewController.expandedHeight)
//        } else {
//            height = CGFloat(GenreViewController.defaultHeight)
//        }
        
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! GenreTableViewCell
//        cell.cellHeight = height
        
        
        print("Height \(indexPath.row) h:\(height)")
        return height
        
    }
    
    private func distanceFromTop(indexPath : NSIndexPath) ->Float{
        let rect = tableView.rectForRowAtIndexPath(indexPath)
        let offsetFromTop = rect.origin.y - tableView.contentOffset.y
        return Float(offsetFromTop)
    }
    
    func updateCells(){
        let cells = tableView.visibleCells// as! [MyTableViewCell]
//        var i = 0
//        for cell in cells{
//            cell.indexScreen = i++
//        }
        
        growPath = nil
        growPath2 = nil
        if(cells.count > 0) {
            growPath = tableView.indexPathForCell(cells[0])
        }
        if(cells.count > 1){
            growPath2 = tableView.indexPathForCell(cells[1])
        }
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
