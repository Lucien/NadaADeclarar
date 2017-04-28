//: Playground - noun: a place where people can play

import Foundation
import UIKit
import fazendinha

do {
    let cpf = try CPF(number: "33474927817")
    print(cpf.plainNumber)
} catch let error {
    print(error)
}


