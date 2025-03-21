//
//  GalaxyScreenModel.swift
//  AsyncImageExample
//
//  Created by Tatiana on 05.03.2025.
//

import SwiftUI

@MainActor
final class GalaxyScreenModel: ObservableObject {
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let service = RequestService()
    
    var isLoading: Bool = false
    @Published var items: [ItemViewModel] = []

    func fetchItems() async {
        
        if isLoading { return }
        
        isLoading = true
        let endDate = items.last?.date?.addingDays(-1) ?? Date()
        let startDate = endDate.addingDays(-30)
        
        if let apiModels = try? await service.fetchNasaInfo(
            startDate: dateFormatter.string(from: startDate),
            endDate: dateFormatter.string(from: endDate)
        ).get() {
            items += apiModels.map { mapViewModel($0) }.reversed()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isLoading = false
        }
    }
    
    func mapViewModel(_ item: ItemApiModel) -> ItemViewModel {
        .init(
            url: item.url,
            title: item.title,
            date: dateFormatter.date(from: item.date),
            imageModel: .init(
                id: item.id,
                aspectRatio: 16 / 9,
                contentMode: .fill,
                getImage: { [weak self] in
                    print(item.url)
                    return await self?.service.downloadImage(link: item.url)
                    
                }
            )
        )
    }
}

extension Date {
    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -10, to: self) ?? Date()
    }
}
