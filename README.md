# fazendinha
Swift Library for validation and generation of CPF and CNPJ numbers.

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
