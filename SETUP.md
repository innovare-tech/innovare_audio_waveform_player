# Setup Instructions

Este documento contém instruções completas para configurar e publicar o pacote `innovare_audio_waveform_player`.

## Estrutura do Projeto

```
innovare_audio_waveform_player/
├── lib/
│   ├── innovare_audio_waveform_player.dart     # Arquivo principal da biblioteca
│   └── src/
│       └── innovare_audio_waveform_player.dart # Implementação do widget
├── test/
│   └── innovare_audio_waveform_player_test.dart # Testes unitários
├── example/
│   ├── lib/
│   │   └── main.dart                           # App de exemplo
│   └── pubspec.yaml                            # Dependências do exemplo
├── .github/
│   └── workflows/
│       └── ci.yml                              # GitHub Actions CI/CD
├── scripts/
│   └── prepare_publish.sh                      # Script de preparação
├── pubspec.yaml                                # Configuração do pacote
├── README.md                                   # Documentação principal
├── CHANGELOG.md                                # Log de mudanças
├── LICENSE                                     # Licença MIT
├── analysis_options.yaml                       # Configuração do linter
└── .gitignore                                  # Arquivos ignorados pelo Git
```

## Pré-requisitos

1. **Flutter SDK**: Versão 3.10.0 ou superior
2. **Dart SDK**: Versão 3.0.0 ou superior
3. **Git**: Para controle de versão
4. **Conta no pub.dev**: Para publicação do pacote

## Configuração Inicial

### 1. Criar Repositório no GitHub

```bash
# Criar repositório no GitHub com o nome: innovare_audio_waveform_player
# Depois fazer clone local
git clone https://github.com/yourusername/innovare_audio_waveform_player.git
cd innovare_audio_waveform_player
```

### 2. Adicionar Arquivos do Projeto

Copie todos os arquivos fornecidos para as pastas correspondentes mantendo a estrutura de diretórios.

### 3. Instalar Dependências

```bash
flutter pub get
cd example
flutter pub get
cd ..
```

### 4. Executar Testes

```bash
flutter test
```

### 5. Executar Exemplo

```bash
cd example
flutter run -d chrome  # Para web
# ou
flutter run             # Para dispositivo/emulador
```

## Configuração do GitHub Actions Customizado

### 1. Workflow Abrangente Implementado

O projeto inclui um workflow customizado e robusto que implementa:

**🔍 Análise de Qualidade**
- Formatação, linting, auditoria de segurança
- Validação de estrutura e documentação
- Verificação de dependências

**🧪 Testes Abrangentes**
- Testes unitários com coverage mínimo (80%)
- Validação do app de exemplo
- Upload para Codecov

**🏗️ Builds Multi-Plataforma**
- Web, Android, Linux
- Verificação de artefatos
- Análise de performance

**🚀 Publicação Automatizada OIDC**
- Segue tutorial oficial do pub.dev
- Validação de versões e changelog
- Environment-based security

### 2. Configuração do Environment GitHub

1. **No GitHub, vá em Settings > Environments**
2. **Crie environment**: `pub-dev`
3. **Configure proteções** (opcional):
    - Required reviewers
    - Deployment branches: `v*`

### 3. Configurar pub.dev (Após primeira publicação)

1. **Primeira publicação manual:**
```bash
dart pub publish
```

2. **Configure automated publishing:**
    - Acesse: https://pub.dev/packages/innovare_audio_waveform_player/admin
    - **Repository**: `yourusername/innovare_audio_waveform_player`
    - **Environment**: `pub-dev`
    - **Tag pattern**: `v{{version}}`

### 4. Secrets Opcionais

- `CODECOV_TOKEN` (coverage reports)
- `GITHUB_TOKEN` (criado automaticamente)

### 3. Configurar Branch Protection

No GitHub, configure branch protection para `main`:
- Require status checks to pass before merging
- Require branches to be up to date before merging
- Include administrators

## Preparação para Publicação

### 1. Executar Script de Preparação

```bash
chmod +x scripts/prepare_publish.sh
./scripts/prepare_publish.sh
```

### 2. Verificar Informações do Pacote

Edite `pubspec.yaml` para incluir suas informações:

```yaml
homepage: https://github.com/seuusuario/innovare_audio_waveform_player
repository: https://github.com/seuusuario/innovare_audio_waveform_player
issue_tracker: https://github.com/seuusuario/innovare_audio_waveform_player/issues
```

### 3. Atualizar Documentação

- Atualize README.md com URLs corretas
- Verifique se todos os links estão funcionando
- Adicione screenshots ou GIFs se disponível

## Publicação Manual

### 1. Publicação de Teste

```bash
dart pub publish --dry-run
```

### 2. Publicação Real

```bash
dart pub publish
```

## Publicação Automática via GitHub Actions

### 1. Commit e Push

```bash
git add .
git commit -m "feat: initial release"
git push origin main
```

### 2. Criar Tag de Versão

```bash
git tag v1.0.0
git push origin v1.0.0
```

### 3. Verificar Build

- Acesse Actions tab no GitHub
- Verifique se todos os jobs passaram
- A publicação acontece automaticamente se estiver na branch `main`

## Desenvolvimento Contínuo

### 1. Workflow de Desenvolvimento

```bash
# Criar branch para nova feature
git checkout -b feature/nova-funcionalidade

# Fazer mudanças
# Executar testes
flutter test

# Commit e push
git add .
git commit -m "feat: adicionar nova funcionalidade"
git push origin feature/nova-funcionalidade

# Criar Pull Request no GitHub
```

### 2. Atualização de Versão

```bash
# Atualizar version no pubspec.yaml
# Atualizar CHANGELOG.md
# Fazer commit
git add .
git commit -m "chore: bump version to 1.1.0"

# Criar tag
git tag v1.1.0
git push origin main --tags
```

## Verificação de Qualidade

### 1. Análise Estática

```bash
dart analyze --fatal-infos
```

### 2. Formatação

```bash
dart format .
```

### 3. Testes com Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Troubleshooting

### Problema: Erro de Dependências

```bash
flutter clean
flutter pub get
```

### Problema: Falha nos Testes

```bash
# Executar testes com verbose
flutter test --reporter=expanded
```

### Problema: Falha na Publicação

```bash
# Verificar se está logado
dart pub logout
dart pub login

# Verificar configuração
dart pub publish --dry-run
```

## Manutenção

### 1. Atualizações Regulares

- Manter dependências atualizadas
- Responder issues no GitHub
- Revisar e mergear Pull Requests
- Atualizar documentação

### 2. Monitoramento

- Verificar métricas no pub.dev
- Acompanhar downloads e likes
- Responder feedback da comunidade

### 3. Suporte a Plataformas

- Testar em diferentes plataformas
- Manter compatibilidade com Flutter updates
- Adicionar novas funcionalidades baseadas em feedback

## Recursos Úteis

- [Pub.dev Publishing Guide](https://dart.dev/tools/pub/publishing)
- [Flutter Package Development](https://docs.flutter.dev/development/packages-and-plugins/developing-packages)
- [GitHub Actions for Flutter](https://docs.github.com/en/actions/learn-github-actions)
- [Dart Analysis Options](https://dart.dev/guides/language/analysis-options)