//
//  Primitive.swift
//  MetalPlayground
//
//  Created by Mikita on 11.12.21.
//

import Foundation
import MetalKit

class Primitive {
  class func makeCube(device: MTLDevice, size: Float) -> MDLMesh {
    let allocator = MTKMeshBufferAllocator(device: device)
    let mesh = MDLMesh(boxWithExtent: [size, size, size],
                       segments: [1, 1, 1],
                       inwardNormals: false, geometryType: .triangles,
                       allocator: allocator)
    return mesh
  }
}
