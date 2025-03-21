//
//  AsyncImageView.swift
//  AsyncImageExample
//
//  Created by Tatiana on 05.03.2025.
//

import SwiftUI

extension AsyncImageView {
    
    struct Model: Identifiable {
        
        var id: String
        var getImage: @Sendable () async throws -> UIImage?
        var aspectRatio: CGFloat?
        var contentMode: ContentMode
        
        public init(
            id: String,
            aspectRatio: CGFloat? = nil,
            contentMode: ContentMode = .fit,
            getImage: @escaping @Sendable () async throws -> UIImage?
        ) {
            self.id = id
            self.aspectRatio = aspectRatio
            self.contentMode = contentMode
            self.getImage = getImage
        }
    }
}

struct AsyncImageView: View {
    
    @State private var uiImage: UIImage = .init()
    
    private let model: Model
    
    init(model: Model) {
        self.model = model
    }
    
    var body: some View {
        
        Image(uiImage: uiImage)
            .resizable()
            .modifier(AspectRatioModifer(
                aspectRatio: model.aspectRatio,
                contentMode: model.contentMode
            ))
            .task(id: model) {
                uiImage = UIImage()
                if let downloadedImage = try? await model.getImage() {
                    uiImage = downloadedImage
                }
            }
    }
}

extension AsyncImageView.Model: Equatable {
    public static func == (lhs: AsyncImageView.Model, rhs: AsyncImageView.Model) -> Bool {
        lhs.id == rhs.id &&
        lhs.contentMode == rhs.contentMode &&
        lhs.aspectRatio == rhs.aspectRatio
    }
}

/// Применение стандартного модификатора `.aspectRatio(aspectRatio, contentMode: .fit/fill)`
/// приводит к деформации картинки, вместо ожидаемого пропорционального изменения ее содержимого
/// https://alejandromp.com/development/blog/image-aspectratio-without-frames
private struct AspectRatioModifer: ViewModifier {
    
    let aspectRatio: CGFloat?
    let contentMode: ContentMode
    
    func body(content: Content) -> some View {
        if let aspectRatio {
            content
                .aspectRatio(contentMode: contentMode)
                .frame(
                    minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity
                )
                .aspectRatio(aspectRatio, contentMode: .fit)
                .clipped()
        } else {
            content
                .aspectRatio(contentMode: contentMode)
        }
    }
}
