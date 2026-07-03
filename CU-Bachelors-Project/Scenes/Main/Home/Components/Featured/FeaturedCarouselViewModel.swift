import Foundation

@MainActor
@Observable
final class FeaturedCarouselViewModel {

    var currentIndex: Int = 0

    private var itemCount: Int
    private var timerTask: Task<Void, Never>?
    private let interval: TimeInterval

    init(itemCount: Int, interval: TimeInterval = 4.0) {
        self.itemCount = itemCount
        self.interval = interval
    }

    func start() {
        guard itemCount > 1 else { return }
        stop()
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(interval))
                guard !Task.isCancelled else { break }
                advance()
            }
        }
    }

    func stop() {
        timerTask?.cancel()
        timerTask = nil
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
