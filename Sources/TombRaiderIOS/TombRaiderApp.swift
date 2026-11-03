import SwiftUI
import MetalKit

@main
struct TombRaiderApp: App {
    var body: some Scene {
        WindowGroup {
            MetalPrototypeView()
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
        }
    }
}

private struct MetalPrototypeView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            MetalTriangleView()
            VStack(alignment: .leading, spacing: 6) {
                Text("SHADOW OF THE TOMB RAIDER")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .tracking(1.4)
                Text("iOS Metal renderer · prototype")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.72))
                Text("This is a graphics test, not the game.")
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.55))
            }
            .padding(.top, 58)
            .padding(.leading, 22)
        }
        .background(Color.black)
    }
}

private struct MetalTriangleView: UIViewRepresentable {
    func makeUIView(context: Context) -> MTKView {
        let view = MTKView(frame: .zero, device: MTLCreateSystemDefaultDevice())
        view.clearColor = MTLClearColor(red: 0.025, green: 0.035, blue: 0.055, alpha: 1)
        view.colorPixelFormat = .bgra8Unorm
        view.framebufferOnly = true
        view.enableSetNeedsDisplay = false
        view.isPaused = false
        view.preferredFramesPerSecond = 60
        context.coordinator.attach(to: view)
        return view
    }

    func updateUIView(_ uiView: MTKView, context: Context) {}

    func makeCoordinator() -> Renderer {
        Renderer()
    }

    final class Renderer: NSObject, MTKViewDelegate {
        private var device: MTLDevice?
        private var queue: MTLCommandQueue?
        private var pipeline: MTLRenderPipelineState?

        func attach(to view: MTKView) {
            guard let device = view.device,
                  let queue = device.makeCommandQueue() else { return }
            self.device = device
            self.queue = queue

            let source = """
            #include <metal_stdlib>
            using namespace metal;
            struct VertexOut {
                float4 position [[position]];
                float3 color;
            };
            vertex VertexOut vertexMain(uint id [[vertex_id]]) {
                constexpr float2 positions[3] = {
                    float2(0.0, 0.62), float2(-0.58, -0.42), float2(0.58, -0.42)
                };
                constexpr float3 colors[3] = {
                    float3(0.85, 0.68, 0.38),
                    float3(0.35, 0.55, 0.72),
                    float3(0.72, 0.38, 0.25)
                };
                VertexOut out;
                out.position = float4(positions[id], 0.0, 1.0);
                out.color = colors[id];
                return out;
            }
            fragment float4 fragmentMain(VertexOut in [[stage_in]]) {
                return float4(in.color, 1.0);
            }
            """
            do {
                let library = try device.makeLibrary(source: source, options: nil)
                guard let vertex = library.makeFunction(name: "vertexMain"),
                      let fragment = library.makeFunction(name: "fragmentMain") else { return }
                let descriptor = MTLRenderPipelineDescriptor()
                descriptor.vertexFunction = vertex
                descriptor.fragmentFunction = fragment
                descriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
                pipeline = try device.makeRenderPipelineState(descriptor: descriptor)
            } catch {
                print("[MetalPrototype] Pipeline creation failed: \(error)")
            }
            view.delegate = self
        }

        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}

        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let pass = view.currentRenderPassDescriptor,
                  let queue, let pipeline,
                  let command = queue.makeCommandBuffer(),
                  let encoder = command.makeRenderCommandEncoder(descriptor: pass) else { return }
            encoder.setRenderPipelineState(pipeline)
            encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
            encoder.endEncoding()
            command.present(drawable)
            command.commit()
        }
    }
}
