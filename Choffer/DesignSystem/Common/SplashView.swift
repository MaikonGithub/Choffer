//
//  SplashView.swift
//  Choffer
//
//  Created by Maikon Ferreira on 25/07/25.
//

import SwiftUI

// MARK: - App Version Helper

/// Helper para obter informações da versão do app
struct AppVersion {
    
    /// Retorna a versão de exibição formatada
    static var displayVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "v\(version) (\(build))"
    }
    
    /// Retorna apenas o número da versão
    static var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    /// Retorna apenas o número do build
    static var build: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}

struct SplashView: View {
    // MARK: - State
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0
    @State private var textOpacity: Double = 0.0
    @State private var versionOpacity: Double = 0.0
    
    var body: some View {
        ZStack {
            // Background adaptativo que segue o tema do sistema
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Logo animada (similar ao AnimatedLogo mas mais sutil)
                VStack(spacing: 20) {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .onAppear {
                            // Animação de entrada da logo
                            withAnimation(.easeOut(duration: 1.0)) {
                                logoScale = 1.0
                                logoOpacity = 1.0
                            }
                            
                            // Animação sutil contínua (menos intensa que no login)
                            withAnimation(
                                Animation.easeInOut(duration: 3.0)
                                    .repeatForever(autoreverses: true)
                            ) {
                                logoScale = 1.05
                            }
                        }
                    
                    // Texto "CHOFFER" com animação sequencial
                    HStack(spacing: 2) {
                        ForEach(Array("CHOFFER").indices, id: \.self) { index in
                            Text(String(Array("CHOFFER")[index]))
                                .font(.custom("Avenir-Black", size: 28))
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                                .tracking(2)
                                .opacity(textOpacity)
                                .scaleEffect(textOpacity > 0 ? 1.0 : 0.8)
                                .animation(
                                    Animation.easeInOut(duration: 0.4)
                                        .delay(Double(index) * 0.1),
                                    value: textOpacity
                                )
                        }
                    }
                    .onAppear {
                        // Iniciar animação do texto após a logo aparecer
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                textOpacity = 1.0
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Versão do app
                Text(AppVersion.displayVersion)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .opacity(versionOpacity)
                    .onAppear {
                        // Mostrar versão por último
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                versionOpacity = 1.0
                            }
                        }
                    }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview("Light Mode") {
    SplashView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    SplashView()
        .preferredColorScheme(.dark)
} 