//
//  Response.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import UIKit

struct ErrorResponse: Codable {
    var status: Int?
    var timestamp: String?
    var noInternetConnection: Bool?
    
    init(status: Int, timestamp: String, noInternetConnection: Bool = false) {
        self.status = status
        self.timestamp = timestamp
        self.noInternetConnection = noInternetConnection
    }
    
    static func noInternetConnection() -> ErrorResponse {
        let erroCode = 1009
        return ErrorResponse(
            status: erroCode,
            timestamp: Date().string(),
            noInternetConnection: true
        )
    }
    
    static func somethingWentWrong(status: Int = 500, _ code: String="") -> ErrorResponse {
        return ErrorResponse(
            status: status,
            timestamp: Date().string()
        )
    }
}
