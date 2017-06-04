import Foundation

public struct CNPJ: FazendinhaNumberProtocol, Generatable {

    public typealias T = CNPJ

    public let plainNumber: String
    public let maskedNumber: String
    public let checkDigits: [Int]
    public let isHeadquarters: Bool
    let validator: Validator
    let parser = Parser()
    public static let checkDigitsCount = 2
    public static let numberLength = 14
    static let weights = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

    public init(number: String) throws {

        let numberParsedInfo = try parser.parse(number: number,
                                                separators: [".", ".", "/", "-"],
                                                steps: [2, 3, 3, 4, 2])

        self.plainNumber = numberParsedInfo.plainNumber
        self.maskedNumber = numberParsedInfo.maskedNumber
        self.checkDigits = numberParsedInfo.checkDigits
        self.validator = Validator(numberParsedInfo: numberParsedInfo)

        let partsCount = numberParsedInfo.parts.count
        if partsCount > 1 {
            let companyNumber = numberParsedInfo.parts[partsCount - 2]
            self.isHeadquarters = companyNumber == "0001"
        } else {
            self.isHeadquarters = false
        }
    }

    public func isValid(allSameDigitsAreValid: Bool = false) -> Bool {

        let algorythm = Validator.ValidationAlgorythm.fazenda { (basicNumber: String) -> (Int) in
            return T.calcWeightSum(basicNumber: basicNumber)
        }

        return validator.isValid(validationAlgorythm: algorythm,
                                 allSameDigitsAreValid: allSameDigitsAreValid)
    }

    public static func generate() -> CNPJ {

        let cnpj = CNPJ.generate { (string: String) -> (Int) in
            return CNPJ.calcWeightSum(basicNumber: string)
        }
        return cnpj

    }
}
