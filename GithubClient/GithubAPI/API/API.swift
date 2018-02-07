//
//  API.swift
//  GithubAPI
//
//  Created by Vasyl Liutikov on 06.02.2018.
//  Copyright © 2018 pingwinator. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import WebLinking
import Cache

internal typealias ServiceResponse = (JSON?, _ success: Bool, _ links: [Link], _ error: VLError?) -> Void

public final class GitHubApi {
    public static let shared = GitHubApi()
    let sessionManager: SessionManager
    let baseURLString = "https://api.github.com"
    let cache: Storage?
    public var userAdapter: UserAdapter? = nil {
        didSet {
            sessionManager.adapter = userAdapter
        }
    }
    
    fileprivate init() {
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders["Content-Type"] = "application/json"
        defaultHeaders["Accept"] = "application/vnd.github.v3+json"
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = defaultHeaders
        
        sessionManager = Alamofire.SessionManager(configuration: configuration)
        let diskConfig = DiskConfig(name: "ApiCache")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
        cache = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig)
    }
    
    fileprivate func isReachable() -> Bool {
        return VLReachabilityManager.shared.isReachable || VLReachabilityManager.shared.networkReachabilityStatus == VLNetworkReachabilityStatus.unknown
    }
    
    internal func operationWith(request:URLRequestConvertible, onCompletion: @escaping ServiceResponse) {
        guard isReachable() else {
            onCompletion(nil, false, [], VLError.noInternet)
            return
        }
        
        let dataRequest = sessionManager.request(request).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let links = response.response?.links ?? []
                onCompletion(JSON(value), true, links, nil)
            case .failure(let er):
                let responseData = response.data
                var error = APIError<GithubError>(request: response.request, response: response.response, data: responseData, error: er)
                if let data = response.data, !data.isEmpty {
                    error.errorModel = try? GithubError(json: JSON(data: data))
                }
                var errorCategory = VLError.network(error)
                if errorCategory.isNoInternet {
                    errorCategory = VLError.noInternet
                }
                onCompletion(nil, false, [], errorCategory)
            }
        }
        //put breakpoint here for debug requests
        _ = dataRequest.progress
    }
}
