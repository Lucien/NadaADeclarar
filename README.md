# Nada a Declarar
Swift Library for validation and generation of CPF and CNPJ numbers 🇧🇷.

![NadaADeclarar](https://github.com/Lucien/NadaADeclarar/assets/382357/3e7b23ad-15f9-4a05-8582-3e1a857d36ba)

# Features

- CPF validation
- CPF generation
- CNPJ validation
- CNPJ generation
- Accepts plain or masked number as input.
- CPF has information about the fiscal region and brazilian states associated.
- CNPJ shows if the number is from a company headquarters (0001 before the verification digits).

# Usage


## Validation

```swift
    do {
        let cpf = try CPF(number: "51135733961")
        cpf.isValid() // true
    } catch Parser.InputError.invalidFormat {
        print("invalid CPF format")
    }
```

## Generation

```swift
let cpf = CPF.generate()
```

# Badges

[![Swift](https://github.com/Lucien/NadaADeclarar/actions/workflows/swift.yml/badge.svg?branch=master)](https://github.com/Lucien/NadaADeclarar/actions/workflows/swift.yml) [![CodeQL](https://github.com/Lucien/NadaADeclarar/actions/workflows/codeql.yml/badge.svg)](https://github.com/Lucien/NadaADeclarar/actions/workflows/codeql.yml) [![SwiftLint](https://github.com/Lucien/NadaADeclarar/actions/workflows/swiftlint.yml/badge.svg)](https://github.com/Lucien/NadaADeclarar/actions/workflows/swiftlint.yml)
