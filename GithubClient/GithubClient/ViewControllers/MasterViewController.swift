//
//  MasterViewController.swift
//  GithubClient
//
//  Created by Vasyl Liutikov on 05.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Differ
import GithubAPI
import UIKit

final class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController?
    var objects = [Any]()
    var provider: SearchUsersProvider!
    var userProvider: UserProvider!
    weak var loginTextFildObserver: NSObjectProtocol?

    var users: [UserOverview] = [] {
        didSet {
            var groupedUsers = Dictionary(grouping: users, by: { String($0.login.first!).lowercased() })
            sectionTitles = groupedUsers.keys.sorted()
            groupedItems = sectionTitles.map {
                let user = groupedUsers[$0] ?? []
                return SortedArray(user)
            }
        }
    }
    var sectionTitles: [String] = []
    var groupedItems: [SortedArray<UserOverview>] = [] {
        didSet {
            let animation: UITableView.RowAnimation = .top
            tableView.animateRowAndSectionChanges(oldData: oldValue, newData: groupedItems, rowDeletionAnimation: animation, rowInsertionAnimation: animation, sectionDeletionAnimation: animation, sectionInsertionAnimation: animation)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        provider = GitHubApi.shared.createUserSearch()
        userProvider = GitHubApi.shared.createUserProvider()
        setupUser()
        if let split = splitViewController {
            let controllers = split.viewControllers

            if let navVC = controllers[controllers.count - 1] as? UINavigationController,
                let detailViewController = navVC.topViewController as? DetailViewController {
                self.detailViewController = detailViewController
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    // MARK: - Actions

    @objc
    func loadNextPage(_ sender: Any) {
        provider.loadNextPage { [weak self] response, status, error in
            if (response?.data) != nil, status,
                let users = self?.provider.users {
                self?.users = users
            } else if let error = error {
                self?.showErrorMessage(error.description)
            }
            self?.navigationItem.rightBarButtonItem?.isEnabled = self?.provider.canLoadNextPage ?? false
        }
    }

    func loadFirstPage() {
        provider.search(query: [SearchTerms.javaLang, SearchTerms.user]) { [weak self] response, status, error in
            if (response?.data) != nil, status,
                let users = self?.provider.users {
                self?.users = users
            } else if let error = error {
                self?.showErrorMessage(error.description)
            }
            self?.navigationItem.rightBarButtonItem?.isEnabled = self?.provider.canLoadNextPage ?? false
        }
    }

    @objc
    func logout(_ sender: Any) {
        GitHubApi.shared.userAdapter = nil
        GitHubAccount.erase()
        users = []
        setupUser()
    }

    @objc
    func login(_ sender: Any) {

        let alertController = UIAlertController(title: "Please, enter your login and pass", message: nil, preferredStyle: .alert)

        let loginAction = UIAlertAction(title: "Login", style: .default) { [weak alertController, weak self] _ in
            if let textFields = alertController?.textFields,
                let loginTextField = textFields.first,
                let passwordTextField = textFields.last,
                let login = loginTextField.text,
                let pass = passwordTextField.text {
                self?.login(user: login, password: pass)

            }
            if let observer = self?.loginTextFildObserver {
                NotificationCenter.default.removeObserver(observer)
            }
        }
        loginAction.isEnabled = false

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            if let observer = self?.loginTextFildObserver {
                NotificationCenter.default.removeObserver(observer)
            }
        }

        alertController.addTextField { [weak self] textField in
            textField.placeholder = "Login"

            self?.loginTextFildObserver = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { _ in
                loginAction.isEnabled = textField.text != ""
            }
        }

        alertController.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }

        alertController.addAction(loginAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }

    // MARK: - Private
    
    fileprivate func setupUser() {
        if let github = GitHubAccount.read() {
            GitHubApi.shared.userAdapter = UserAdapter(account: github)
            loadFirstPage()
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout(_:)))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+10", style: .plain, target: self, action: #selector(loadNextPage(_:)))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(login(_:)))
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    fileprivate func setupTableview() {
        for identifier in Identifiers.allValues {
            tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
        tableView.rowHeight = 50
    }
    
    fileprivate func showErrorMessage(_ message: String?) {

        let alert = UIAlertController(title: "", message: message ?? NSLocalizedString("something.wrong", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { (_) -> Void in

        }))
        present(alert, animated: true, completion: nil)
    }

    fileprivate func login(user: String, password: String) {
        let user = GitHubAccount(username: user, password: password)
        user.save()
        setupUser()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.showDetail,
            let user = sender as? User {
            if let navVC = segue.destination as? UINavigationController,
                let controller = navVC.topViewController as? DetailViewController {
                controller.user = user
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
    }

    // MARK: - Table View

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: Identifiers.user, for: indexPath)
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedItems[section].count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let user = groupedItems[indexPath.section][indexPath.row]
        if let userCell = cell as? UserTableViewCell {
            userCell.configure(object: user)
            userProvider.loadDetails(for: user, onCompletion: { user, status, _ in
                if let user = user, status {
                    userCell.configure(object: user)
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //showDetail
        let user = groupedItems[indexPath.section][indexPath.row]
        userProvider.loadDetails(for: user, allowCache: false, onCompletion: { [weak self] user, status, error in
            if let user = user, status {
                self?.performSegue(withIdentifier: Segues.showDetail, sender: user)
            } else if let error = error {
                self?.showErrorMessage(error.description)
            }
        })
    }
}

extension MasterViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let users = indexPaths.map { groupedItems[$0.section][$0.row]}
        userProvider.prefetchUser(users: users)
    }
}

extension MasterViewController {
    fileprivate struct Identifiers {
        static let user: String = UserTableViewCell.reuseIdentifier
        static let allValues = [user]
    }
    
    fileprivate struct Segues {
        static let showDetail = "showDetail"
    }

}
