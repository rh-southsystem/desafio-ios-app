//
//  Date+Misc.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import Foundation

public extension Date {
    func string(withFormat format: String = "dd/MM/yyyy HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
