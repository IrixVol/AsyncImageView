//
//  ItemApiModel.swift
//  AsyncImageExample
//
//  Created by Tatiana on 05.03.2025.
//

import Foundation

struct ItemApiModel: Codable, Identifiable {
    
    var id: String {
        url ?? UUID().uuidString
    }
    
    var copyright: String?
    var date: String
    var explanation: String
    var title: String
    var url: String?
}
