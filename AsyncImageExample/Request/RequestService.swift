//
//  RequestService.swift
//  AsyncImageExample
//
//  Created by Tatiana on 05.03.2025.
//

import Foundation
import UIKit

final class RequestService {
    
    let downloadSession = URLSession.downloadSession
    let key = "N68ooyHUCF5RLntOxMxwFa4MOGCdBehJQXDBaduH"

    func fetchNasaInfo(startDate: String, endDate: String) async -> Result<[ItemApiModel], Error> {

        print("startDate = \(startDate), endDate = \(endDate)")
        let url = "https://api.nasa.gov/planetary/apod?start_date=\(startDate)&end_date=\(endDate)&api_key=\(key)"
        print("url = \(url)")
        guard let url = URL(string: url) else {
            return .failure(RequestError.default)
        }
        
        let request: URLRequest = URLRequest(url: url)
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let messages = try JSONDecoder().decode([ItemApiModel].self, from: data)
            return .success(messages)
        } catch {
            print(error)
            return .failure(error)
        }
    }
    
    func downloadImage(link: String) async -> UIImage? {
        
        if let url = URL(string: link),
           let (data, _) = try? await downloadSession.data(for: URLRequest(url: url)) {
            return UIImage(data: data)
        }
        
        return nil
    }
}

enum RequestError: LocalizedError {

    case `default`
    
    var errorDescription: String? {
        "Что-то пошло не так. Пожалуйста, попробуйте позже."
    }
}
