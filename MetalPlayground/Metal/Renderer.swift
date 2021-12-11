//
//  Renderer.swift
//  MetalPlayground
//
//  Created by Mikita on 11.12.21.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    
    var timer: Float = 0
    
    
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var mesh: MTKMesh!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    
    var metalView: MTKView! = nil
    
  init(metalView: MTKView) {
      
      super.init()
      
      self.metalView = metalView
      
      createDevice()
      
      createCommandQueue()
      
      createMesh()
      
      createRenderPipeline()
      
      metalView.clearColor = MTLClearColor(red: 1.0, green: 1.0,
                                           blue: 0.8, alpha: 1.0)
      metalView.delegate = self
      metalView.device = device
  }
    
    func createDevice() {
        self.device = MTLCreateSystemDefaultDevice()
        
        guard device != nil else {
          fatalError("GPU not available")
        }
    }
    
    func createCommandQueue() {
        let commandQueue = device.makeCommandQueue()
        
        guard commandQueue != nil else {
          fatalError("Command queue not available")
        }
        
        self.commandQueue = commandQueue!
    }
    
    func createMesh() {
        let mdlMesh = Primitive.makeCube(device: device, size: 1)
        do {
          mesh = try MTKMesh(mesh: mdlMesh, device: device)
        } catch let error {
          print(error.localizedDescription)
        }
        
        vertexBuffer = mesh.vertexBuffers[0].buffer
    }
    
    func createRenderPipeline() {
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mesh.vertexDescriptor)
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        do {
          pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
          fatalError(error.localizedDescription)
        }
    }
}

extension Renderer: MTKViewDelegate {
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
  }
  
  func draw(in view: MTKView) {
      // init
      guard let descriptor = view.currentRenderPassDescriptor,
        let commandBuffer = self.commandQueue.makeCommandBuffer(),
        let renderEncoder =
          commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
          return
      }

      
      // draw
      timer += 0.05
      var currentTime = sin(timer)
      renderEncoder.setVertexBytes(&currentTime,
                                    length: MemoryLayout<Float>.stride,
                                    index: 1)
      
      renderEncoder.setRenderPipelineState(pipelineState)
      renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
      for submesh in mesh.submeshes {
        renderEncoder.drawIndexedPrimitives(type: .triangle,
                           indexCount: submesh.indexCount,
                           indexType: submesh.indexType,
                           indexBuffer: submesh.indexBuffer.buffer,
                           indexBufferOffset: submesh.indexBuffer.offset)
      }

      // commit
      renderEncoder.endEncoding()
      guard let drawable = view.currentDrawable else {
        return
      }
      commandBuffer.present(drawable)
      commandBuffer.commit()
  }
}

