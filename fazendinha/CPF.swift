import Foundation

public struct CPF: FazendinhaNumberProtocol, Generatable {
    public typealias T = CPF

    public let plainNumber: String
    public let maskedNumber: String
    public let checkDigits: [Int]
    public static var checkDigitsCount: Int = 2
    public static var numberLength: Int = 11
    let validator: Validator
    let parser = Parser()

    /**
     Creates a CPF from a given number
     - Parameter number: CPF number
     - Throws: `InputError.invalidFormat` if the string is not either just numbers (E.g.: XXXXXXXXXXX) or number with
     the CPF mask. (E.g.: XXX.XXX.XXX-XX)
     - Returns: CPF

     */
    public init(number: String) throws {

        let numberParsedInfo = try parser.parse(number: number,
                                                separators: [".", ".", "-"],
                                                steps: [3, 3, 3, 2])

        self.plainNumber = numberParsedInfo.plainNumber
        self.maskedNumber = numberParsedInfo.maskedNumber
        self.checkDigits = numberParsedInfo.checkDigits
        self.validator = Validator(numberParsedInfo: numberParsedInfo)
    }

    public var states: [State] {
        
        return 🇧🇷.states.filter { (state: State) -> Bool in
            return state.fiscalRegion == fiscalRegion
        }
    }

    static let fazendaAlgorythm = Validator.ValidationAlgorythm.fazenda { (basicNumber: String) -> (Int) in
        return T.calcWeightSum(basicNumber: basicNumber)
    }

    public func isValid(validationAlgorythm: Validator.ValidationAlgorythm = CPF.fazendaAlgorythm,
                        allSameDigitsAreValid: Bool = false) -> Bool {

        return validator.isValid(validationAlgorythm: validationAlgorythm,
                                 allSameDigitsAreValid: allSameDigitsAreValid)
    }

//    public static func generate(weightsSumCalc: (String) -> (Int)) -> T {
//        generate(weightsSumCalc: <#T##(String) -> (Int)#>)
//    }

    static func calcWeightSum(basicNumber: String) -> Int {

        var sum = 0
        let range = Range(uncheckedBounds: (basicNumber.startIndex, upper: basicNumber.endIndex))

        let initialWeight = basicNumber.characters.count + 1

        basicNumber.enumerateSubstrings(in: range,
                                        options: [.byComposedCharacterSequences]) {
                                            (enumeratedString: String?,
                                            substringRange: Range<String.Index>,
                                            enclosingRange: Range<String.Index>,
                                            stop: inout Bool) in

                                            let info = getNumberAndIndex(fromEnumeratedString: enumeratedString,
                                                                         substringRange: substringRange,
                                                                         basicNumber: basicNumber)

                                            let weight = (initialWeight - info.index)
                                            sum += info.number * weight
        }

        return sum
    }

    public var fiscalRegion: FiscalRegion {

        let frRange = Range(uncheckedBounds: (plainNumber.index(plainNumber.endIndex, offsetBy: -3),
                                              plainNumber.index(plainNumber.endIndex, offsetBy: -2)))
        let fiscalRegion = FiscalRegion(rawValue: Int(plainNumber.substring(with: frRange))!)!
        return fiscalRegion
    }
}

