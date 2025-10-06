//
//  ChofferApp.swift
//  Choffer
//
//  Created by Maikon Ferreira on 30/09/25.
//

import SwiftUI
import FirebaseCore

/// AppDelegate para configuração do Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configurar Firebase
        FirebaseApp.configure()
        print("🔥 Firebase configurado com sucesso!")
        return true
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
