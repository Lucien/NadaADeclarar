import Foundation
@testable import NadaADeclarar

protocol ListImporter {}

extension ListImporter {

    static func generatedNumberList<T>() -> Set<T> where T: NadaADeclararNumberProtocol {

        let resource = "Generated\(String(describing: T.self))List"
        let path = Bundle.module.path(forResource: resource, ofType: "txt")

        let generatedCPFs = try! String(contentsOfFile: path!)
        let stringList = generatedCPFs.components(separatedBy: CharacterSet.newlines).dropLast()

        let list = stringList.map { (docString: String) -> T in
            return try! T(number: docString)
        }
        return Set(list.map{ $0 })
    }
}
