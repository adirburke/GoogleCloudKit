//
//  JSONStringToTypeConvertable.swift
//  Core
//
//  Created by Adir Burke on 22/1/20.
//

import Foundation
import CodableWrappers

public protocol OptionalInitable {
    init?(_ value : String)
}

extension Int : OptionalInitable {}
extension Double : OptionalInitable {}
extension UInt : OptionalInitable {}
extension String : OptionalInitable {}
extension Data : OptionalInitable {
    public init?(_ value: String) {
        if let  data =  value.data(using: .utf8) {
            #warning("Might need to be base64")
            self = data
        } else {
            return nil
        }
    }
}

public struct Coder<T : Codable &  OptionalInitable> : StaticCoder {
    public static func decode(from decoder: Decoder) throws -> T? {
        if let directValue = try? T(from: decoder) {
            return  directValue
        } else if let fromValue = try? String(from: decoder),
            let directValue = T.init(fromValue) {
            return directValue
        }
        return nil
    }
   public  static func encode(value: T?, to encoder: Encoder) throws {
        return try value.encode(to: encoder)
    }
}
