//
//  GlobalTypeAlias.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import Foundation

typealias CompletionHandler<T: Codable> = (T?, ErrorResponse?, [AnyHashable: Any]?) -> Void
