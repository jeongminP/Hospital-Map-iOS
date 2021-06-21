//
//  AppDelegate.swift
//  HospitalMap
//
//  Created by 박정민 on 2021/06/10.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        
        copyDatabaseIfNeeded()
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

func copyDatabaseIfNeeded() {
    // Move database file from bundle to documents folder
    
    let fileManager = FileManager.default
    let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    
    guard documentsUrl.count != 0 else {
        return // Could not find documents URL
    }
    
    let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("hdb.db")
    
    if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
        print("DB does not exist in documents folder")
        
        let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("hdb.db")
        
        do {
            try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
            print("디비 옮기기 성공")
        } catch let error as NSError {
            print("Couldn't copy file to final location! Error:\(error.description)")
        }
        
    } else {
        print("Database file found at path: \(finalDatabaseURL.path)")
    }
    
}
