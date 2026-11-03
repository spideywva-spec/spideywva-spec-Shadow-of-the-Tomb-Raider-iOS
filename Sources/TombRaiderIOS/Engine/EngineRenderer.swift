import Foundation
import QuartzCore
import MetalKit
import simd

private struct EngineUniforms { var mvp: simd_float4x4 }

final class EngineRenderer: NSObject, MTKViewDelegate {
    private let commandQueue: MTLCommandQueue
    private let scene = EngineScene()
    let input = EngineInput()
    private let vertexBuffer: MTLBuffer
    private let indexBuffer: MTLBuffer
    private let indexCount: Int
    private let pipeline: MTLRenderPipelineState
    private var depthState: MTLDepthStencilState?
    private var lastFrameTime = CACurrentMediaTime()

    init?(view: MTKView) {
        guard let device = view.device ?? MTLCreateSystemDefaultDevice(), let queue = device.makeCommandQueue() else { return nil }
        commandQueue = queue
        let mesh = EngineMesh.cube
        guard let vb = device.makeBuffer(bytes: mesh.vertices, length: MemoryLayout<EngineVertex>.stride * mesh.vertices.count),
              let ib = device.makeBuffer(bytes: mesh.indices, length: MemoryLayout<UInt16>.stride * mesh.indices.count) else { return nil }
        vertexBuffer = vb; indexBuffer = ib; indexCount = mesh.indices.count
        let shader = """
        #include <metal_stdlib>
        using namespace metal;
        struct Vertex { float3 position; float3 color; };
        struct Uniforms { float4x4 mvp; };
        struct Out { float4 position [[position]]; float3 color; };
        vertex Out engineVertex(const device Vertex *v [[buffer(0)]], constant Uniforms &u [[buffer(1)]], uint id [[vertex_id]]) {
            Out o; o.position = u.mvp * float4(v[id].position, 1.0); o.color = v[id].color; return o;
        }
        fragment float4 engineFragment(Out in [[stage_in]]) { return float4(in.color, 1.0); }
        """
        do {
            let library = try device.makeLibrary(source: shader, options: nil)
            let descriptor = MTLRenderPipelineDescriptor()
            descriptor.vertexFunction = library.makeFunction(name: "engineVertex")
            descriptor.fragmentFunction = library.makeFunction(name: "engineFragment")
            descriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
            descriptor.depthAttachmentPixelFormat = .depth32Float
            pipeline = try device.makeRenderPipelineState(descriptor: descriptor)
        } catch { print("[Engine] Pipeline error: \(error)"); return nil }
        let depth = MTLDepthStencilDescriptor()
        depth.depthCompareFunction = .less
        depth.isDepthWriteEnabled = true
        depthState = device.makeDepthStencilState(descriptor: depth)
        super.init()
        view.depthStencilPixelFormat = .depth32Float
        view.delegate = self
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    func draw(in view: MTKView) {
        let now = CACurrentMediaTime()
        let dt = Float(min(now - lastFrameTime, 1.0 / 20.0))
        lastFrameTime = now
        scene.update(deltaTime: dt)
        if input.isDragging, let node = scene.root.children.first {
            node.transform.rotation.y += input.dragDelta.x * 0.006
            node.transform.rotation.x += input.dragDelta.y * 0.006
        }
        guard let drawable = view.currentDrawable, let pass = view.currentRenderPassDescriptor,
              let command = commandQueue.makeCommandBuffer(), let encoder = command.makeRenderCommandEncoder(descriptor: pass) else { return }
        let aspect = Float(view.drawableSize.width / max(view.drawableSize.height, 1))
        var uniforms = EngineUniforms(mvp: scene.camera.viewProjection(aspect: aspect) * scene.root.children[0].transform.matrix)
        encoder.setRenderPipelineState(pipeline)
        if let depthState { encoder.setDepthStencilState(depthState) }
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        encoder.setVertexBytes(&uniforms, length: MemoryLayout<EngineUniforms>.stride, index: 1)
        encoder.drawIndexedPrimitives(type: .triangle, indexCount: indexCount, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
        encoder.endEncoding(); command.present(drawable); command.commit()
    }
}
