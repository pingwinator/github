//
//  ModelResponseSerializer.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ModelResponseSerializer<T: JSONDecodableModel> {
    typealias PostMappingAction = (T) -> T
    
    func handleCompletionHandler(data: JSON?, dataStructureRootKey: String? = nil, _ success: Bool, _ error: VLError?, postMappingAction: PostMappingAction? = nil, _ onCompletion: @escaping (T?, _ success: Bool, _ error: VLError?) -> Void) {
        
        if error != nil {
            onCompletion(nil, false, error)
        } else {
            guard let json = data else {
                onCompletion(nil, false, nil)
                return
            }
            
            do {
                var objectForModel = (dataStructureRootKey != nil) ? try T(json: json[dataStructureRootKey!]) : try T(json: json)
                if let action = postMappingAction {
                    objectForModel = action(objectForModel)
                }
                onCompletion(objectForModel, success, error)
            } catch {
                onCompletion(nil, false, error as? VLError)
            }
        }
    }
}
