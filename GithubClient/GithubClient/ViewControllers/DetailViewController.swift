//
//  DetailViewController.swift
//  GithubClient
//
//  Created by Vasyl Liutikov on 05.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import UIKit
import GithubAPI

final class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel?
    
    var user: User? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    deinit {
        print("")
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let user = user {
            if let label = detailDescriptionLabel {
                label.text = user.email ?? "not avalible"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }

}
