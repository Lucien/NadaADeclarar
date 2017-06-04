import Foundation
import fazendinha

protocol ListImporter {}

extension ListImporter {

    static func generatedNumberList<T>() -> Set<T> where T: FazendinhaNumberProtocol {

        let bundle = Bundle(for: CPFTests.self)

        let resource = "Generated\(String(describing: T.self))List"
        let path = bundle.path(forResource: resource, ofType: "txt")
        let generatedCPFs = try! String(contentsOfFile: path!)
        let stringList = generatedCPFs.components(separatedBy: CharacterSet.newlines).dropLast()

        let list = stringList.map { (docString: String) -> T in
            return try! T(number: docString)
        }
        return Set(list.map{ $0 })
    }
}
