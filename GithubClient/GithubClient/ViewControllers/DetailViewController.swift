//
//  DetailViewController.swift
//  GithubClient
//
//  Created by Vasyl Liutikov on 05.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import GithubAPI
import UIKit

final class DetailViewController: UIViewController {

    @IBOutlet var emailButton: UIButton?

    var user: User? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let user = user {
            if let button = emailButton {
                if let email = user.email {
                    button.setTitle(email, for: .normal)
                    button.isEnabled = true
                } else {
                    button.setTitle("User has private email", for: .normal)
                    button.isEnabled = false
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    @IBAction func sendMail(_ sender: Any) {
        if let email = self.user?.email {
            let urlStr = "mailto:" + email
            if let url = URL(string: urlStr),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
