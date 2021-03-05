//
//  LoginService.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import Alamofire

protocol LoginServiceProtocol {
    func isConnectedToInternet() -> Bool
    func login(params: Login, completionHandler: @escaping CompletionHandler<Token>)
}

class LoginService: BaseService, LoginServiceProtocol {
    func isConnectedToInternet() -> Bool {
        return Connectivity.isConnectedToInternet
    }
    
    func login(params: Login, completionHandler: @escaping CompletionHandler<Token>) {
        performRequest(LoginRouter.login(params), completionHandler)
    }
}
