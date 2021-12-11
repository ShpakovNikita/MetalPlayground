//
//  MetalView.swift
//  MetalPlayground
//
//  Created by Mikita on 9.12.21.
//

import SwiftUI

#if os(iOS) || os(watchOS) || os(tvOS)
struct MetalView: UIViewControllerRepresentable {
    func makeNSViewController(context: Context) -> UIMetalViewController {
        UIMetalViewController()
    }
    
    func updateNSViewController(_ uiViewController: UIMetalViewController, context: Context) {
    }
}
#elseif os(macOS)
struct MetalView: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> NSMetalViewController {
        NSMetalViewController()
    }
    
    func updateNSViewController(_ nsViewController: NSMetalViewController, context: Context) {
        
    }
}
#endif

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        MetalView()
    }
}
