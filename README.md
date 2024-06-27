# Nothing to Declare
Swift Library for validation and generation of CPF and CNPJ numbers.

# Features

- CPF and CNPJ validation and generation
- Accepts plain or masked number as input.
- CPF has information about the fiscal region and brazilian states associated.
- CNPJ shows if the number is from a company headquarters (0001 before the verification digits).

# Usage


## Validation

```swift
let cpf = try! CPF(number: "51135733961") // number can also be in the format XXX.XXX.XXX-XX
cpf.isValid() // true
```

## Generation

```
let cpf = CPF.generate()
```

Check out more on [Playgrounds](README.playground)
