//
//  LoginViewModel.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//
import RxSwift
import RxCocoa

enum LoginStatus {
    case loading
    case success
    case genericError
}


class LoginViewModel {
    let useCase: LoginUseCaseProtocol
    let subjectError = PublishSubject<String>()
    let loginStatus = PublishSubject<LoginStatus>()
    
    init(useCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.useCase = useCase
    }
    
    func login(email: String?, password: String?) {
        guard let email = email, let password = password, !email.isEmpty,!password.isEmpty else {
            subjectError.onNext(("Por favor preencha o(s) campo(s)")); return
        }
        
        loginStatus.onNext(.loading)
        
        let login = Login(login: email, password: password)
        useCase.login(params: login) { [weak self] (response) in
            guard let self = self else { return }
            switch response {
            case .success:
                self.loginStatus.onNext(.success)
            case .failure(_):
                self.loginStatus.onNext(.genericError)
            }
        }
    }
}
