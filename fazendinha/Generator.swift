import Foundation

public protocol Generatable {
    associatedtype T: FazendinhaNumberProtocol
    static func generate() -> T
}

extension Generatable {

    public static func generate(weightsSumCalc: (String) -> (Int)) -> T {

        let basicNumber = generateBasicNumber()

        let checkDigits = Validator.expectedCheckDigits(fromBasicNumber: basicNumber,
                                                        checkDigitsCount: T.checkDigitsCount,
                                                        calculateWeightsSum: weightsSumCalc)

        var number = basicNumber
        for checkDigit in checkDigits {
            number.append(String(checkDigit))
        }

        do {
            let fazendinhaType = try T(number: number)
            return fazendinhaType
        } catch {
            fatalError("Could not create CPF from number: \(number)")
        }
    }

    static func generateBasicNumber() -> String {
        let basicNumberLength = T.numberLength - T.checkDigitsCount
        var randomNumber = ""
        for _ in 0 ..< basicNumberLength {
            randomNumber += String(arc4random() % 10)
        }
        
        return randomNumber
    }
}
