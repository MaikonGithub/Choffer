//
//  ChofferApp.swift
//  Choffer
//
//  Created by Maikon Ferreira on 30/09/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

/// AppDelegate para configuração do Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configurar Firebase
        FirebaseApp.configure()
        
        // IMPORTANTE: Desabilitar verificação automática de app para usar reCAPTCHA no Simulator
        // Isso permite usar números de teste sem precisar de Push Notifications
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        return true
    }
    
    // MARK: - Remote Notifications (Necessário para Firebase Phone Auth)
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Encaminhar notificações para FirebaseAuth
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        completionHandler(.noData)
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Firebase pode precisar desse token
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Normal no Simulator - Firebase usa reCAPTCHA como fallback
    }
}

@main
struct ChofferApp: App {
    // MARK: - Properties
    
    /// AppDelegate para configuração do Firebase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
