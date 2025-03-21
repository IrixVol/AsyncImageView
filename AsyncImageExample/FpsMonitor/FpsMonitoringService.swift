//
//  FpsMonitoringService.swift
//  AsyncImageExample
//
//  Created by Благообразова Татьяна Александровна on 21.03.2025.
//

import Foundation
import Combine
import QuartzCore

/// Сервис для подсчета FPS, выводит среднее и нижнее значение FPS каждые 30 фреймов
@MainActor
public final class FpsMonitoringService {
    
    ///  Установить вывод каждые 30 кадров
    public var updateRate: Int = 30
    
    /// Выключайте сервис, когда вливаете изменения: не спамить в консоль
    public var isOn: Bool = true
    
    /// Вывод в консоль
    public var isPrint: Bool = true
    
    /// Используйте замыкание `onMeasure` или паблишер `fpsPublisher` для получения результатов
    public var onMeasure: ((_ fpsAverage: CGFloat?, _ fpsLowest: CGFloat?) -> Void)?
    
    /// `.onReceive(service.fpsPublisher)` для встраивания сервиса в SwiftUI View
    public var fpsPublisher: AnyPublisher<(CGFloat?, CGFloat?), Never> {
        measureSubject.eraseToAnyPublisher()
    }
    private let measureSubject = PassthroughSubject<(CGFloat?, CGFloat?), Never>()
    
    private var displayLink: CADisplayLink?
    private var firstTime: Date?
    private var previousTime: Date?
    private var fpsLongestPeriod: CGFloat?
    private var measurementsCount = 0
    
    public init(isOn: Bool, updateRate: Int = 30, print: Bool = true) {
        self.isOn = isOn
        self.isPrint = print
        self.updateRate = updateRate
    }
    
    @objc private func tick() {
        
        measure()
        
        /// Делаем вывод каждые 30 фреймов
        if measurementsCount.isMultiple(of: updateRate) {
            
            guard let firstTime, let fpsLongestPeriod, fpsLongestPeriod != 0 else { return }
            let tickPeriod = Date().timeIntervalSince(firstTime)
            let framePerSecondAverage = CGFloat(measurementsCount) / tickPeriod
            let framePerSecondLowest = 1 / fpsLongestPeriod
            
            onMeasure?(framePerSecondAverage, framePerSecondLowest)
            measureSubject.send((framePerSecondAverage, framePerSecondLowest))
            
            /// Сбрасываем значения и начинаем считать новые
            clearStartValues()
            
            guard isPrint else { return }
            
            print(String(
                format: "\("fpsAverage:") %.2f, \("fpsLowest:") %.2f",
                framePerSecondAverage,
                framePerSecondLowest
            ))
        }
    }
    
    private func measure() {
        
        defer {
            previousTime = Date()
            measurementsCount += 1
        }
        
        guard let previousTime else { return }
        
        let tickPeriod = Date().timeIntervalSince(previousTime)
        fpsLongestPeriod = fpsLongestPeriod.map { max($0, tickPeriod) } ?? tickPeriod
    }
    
    func clearStartValues() {
        
        firstTime = Date()
        measurementsCount = 0
        previousTime = nil
        fpsLongestPeriod = nil
    }
}

public extension FpsMonitoringService {
    
    func startMonitoring() {
        
        guard isOn else { return }
        clearStartValues()
        
        let displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink.add(to: .main, forMode: .default)
        displayLink.add(to: .main, forMode: .tracking)
        self.displayLink = displayLink
    }
    
    func stopMonitoring() {
        
        displayLink?.remove(from: .main, forMode: .default)
        displayLink?.remove(from: .main, forMode: .tracking)
        displayLink?.invalidate()
        displayLink = nil
        
        firstTime = nil
        previousTime = nil
        measurementsCount = 0
    }
}

public extension FpsMonitoringService {
    
    func setupMeasure(_ measure: ((_ fpsAverage: CGFloat?, _ fpsLowest: CGFloat?) -> Void)?) -> Self {
        self.onMeasure = measure
        return self
    }
    
}
