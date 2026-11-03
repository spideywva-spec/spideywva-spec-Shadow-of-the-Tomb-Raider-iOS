import Foundation
import simd

struct EngineTransform {
    var position = SIMD3<Float>(0, 0, 0)
    var rotation = SIMD3<Float>(0, 0, 0)
    var scale = SIMD3<Float>(repeating: 1)
    var matrix: simd_float4x4 {
        simd_float4x4(translation: position) * simd_float4x4(rotationY: rotation.y) * simd_float4x4(rotationX: rotation.x) * simd_float4x4(scale: scale)
    }
}

extension simd_float4x4 {
    init(translation v: SIMD3<Float>) {
        self.init(columns: (SIMD4<Float>(1,0,0,0), SIMD4<Float>(0,1,0,0), SIMD4<Float>(0,0,1,0), SIMD4<Float>(v.x,v.y,v.z,1)))
    }
    init(scale v: SIMD3<Float>) {
        self.init(columns: (SIMD4<Float>(v.x,0,0,0), SIMD4<Float>(0,v.y,0,0), SIMD4<Float>(0,0,v.z,0), SIMD4<Float>(0,0,0,1)))
    }
    init(rotationX a: Float) {
        let c = cos(a), s = sin(a)
        self.init(columns: (SIMD4<Float>(1,0,0,0), SIMD4<Float>(0,c,s,0), SIMD4<Float>(0,-s,c,0), SIMD4<Float>(0,0,0,1)))
    }
    init(rotationY a: Float) {
        let c = cos(a), s = sin(a)
        self.init(columns: (SIMD4<Float>(c,0,-s,0), SIMD4<Float>(0,1,0,0), SIMD4<Float>(s,0,c,0), SIMD4<Float>(0,0,0,1)))
    }
    static func perspective(fovY: Float, aspect: Float, near: Float, far: Float) -> simd_float4x4 {
        let y = 1 / tan(fovY * 0.5), x = y / max(aspect, 0.001), z = far / (near - far)
        return simd_float4x4(columns: (SIMD4<Float>(x,0,0,0), SIMD4<Float>(0,y,0,0), SIMD4<Float>(0,0,z,-1), SIMD4<Float>(0,0,z * near,0)))
    }
}
