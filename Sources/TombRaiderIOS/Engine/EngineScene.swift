import Foundation
import simd

struct EngineVertex {
    var position: SIMD3<Float>
    var color: SIMD3<Float>
}
struct EngineMesh {
    let vertices: [EngineVertex]
    let indices: [UInt16]
    static let cube: EngineMesh = {
        let p: [SIMD3<Float>] = [
            SIMD3(-1,-1,1),SIMD3(1,-1,1),SIMD3(1,1,1),SIMD3(-1,1,1),
            SIMD3(1,-1,-1),SIMD3(-1,-1,-1),SIMD3(-1,1,-1),SIMD3(1,1,-1),
            SIMD3(-1,1,1),SIMD3(1,1,1),SIMD3(1,1,-1),SIMD3(-1,1,-1),
            SIMD3(-1,-1,-1),SIMD3(1,-1,-1),SIMD3(1,-1,1),SIMD3(-1,-1,1),
            SIMD3(1,-1,1),SIMD3(1,-1,-1),SIMD3(1,1,-1),SIMD3(1,1,1),
            SIMD3(-1,-1,-1),SIMD3(-1,-1,1),SIMD3(-1,1,1),SIMD3(-1,1,-1)
        ]
        let colors: [SIMD3<Float>] = [SIMD3(0.72,0.42,0.24),SIMD3(0.82,0.58,0.32),SIMD3(0.42,0.58,0.38),SIMD3(0.28,0.42,0.32),SIMD3(0.38,0.48,0.58),SIMD3(0.26,0.34,0.46)]
        let vertices = p.enumerated().map { EngineVertex(position: $0.element, color: colors[$0.offset / 4]) }
        var indices: [UInt16] = []
        for face in 0..<6 { let i = UInt16(face * 4); indices += [i,i+1,i+2,i,i+2,i+3] }
        return EngineMesh(vertices: vertices, indices: indices)
    }()
}
final class EngineNode {
    let name: String
    var transform = EngineTransform()
    var mesh: EngineMesh?
    var children: [EngineNode] = []
    init(name: String, mesh: EngineMesh? = nil) { self.name = name; self.mesh = mesh }
    func addChild(_ node: EngineNode) { children.append(node) }
}
struct EngineCamera {
    var position = SIMD3<Float>(0,0,5)
    var verticalFieldOfView: Float = 60 * .pi / 180
    var nearPlane: Float = 0.1
    var farPlane: Float = 500
    func viewProjection(aspect: Float) -> simd_float4x4 {
        simd_float4x4.perspective(fovY: verticalFieldOfView, aspect: aspect, near: nearPlane, far: farPlane) * simd_float4x4(translation: -position)
    }
}
final class EngineScene {
    let root = EngineNode(name: "Root")
    var camera = EngineCamera()
    init() {
        let object = EngineNode(name: "Diagnostic cube", mesh: .cube)
        object.transform.scale = SIMD3(repeating: 0.8)
        root.addChild(object)
    }
    func update(deltaTime: Float) {
        guard let object = root.children.first else { return }
        object.transform.rotation.y += deltaTime * 0.55
    }
}
