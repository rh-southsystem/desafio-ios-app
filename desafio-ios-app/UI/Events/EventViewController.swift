//
//  EventViewController.swift
//  desafio-ios-app
//
//  Created by DIEGO RODRIGUES ABDALLA UTHMAN on 04/03/21.
//

import UIKit
import RxSwift

class EventViewController: UIViewController {
    
    private let viewModel = EventViewModel()
    private let disposeBag = DisposeBag()
    let spinner = SpinnerViewController()
   
    lazy var tableView: UITableView = {
        let tbl = UITableView.init()
        tbl.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomTableViewCell")
        tbl.tableFooterView = UIView.init()
        tbl.delegate = self
        tbl.dataSource = self
        tbl.isScrollEnabled = true
        tbl.backgroundColor = .white
        tbl.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        return tbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNavigationBar()
        bindUI()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(
            top: (view.topAnchor, 0),
            left: (view.leftAnchor, 0),
            right: (view.rightAnchor, 0),
            bottom: (view.bottomAnchor, 0)
        )
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "Eventos"
        let backButton = UIBarButtonItem()
        backButton.title = "SAIR"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

    }
}
//MARK: UITableView
extension EventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listEvents.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let list = viewModel.listEvents.value else { return UITableViewCell() }
        let cell = CustomTableViewCell()
        cell.setup(event: list[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let list = viewModel.listEvents.value else { return }
        
        let alert = UIAlertController(title: list[indexPath.row].name, message:list[indexPath.row].description , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

//MARK: BIND
extension EventViewController {
    func bindUI() {
        viewModel.fetchEvents()
        viewModel.eventStatus.subscribe(onNext: {[weak self] status in
            guard let self = self else { return }
            switch status {
            case .success:
                self.tableView.reloadData()
                self.stopLoading()
            case .loading:
                self.startLoading()
            case .genericError:
                self.stopLoading()
                self.genericError()
            }
        }).disposed(by: disposeBag)
    }
    
    private func genericError() {
        let description = "tivemos um problema, por favor tente mais tarde, ou entre em contato com o telefone: 41 99851-9586"
        let alert = UIAlertController(title: "Ops,", message: description , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
        
    }
}

//MARK: SPINNER
extension EventViewController {
    func stopLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.spinner.willMove(toParent: nil)
            self.spinner.view.removeFromSuperview()
            self.spinner.removeFromParent()
        }
    }
    
    func startLoading() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
}
