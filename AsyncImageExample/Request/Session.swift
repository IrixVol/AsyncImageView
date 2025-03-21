//
//  Session.swift
//  AsyncImageExample
//
//  Created by Tatiana on 05.03.2025.
//

import Foundation

public extension URLSession {

    static let downloadSession: URLSession = {
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = URLCache(
            memoryCapacity: 100 * 1024 * 1024, // 100 MB
            diskCapacity: 1000 * 1024 * 1024, // 1000 MB
            diskPath: "SharedData"
        )
        
        return URLSession(
            configuration: configuration,
            delegate: nil,
            delegateQueue: nil
        )
        
    }()
}
