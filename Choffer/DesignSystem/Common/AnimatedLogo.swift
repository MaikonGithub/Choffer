import SwiftUI

struct AnimatedLogo: View {
    // MARK: - Properties
    let height: CGFloat
    let showText: Bool
    let text: String
    let textSize: CGFloat
    let textSpacing: CGFloat
    let letterDelay: Double
    
    // MARK: - State
    @State private var logoScale: CGFloat = 1.0
    @State private var logoRotation: Double = 0.0
    @State private var textAnimationStarted: Bool = false
    
    // MARK: - Initialization
    init(
        height: CGFloat = 100,
        showText: Bool = false,
        text: String = "",
        textSize: CGFloat = 32,
        textSpacing: CGFloat = 2,
        letterDelay: Double = 0.3
    ) {
        self.height = height
        self.showText = showText
        self.text = text
        self.textSize = textSize
        self.textSpacing = textSpacing
        self.letterDelay = letterDelay
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Logo animada
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: height)
                .scaleEffect(logoScale)
                .rotationEffect(.degrees(logoRotation))
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true)
                    ) {
                        logoScale = 1.25
                        logoRotation = 8.0
                    }
                }
            
            // Texto animado (opcional)
            if showText && !text.isEmpty {
                HStack(spacing: textSpacing) {
                    ForEach(Array(text).indices, id: \.self) { index in
                        Text(String(Array(text)[index]))
                            .font(.custom("Avenir-Black", size: textSize))
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .tracking(2)
                            .opacity(letterOpacity(for: index))
                            .scaleEffect(letterScale(for: index))
                            .animation(
                                Animation.easeInOut(duration: 0.5)
                                    .delay(Double(index) * letterDelay),
                                value: letterOpacity(for: index)
                            )
                    }
                }
            }
        }
        .onAppear {
            if showText {
                // Iniciar animação do texto após um pequeno delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        textAnimationStarted = true
                    }
                }
            }
        }
    }
    
    private func letterOpacity(for index: Int) -> Double {
        guard textAnimationStarted else { return 0.0 }
        return 1.0
    }
    
    private func letterScale(for index: Int) -> CGFloat {
        guard textAnimationStarted else { return 0.8 }
        return 1.0
    }
}

#Preview {
    VStack(spacing: 40) {
        // Logo simples
        AnimatedLogo(height: 80)
        
        // Logo com texto CHOFFER
        AnimatedLogo(
            height: 100,
            showText: true,
            text: "CHOFFER",
            textSize: 32,
            letterDelay: 0.3
        )
        
        // Logo com texto CRIAR CONTA
        AnimatedLogo(
            height: 80,
            showText: true,
            text: "CRIAR CONTA",
            textSize: 28,
            letterDelay: 0.2
        )
        
        // Logo com texto VERIFICAÇÃO
        AnimatedLogo(
            height: 70,
            showText: true,
            text: "VERIFICAÇÃO",
            textSize: 26,
            letterDelay: 0.2
        )
    }
    .padding()
} 