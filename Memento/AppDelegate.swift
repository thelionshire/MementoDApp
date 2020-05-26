//
//  AppDelegate.swift
//  Memento
//
//  Created by Russ (thelionshire) on 5/25/20.
//  Copyright © 2020 Ubik Capital. All rights reserved.
//

import UIKit
import ICONKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
           let url = NSURL(fileURLWithPath: path)
           if let pathComponent = url.appendingPathComponent("iconkeystore") {
             let filePath = pathComponent.path
             let fileManager = FileManager.default
             if fileManager.fileExists(atPath: filePath) {
               print("FILE AVAILABLE, KEYSTORE EXISTS")
               let iconService = IconServices.shared
             } else {
               print("FILE NOT AVAILABLE, KEYSTORE DOES NOT EXIST. CREATING NEW KEYSTORE WITH PASSWORD iconpassword")
               let wallet = Wallet(privateKey: nil)
               do {
                 try wallet.generateKeystore(password: "iconpassword")
                 try wallet.save(filepath: pathComponent)
                 let iconService = IconServices.shared
               } catch {
                 // handle errors
             }
             } }else {
             print("FILE PATH NOT AVAILABLE")
           }
        
        return true
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

