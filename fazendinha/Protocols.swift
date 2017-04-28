import Foundation

public enum InputError: Error {
    case invalidFormat
}

public enum ValidationAlgorythm {
    case simple
    case fazenda(weightSumCalculation: (String) -> (Int))
}

public protocol FazendinhaNumberProtocol {

    init(number: String) throws

    var checkDigits: [Int] { get }
    var plainNumber: String { get }
    var maskedNumber: String { get }
    static var checkDigitsCount: Int { get }
    static var numberLength: Int { get }

    static func generate() -> Self
}

extension FazendinhaNumberProtocol {


    public static func generate() -> Self {

        let basicNumber = generateBasicNumber()
        let checkDigits = expectedCheckDigits(fromBasicNumber: basicNumber)

        var number = basicNumber
        for checkDigit in checkDigits {
            number.append(String(checkDigit))
        }

        do {
            let fazendinhaType = try Self(number: number)
            return fazendinhaType
        } catch {
            fatalError("Could not create CPF from number: \(number)")
        }
    }

    static func generateBasicNumber() -> String {
        let basicNumberLength = numberLength - checkDigitsCount
        var randomNumber = ""
        for _ in 0 ..< basicNumberLength {
            randomNumber += String(arc4random() % 10)
        }

        return randomNumber
    }

    static func expectedCheckDigits(fromBasicNumber basicNumber: String) -> [Int] {

        let moduloNumber = 11
        var expectedCheckDigits = [Int]()
        var nextBasicNumber = basicNumber

        for i in 0..<checkDigitsCount {

            let sum = calcWeightSum(basicNumber: nextBasicNumber)
            let remainder = sum % moduloNumber
            let v = (remainder == 1 || remainder == 0) ? 0 : moduloNumber - remainder
            nextBasicNumber.append(String(v))
            expectedCheckDigits.insert(v, at: i)
        }
        return expectedCheckDigits
    }

    static func getNumberAndIndex(fromEnumeratedString enumeratedString: String?,
                           substringRange: Range<String.Index>,
                           basicNumber: String) -> (number: Int, index: Int) {

        let number = Int(enumeratedString!)!
        let index: Int = basicNumber.distance(from: basicNumber.startIndex,
                                              to: substringRange.lowerBound)
        return (number, index)
    }

//    func calculateWeightsSum(basicNumber: String) -> Int { return 0 }
    static func calcWeightSum(basicNumber: String) -> Int { return 0 }
}
