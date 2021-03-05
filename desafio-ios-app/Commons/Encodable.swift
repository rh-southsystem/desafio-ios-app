//
//  Encodable.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import Foundation

extension Encodable {
    
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    
    var dictionary: [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else { return [:] }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] } ?? [:]
    }
}

