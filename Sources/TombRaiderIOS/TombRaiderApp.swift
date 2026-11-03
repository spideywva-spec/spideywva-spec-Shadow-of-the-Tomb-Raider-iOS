import SwiftUI
import UIKit
import MetalKit

@main
struct TombRaiderApp: App {
    var body: some Scene {
        WindowGroup {
            EngineGameView()
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
        }
    }
}

private struct EngineGameView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> EngineTouchView {
        let view = EngineTouchView(frame: .zero, device: MTLCreateSystemDefaultDevice())
        view.clearColor = MTLClearColor(red: 0.018, green: 0.025, blue: 0.035, alpha: 1)
        view.colorPixelFormat = .bgra8Unorm
        view.framebufferOnly = true
        view.preferredFramesPerSecond = 60
        view.isPaused = false
        view.enableSetNeedsDisplay = false
        let renderer = EngineRenderer(view: view)
        context.coordinator.renderer = renderer
        view.engineInput = renderer?.input
        return view
    }

    func updateUIView(_ uiView: EngineTouchView, context: Context) {}

    final class Coordinator {
        var renderer: EngineRenderer?
    }
}

private final class EngineTouchView: MTKView {
    weak var engineInput: EngineInput?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) { engineInput?.begin(at: point) }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) { engineInput?.move(to: point) }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { engineInput?.end() }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { engineInput?.end() }
}
