import Foundation

public struct CNPJ: FazendinhaNumberProtocol, Generatable, NumberParsedInfoInterface {

    public typealias T = CNPJ
    public typealias F = CNPJ

    public static let checkDigitsCount = 2
    public static let numberLength = 14
    public let isHeadquarters: Bool
    static let weights = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, checkDigitsCount]
    let validator: Validator
    let parser = Parser()
    let numberParsedInfo: Parser.Info

    public init(number: String) throws {

        self.numberParsedInfo = try parser.parse(number: number,
                                                separators: [".", ".", "/", "-"],
                                                steps: [2, 3, 3, 4, 2])

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
