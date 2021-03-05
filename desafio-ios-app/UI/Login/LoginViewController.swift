//
//  LoginViewController.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    private var emailTxt = UITextField()
    private var passwordTxt = UITextField()
    private var loginBtn = UIButton()
    private var stackView = UIStackView()
    private let diposeBag = DisposeBag()
    private let spinner = SpinnerViewController()
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        anchorElements()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
  
    //MARK: SETUPUI
    private func setupUI() {
        view.backgroundColor = .white
        setupButton()
        setupTextField()
        setupStackView()
    }
    
    private func setupTextField() {
        emailTxt.delegate = self
        passwordTxt.delegate = self
        
        emailTxt.placeholder = "Email"
        emailTxt.text = "diegouthma5@gmail.com"
        
        passwordTxt.placeholder = "Senha"
        passwordTxt.text = "12345"
        
        emailTxt.backgroundColor = .white
        passwordTxt.backgroundColor = .white
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(emailTxt)
        stackView.addArrangedSubview(passwordTxt)
        stackView.addArrangedSubview(loginBtn)
        view.addSubview(stackView)
    }
    
    private func setupButton() {
        loginBtn.setTitle("Entrar", for: .normal)
        loginBtn.backgroundColor = .black
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.borderColor = UIColor.black.cgColor
        loginBtn.alpha = 0.5
        
        loginBtn.addTarget(self, action: #selector(actionContinueButton), for: .touchDown)
    }
    
    private func stopLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.spinner.willMove(toParent: nil)
            self.spinner.view.removeFromSuperview()
            self.spinner.removeFromParent()
        }
    }
    
    private func startLoading() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    private func anchorElements() {
        stackView.anchor(
            centerX: (view.centerXAnchor,0),
            centerY: (view.centerYAnchor,0),
            left: (view.leftAnchor,0),
            right: (view.rightAnchor,0)
        )
        
        emailTxt.anchor(
            left: (stackView.leftAnchor,45),
            right: (stackView.rightAnchor,45),
            height: 60
        )
        
        passwordTxt.anchor(
            left: (stackView.leftAnchor,45),
            right: (stackView.rightAnchor,45),
            height: 60
        )
        
        loginBtn.anchor(
            left: (stackView.leftAnchor,45),
            right: (stackView.rightAnchor,45),
            height: 50
        )
    }
    
    @objc private func actionContinueButton() {
        viewModel.login(email: emailTxt.text, password: passwordTxt.text)
    }
}

//MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: BIND
extension LoginViewController {
    func bindUI() {
        viewModel.loginStatus
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .success:
                    self.stopLoading()
                    self.navigationController?.pushViewController(EventViewController(), animated: true)
                case .loading:
                    self.startLoading()
                case .genericError:
                    self.stopLoading()
                    self.genericError()
                }
                
            }, onError: {[weak self] error in
                guard let self = self else { return }
                self.genericError(error.localizedDescription)
            }).disposed(by: diposeBag)
        
        viewModel.subjectError
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
               
                let alert = UIAlertController(title: "Ops,", message: error.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }).disposed(by: diposeBag)
    }
    
    private func genericError(_ errorDescription: String? = nil) {
        var description = "tivemos um problema, por favor tente mais tarde, ou entre em contato com o telefone: 41 99851-9586"
        if let errorDescription = errorDescription, !errorDescription.isEmpty {
            description = errorDescription
        }
        let alert = UIAlertController(title: "Ops,", message: description , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
}
