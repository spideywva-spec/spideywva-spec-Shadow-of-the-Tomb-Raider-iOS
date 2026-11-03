import Foundation
import simd

final class EngineInput {
    private(set) var dragDelta = SIMD2<Float>(repeating: 0)
    private(set) var isDragging = false
    private var lastPoint = CGPoint.zero
    func begin(at point: CGPoint) { isDragging = true; dragDelta = .zero; lastPoint = point }
    func move(to point: CGPoint) {
        guard isDragging else { return }
        dragDelta = SIMD2(Float(point.x - lastPoint.x), Float(point.y - lastPoint.y))
        lastPoint = point
    }
    func consumeDragDelta() -> SIMD2<Float> { let value = dragDelta; dragDelta = .zero; return value }
    func end() { isDragging = false; dragDelta = .zero }
}
