//
//  FeaturedCarouselViewModel.swift
//  CU-Bachelors-Project
//
//  Created by Natali Zhgenti on 17.06.26.
//

import Foundation
import Combine

@MainActor
final class FeaturedCarouselViewModel: ObservableObject {
    
    @Published var currentIndex: Int = 0
    
    private var itemCount: Int
    private var timerCancellable: AnyCancellable?
    private let interval: TimeInterval
    
    init(itemCount: Int, interval: TimeInterval = 4.0) {
        self.itemCount = itemCount
        self.interval = interval
    }
    
    func start() {
        guard itemCount > 1 else { return }
        timerCancellable = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.advance()
            }
    }
    
    func stop() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    func updateItemCount(_ count: Int) {
        itemCount = count
        if currentIndex >= count {
            currentIndex = 0
        }
        if count > 1 {
            start()
        } else {
            stop()
        }
    }
    
    private func advance() {
        guard itemCount > 0 else { return }
        currentIndex = (currentIndex + 1) % itemCount
    }
}
