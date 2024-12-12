//
//  Password_ManagerApp.swift
//  Password Manager
//
//  Created by Kishore Shiva Saravanan on 08/12/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

// AppDelegate for Firebase setup
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Firebase cofiguration success!")
        return true
    }
}

@main
struct Password_ManagerApp: App {
    // Register AppDelegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            LoginPage()
        }
    }
}
