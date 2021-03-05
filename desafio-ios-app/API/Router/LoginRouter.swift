//
//  LoginRouter.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import Alamofire

enum LoginRouter: URLRequestConvertible {
    
    case login(Login)
    
    var path: String {
        switch self {
        case .login:
            return "login/"
        }
    }
    
    var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleUrlServer") as! String
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login:
            return .post
        
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        
        let params: (Codable?) = {
            switch self {
            case .login(let params):
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
