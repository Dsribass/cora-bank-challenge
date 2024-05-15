import Foundation
import Combine

public final class ValidateCpf {
  public struct Request {
    public init(cpf: String) {
      self.cpf = cpf
    }

    public let cpf: String
  }

  public init() {}

  public func execute(_ req: Request) -> Future<(), ValidationError> {
    Future { promise in
      if req.cpf.isEmpty { return promise(.failure(.empty)) }

      let numbers = req.cpf.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
      guard numbers.count == 11 else { return promise(.failure(.invalid)) }

      let set = NSCountedSet(array: Array(numbers))
      guard set.count != 1 else { return promise(.failure(.invalid)) }

      let i1 = numbers.index(numbers.startIndex, offsetBy: 9)
      let i2 = numbers.index(numbers.startIndex, offsetBy: 10)
      let i3 = numbers.index(numbers.startIndex, offsetBy: 11)
      let d1 = Int(numbers[i1..<i2])
      let d2 = Int(numbers[i2..<i3])

      var temp1 = 0, temp2 = 0

      for i in 0...8 {
        let start = numbers.index(numbers.startIndex, offsetBy: i)
        let end = numbers.index(numbers.startIndex, offsetBy: i+1)
        let char = Int(numbers[start..<end])

        temp1 += char! * (10 - i)
        temp2 += char! * (11 - i)
      }

      temp1 %= 11
      temp1 = temp1 < 2 ? 0 : 11-temp1

      temp2 += temp1 * 2
      temp2 %= 11
      temp2 = temp2 < 2 ? 0 : 11-temp2

      return temp1 == d1 && temp2 == d2 ?
      promise(.success(())) :
      promise(.failure(.invalid))
    }
  }
}
