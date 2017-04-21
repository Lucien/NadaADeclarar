import Foundation

extension String {

    func removingCharacters(fromSet charactersToBeSkipped: CharacterSet) -> String {

        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = charactersToBeSkipped

        var complete: String = ""
        var part: NSString?
        while scanner.scanUpToCharacters(from: charactersToBeSkipped,
                                         into: &part) {
                                            if let part = part {
                                                complete.append(part as String)
                                            }
        }
        return complete
    }

    enum CPFInputFormat {
        case invalid
        case plain
        case masked
    }
}
