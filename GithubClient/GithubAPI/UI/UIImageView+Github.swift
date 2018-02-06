//
//  UIImageView+Github.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import AlamofireImage
import Foundation

extension UIImageView {
    
    public func setImage(withUser user: BasicUser, placeholderImage: UIImage? = nil) {
        if let url = URL(string: user.avatar) {
            af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else if let image = placeholderImage {
            self.image = image
        }
    }
    
    public func cancelImageRequest() {
        af_cancelImageRequest()
    }
}
