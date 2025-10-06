# Choffer

Um aplicativo iOS moderno para delivery e serviços de alimentação, desenvolvido em SwiftUI com arquitetura MVVM e integração Firebase.

## 🚀 Tecnologias

- **SwiftUI** - Interface de usuário moderna
- **Firebase** - Backend e autenticação
- **MVVM Architecture** - Arquitetura limpa e testável
- **Swift Package Manager** - Gerenciamento de dependências

## 📱 Funcionalidades

### Autenticação
- ✅ Registro de usuário
- ✅ Verificação por telefone
- ✅ Login seguro
- ✅ Recuperação de senha

### Onboarding
- ✅ Seleção de perfil (Cliente/Estabelecimento)
- ✅ Configuração inicial

### Design System
- ✅ Componentes reutilizáveis
- ✅ Botões customizados
- ✅ Campos de entrada
- ✅ Mensagens de erro/sucesso
- ✅ Logo animado

## 🏗️ Estrutura do Projeto

```
Choffer/
├── Core/
│   ├── Features/
│   │   ├── Auth/
│   │   │   ├── Login/
│   │   │   └── Registration/
│   │   └── Onboarding/
│   │       └── ProfileSelection/
│   ├── Models/
│   │   └── User.swift
│   └── Services/
│       └── AuthenticationService.swift
├── DesignSystem/
│   ├── Authentication/
│   └── Common/
├── Utils/
│   └── FormattingUtils.swift
└── Assets.xcassets/
```

## 🛠️ Configuração

### Pré-requisitos
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/MaikonGithub/Choffer.git
```

2. Abra o projeto no Xcode:
```bash
cd Choffer
open Choffer.xcodeproj
```

3. Configure o Firebase:
   - Adicione seu `GoogleService-Info.plist` na pasta `Choffer/`
   - Configure as regras do Firebase Authentication

4. Execute o projeto:
   - Selecione um simulador iOS
   - Pressione `Cmd + R`

## 📋 Funcionalidades em Desenvolvimento

- [ ] Sistema de pedidos
- [ ] Catálogo de produtos
- [ ] Carrinho de compras
- [ ] Pagamentos
- [ ] Notificações push
- [ ] Avaliações e reviews

## 🎨 Design System

O projeto utiliza um sistema de design consistente com componentes reutilizáveis:

- **OnboardingButton** - Botões principais do onboarding
- **OnboardingLinkButton** - Botões de link secundários
- **OnboardingTextField** - Campos de entrada customizados
- **VerificationCodeField** - Campo para códigos de verificação
- **ErrorMessageView** - Exibição de erros
- **SuccessMessageView** - Exibição de sucessos
- **AnimatedLogo** - Logo com animação

## 🔧 Desenvolvimento

### Arquitetura
- **MVVM** - Separação clara de responsabilidades
- **Services** - Lógica de negócio isolada
- **Models** - Estruturas de dados
- **Views** - Interface do usuário

### Convenções
- Português para conteúdo do usuário
- Inglês para documentação técnica
- Nomenclatura clara e consistente

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👨‍💻 Desenvolvedor

**Maikon Ferreira**
- GitHub: [@MaikonGithub](https://github.com/MaikonGithub)

## 📞 Contato

Para dúvidas ou sugestões, entre em contato através do GitHub Issues.