[![Build Status](https://travis-ci.org/Lucien/fazendinha.svg?branch=master)](https://travis-ci.org/Lucien/fazendinha)

# fazendinha
Swift Library for validation and generation of CPF and CNPJ numbers.

# Features

- CPF and CNPJ validation and generation
- Accepts number as string with or without separators.
- CPF has information about the fiscal region and Brazilian States associated.
- CNPJ shows if the number is from a company headquarters (0001 before the verification digits).

# Usage

## Basic

### Validation

```swift
let cpf = try! CPF(number: "51135733961") // number can also be in the format XXX.XXX.XXX-XX
cpf.isValid() // true
```

### Generation

```
let cpf = CPF.generate()
```

## Detailed

![image](https://image.ibb.co/eOBROF/Screen_Shot_2017_06_04_at_18_13_37.png)
