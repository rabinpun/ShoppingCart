//
//  SettingsController.swift
//  ShoppingCart
//
//  Created by ebpearls on 31/08/2022.
//

import UIKit
import Combine

/// Controller for Cartlist
final class SettingsController: UIViewController {
    
    private let tableCellHeight: CGFloat = 70
    private var alertCancellable: AnyCancellable?
    
    var presenter: SettingsPresentable!
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.registerCell(LanguageCell.self)
        view.tableHeaderView = nil
        view.separatorStyle = .singleLine
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white
        title = LocalizedKey.selectLanguage.value
        setupNavigationButtons()
        addTableView()
    }
    
    private func addTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupNavigationButtons() {
        let leftBarButton = UIBarButtonItem(image: .chevronLeft, style: .done, target: self, action: #selector(leftBarButtonClicked))
        leftBarButton.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc private func leftBarButtonClicked() {
        presenter.goBack()
    }
    
}

extension SettingsController: SettingsPresenterDelegate {
    
    func showAlert(title: String, message: String, alertActions: [AlertAction]) {
        alertCancellable = alert(title: title, msg: message, actions: alertActions).sink { alert in
            alert.actionClosure?()
        }
    }
    
}

/// Table view delegate confirmance
extension SettingsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.updateLanguage(indexPath.row)
    }
    
}

/// Table view datasource confirmance
extension SettingsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let language = presenter.getLanguage(index: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.identifier, for: indexPath) as! LanguageCell
        cell.configure(with: language)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numerOfLanguages()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableCellHeight
    }
    
}
