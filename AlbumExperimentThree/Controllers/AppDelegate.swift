//
//  AppDelegate.swift
//  AlbumExperimentThree
//
//  Created by Trevis Thomas on 10/23/15.
//  Copyright © 2015 Trevis Thomas. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    private let savedDataKey : String = "savedDataKey"
    
    private static var savedData : SavedData!

    static func getSavedData() -> SavedData{
        return savedData
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        //Unarchive savedData
//        if let data = NSUserDefaults.standardUserDefaults().objectForKey(savedDataKey) as? NSData {
//            AppDelegate.savedData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! SavedData
//        } else {
//            //This should only happen if the data doesnt exist. Note:  The savedData class has a failsafe internaly that should handle creating a new object even if it failes to load the file.
//            AppDelegate.savedData = SavedData()
//        }
        
        
        
        loadMusicPlayerState()
        
      
        //Without this, it didnt play at all for me.
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print("Caught exception trying to set playback category in App Delegate")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
//         _ = try? AVAudioSession.sharedInstance().setActive(true, withOptions: []) 
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        saveApplicationState()
        
    }
    
    /*
        Call this to save your data now!
    */
    func saveApplicationState(){
        AppDelegate.getSavedData().saveState(MusicPlayer.instance)
    }
    
    func loadMusicPlayerState(){
        AppDelegate.savedData = SavedData.loadOrCreateSavedDataInstance()
        
        //Trevis: You might want to make a special method that can load the queue and play at an index.  The 'queue' method loads and starts playing.  The playItemAtIndex removes all items from the AVPlayer and re-adds them starting at the index.
        MusicPlayer.instance.queue(MusicLibrary.instance.queryMediaItemsByPersistenceIDs(AppDelegate.getSavedData().nowPlayingQueue))
        if AppDelegate.getSavedData().nowPlayingIndex > 0 {
            MusicPlayer.instance.playItemAtIndex(AppDelegate.getSavedData().nowPlayingIndex)
        }
        
        MusicPlayer.instance.skipToPosition(AppDelegate.savedData.playbackPosition)
        
        MusicPlayer.instance.pause() //Comming back paused seems classier
    }
    

}

