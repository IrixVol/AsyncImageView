//
//  ItemApiModel.swift
//  AsyncImageExample
//
//  Created by Tatiana on 05.03.2025.
//

struct ItemApiModel: Codable, Identifiable {
    
    var id: String {
        url
    }
    
    var copyright: String?
    var date: String
    var explanation: String
    var title: String
    var url: String
}
