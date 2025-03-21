//
//  FpsMonitorView.swift
//  AsyncImageExample
//
//  Created by Благообразова Татьяна Александровна on 21.03.2025.
//

import SwiftUI

/// Позволяет замерять и выводить частоту кадра
public struct FpsMonitorView: View {
    
    @State var printInConsole: Bool = false
    @State var fpsAverage: CGFloat?
    @State var fpsLowest: CGFloat?
    @State var service: FpsMonitoringService
    
    public init(printInConsole: Bool = false) {
        _service = State(initialValue: FpsMonitoringService(isOn: true, print: printInConsole))
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text("FPS average: \(string(fpsAverage)), FPS lowest: \(string(fpsLowest))")
                .font(.system(size: 18, weight: .medium).monospacedDigit())
                .foregroundColor(.white)
        }
        .onAppear {
            service.startMonitoring()
        }
        .onDisappear {
            service.stopMonitoring()
        }
        .onReceive(service.fpsPublisher) { avarage, lowest in
            fpsAverage = avarage
            fpsLowest = lowest
        }
    }
    
    private func string(_ value: CGFloat?) -> String {
        value.map { String(format: "%05.02f", $0) } ?? "00.00"
    }
}

#Preview {
    VStack {
        FpsMonitorView()
    }
    .background(.gray)
}
