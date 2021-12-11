//
//  UIMetalViewController.swift
//  MetalPlayground
//
//  Created by Mikita on 11.12.21.
//

import Foundation
import MetalKit

#if os(iOS) || os(watchOS) || os(tvOS)
    import UIKit

    class UIMetalViewController: UIViewController {
        var renderer: Renderer?
        
        override func loadView() {
          self.view = MTKView()
        }
        
        override func viewDidLoad() {
          super.viewDidLoad()
            
        guard let metalView = view as? MTKView else {
              fatalError("metal view not set up in storyboard")
        }
            renderer = Renderer(metalView: metalView)
        }
    }
#endif
