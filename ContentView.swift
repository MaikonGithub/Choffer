//
//  ContentView.swift
//  Choffer
//
//  Created by Maikon Ferreira on 30/09/25.
//

import SwiftUI

/// View principal do aplicativo
/// Gerencia o estado de autenticação seguindo as guidelines da Apple
struct ContentView: View {
    
    // MARK: - State Objects
    
    /// Serviço de autenticação
    @StateObject private var authService = AuthenticationService()
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            if authService.isAuthenticated {
                // Usuário autenticado - mostrar tela principal
                MainScreenView()
            } else {
                // Usuário não autenticado - mostrar tela de login
                LoginView()
            }
        }
        .environmentObject(authService)
    }
}

// MARK: - Main Screen View

/// View da tela principal do aplicativo
struct MainScreenView: View {
    
    // MARK: - State Objects
    
    /// Serviço de autenticação
    @EnvironmentObject var authService: AuthenticationService
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Bem-vindo ao Choffer!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let user = authService.currentUser {
                    Text("Olá, \(user.fullName)")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 40)
            
            Spacer()
            
            // Conteúdo principal
            VStack(spacing: 16) {
                Image(systemName: "car.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Seu aplicativo de mobilidade urbana")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Botão de logout
            Button(action: {
                Task {
                    await authService.signOut()
                }
            }) {
                HStack {
                    Image(systemName: "power")
                    Text("Sair")
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
            }
            .padding(.bottom, 40)
        }
        .padding()
        .navigationTitle("Choffer")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
