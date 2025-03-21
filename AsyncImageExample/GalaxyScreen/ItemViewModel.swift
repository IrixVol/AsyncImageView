//
//  ItemViewModel.swift
//  AsyncImageExample
//
//  Created by Tatiana on 06.03.2025.
//

import Foundation

struct ItemViewModel: Identifiable {
    
    var id: String {
        url
    }
    
    var url: String
    var title: String
    var date: Date?
    
    var imageModel: AsyncImageView.Model
}
