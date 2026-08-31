# Divide Conta

Aplicativo Flutter para dividir o pagamento de uma conta em um bar, incluindo a comissão do garçom.

## O que o app faz

O usuário informa:
- **Valor total da conta** (R$)
- **Quantidade de pessoas** que vão dividir a conta
- **Porcentagem de comissão** a ser dada ao garçom

E o app calcula e exibe:
- **Comissão do garçom** → `valorTotalConta * (porcentagem / 100)`
- **Valor total a pagar** → `valorTotalConta + comissãoDoGarçom`
- **Valor por pessoa** → `valorTotalAPagar / quantidadePessoas`

## Validações

- Nenhum campo pode ficar em branco.
- A quantidade de pessoas precisa ser maior que zero (evita divisão por zero).
- O valor total precisa ser um número válido e maior que zero.
- A porcentagem precisa ser um número válido e não-negativo.

Se alguma validação falhar, o app mostra um aviso (SnackBar) e não exibe resultado.

## Requisitos

- [Flutter SDK](https://flutter.dev/docs/get-started/install) instalado (`flutter doctor` sem erros)
- Um emulador Android/iOS configurado, ou um celular físico conectado via USB com depuração ativada

## Como rodar

Este repositório contém apenas os arquivos de código-fonte (`pubspec.yaml` e `lib/main.dart`). Os arquivos de plataforma (`android/`, `ios/`, etc.) precisam ser gerados pelo próprio Flutter:

```bash
# 1. Crie o projeto base (gera android/, ios/, etc.)
flutter create divide_conta

# 2. Substitua o pubspec.yaml e o lib/main.dart gerados
#    pelos arquivos deste repositório (mesma pasta, mesmo nome)

# 3. Entre na pasta do projeto
cd divide_conta

# 4. Baixe as dependências
flutter pub get

# 5. Rode o app (com emulador aberto ou celular conectado)
flutter run
```

## Estrutura

```
divide_conta/
├── pubspec.yaml      # dependências (flutter, intl, cupertino_icons)
└── lib/
    └── main.dart     # UI + lógica de cálculo (tudo em um arquivo)
```

## Dependências principais

| Pacote | Uso |
|---|---|
| `flutter` | framework base |
| `intl` | formatação de moeda em Real (R$) |
| `cupertino_icons` | ícones padrão do Flutter |

## Tecnologia

Feito em Flutter/Dart com Material 3 (`useMaterial3: true`). Toda a interface e lógica estão em `lib/main.dart`, usando um único `StatefulWidget` (`TelaPrincipal`) com `TextEditingController`s para os três campos de entrada.