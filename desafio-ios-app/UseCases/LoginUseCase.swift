//
//  LoginBussinessModelProtocol.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import Foundation

enum LoginUseCaseResponse {
    case success
    case failure(ErrorResponse?)
}

protocol LoginUseCaseProtocol {
    typealias loginResponseCompletion = (LoginUseCaseResponse) -> Void
    func login(params: Login, completion: @escaping loginResponseCompletion)
}


class LoginUseCase: LoginUseCaseProtocol {
    let service: LoginServiceProtocol
    
    init(service: LoginServiceProtocol = LoginService()) {
        self.service = service
    }
    
    func login(params: Login, completion: @escaping loginResponseCompletion) {
        service.login(params: params) {(response, errorResponse, _) in
            if errorResponse == nil, let token : Token = response {
                UserDefaults.standard.setValue(token.token, forKey: "token")
                completion(.success)
            } else {
                completion(.failure(errorResponse))
            }
        }
    }
}



