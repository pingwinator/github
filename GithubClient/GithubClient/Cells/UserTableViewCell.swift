//
//  UserTableViewCell.swift
//  GithubClient
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import AFDateHelper
import GithubAPI
import UIKit

final class UserTableViewCell: UITableViewCell {
    
    var user: UserOverview?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }
    
    fileprivate func reset() {
        self.textLabel?.text = ""
        self.detailTextLabel?.text = ""
        self.imageView?.image = #imageLiteral(resourceName: "octocat")
        self.user = nil
        self.imageView?.cancelImageRequest()
    }
    
}

extension UserTableViewCell: ConfigurableCell {
    func configure(object: BasicUser) {
        
        if let user = object as? UserOverview {
            self.user = user
            textLabel?.text = object.login
            self.imageView?.setImage(withUser: user)
        }
        if let user = object as? User {
            if let selfUser = self.user,
                user.userId == selfUser.userId {
                detailTextLabel?.text = user.createdAt.toString()
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        }
    }
}

extension UserTableViewCell: ReusableIdentifier {
    
}
