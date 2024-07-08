# Nada a Declarar
Swift Library for validation and generation of CPF and CNPJ numbers 🇧🇷.

![Nada a Declarar](https://github.com/Lucien/NadaADeclarar/assets/382357/d143b5f1-6fcb-4b97-beb7-cc296adc91bb)

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

[![Swift](https://github.com/Lucien/NadaADeclarar/actions/workflows/swift.yml/badge.svg?branch=master)](https://github.com/Lucien/NadaADeclarar/actions/workflows/swift.yml) [![CodeQL](https://github.com/Lucien/NadaADeclarar/actions/workflows/codeql.yml/badge.svg)](https://github.com/Lucien/NadaADeclarar/actions/workflows/codeql.yml)

# Memes
![](https://static.poder360.com.br/2024/03/prismada-irpf-memes-1-15mar2024.png)
![](https://static.poder360.com.br/2024/03/prismada-irpf-memes-3-15mar2024.png)
![](https://i.pinimg.com/736x/ce/fd/57/cefd57f6b5e2ac84db7496e3f4c031e2.jpg)
