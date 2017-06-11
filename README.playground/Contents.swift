import fazendinha

// CPF
let cpf = try! CPF(number: "51135733961")

cpf.isValid()

cpf.fiscalRegion
cpf.states

cpf.plainNumber
cpf.maskedNumber
CPF.numberLength

let newCPF = CPF.generate()
newCPF.maskedNumber

// CNPJ
let cnpj = try! CNPJ(number: "26.660.727/0001-99")

cnpj.isValid()

cnpj.branchNumber
cnpj.isHeadquarters

cnpj.plainNumber
cnpj.maskedNumber
CNPJ.numberLength

let newCNPJ = CNPJ.generate()
newCNPJ.maskedNumber
