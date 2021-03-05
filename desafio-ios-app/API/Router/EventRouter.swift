//
//  EventRouter.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import Alamofire

enum EventRouter: URLRequestConvertible {
    
    case fetch(Token)
    
    var path: String {
        switch self {
        case .fetch:
            return "events/"
        }
    }
    
    var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleUrlServer") as! String
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetch:
            return .post
        
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        if let token =  UserDefaults.standard.string(forKey: "token") {
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let params: (Codable?) = {
            switch self {
            case .fetch(let params):
                return (params)
            }
        }()
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get: return URLEncoding.default
            default: return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(urlRequest, with: params?.dictionary)
    }
}

