//
//  LoaderView.swift
//  AsyncImageExample
//
//  Created by Tatiana on 05.03.2025.
//

import SwiftUI

var animationDuration: Double = 0.5

struct LoaderView: View {

    @State private var isStarted: Bool = false
    @State private var rotationAngle = 0.0
    
    private var animation = Animation.linear(duration: 1.3).repeatForever(autoreverses: false)
    private let gradient = AngularGradient(colors: [.gray, .white], center: .center, angle: .zero)
    
    var body: some View {
        
        Circle()
            .stroke(gradient, lineWidth: 4)
            .frame(width: 24, height: 24)
            .rotationEffect(Angle(degrees: isStarted ? 359 : 0))
            .transaction { transaction in
                transaction.animation = isStarted ? animation : .linear(duration: 0)
            }
            .onAppear {
                isStarted = true
            }
            .onDisappear {
                isStarted = false
            }
            .scaleEffect(1)
    }
}

#Preview {
    LoaderView()
}
