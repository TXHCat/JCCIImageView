//
//  JCCIImageRenderer.swift
//  JCCIImageView
//
//  Created by Jake on 2018/7/24.
//  Copyright © 2018 Jake. All rights reserved.
//

import UIKit
import MetalKit
import GLKit

typealias JCView = UIView

protocol JCCIImageRenderer {
    func renderImage(_ image:CIImage?);
    var view : UIView { get }
    var context : CIContext? { get set }
}

class JCCIImageMetalRenderer: NSObject, JCCIImageRenderer, MTKViewDelegate{
    typealias View = MTKView
    
    private var _view : MTKView!
    var view: UIView{
        get {
            return _view
        }
    }
    
    var context: CIContext?
    
    private var device : MTLDevice!
    private var commandQueue: MTLCommandQueue?
    private var image : CIImage?
    
    init(_ device:MTLDevice) {
        super.init()
        self.device = device
        self._view = MTKView(frame: CGRect.zero, device: device)
        self._view.clearColor = MTLClearColorMake(0, 0, 0, 0)
        self._view.backgroundColor = UIColor.clear
        
        self._view.delegate = self
        self._view.framebufferOnly = false
        self._view.enableSetNeedsDisplay = true
        
        self.context = CIContext(mtlDevice: device, options: [kCIContextWorkingColorSpace:CGColorSpaceCreateDeviceRGB()])
        self.commandQueue = device.makeCommandQueue()
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = self.commandQueue?.makeCommandBuffer(),
            let currentDrawable = self._view.currentDrawable,
            let ciimage = self.image else {
            return
        }
        let outputTexture = currentDrawable.texture
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        self.context?.render(ciimage, to: outputTexture, commandBuffer: commandBuffer, bounds: ciimage.extent, colorSpace: colorSpace)
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        view.setNeedsDisplay()
    }
    
    func renderImage(_ image: CIImage?) {
        self.image = image
        self.view.setNeedsDisplay()
    }
}


class JCCIImageGLKRenderer: NSObject, JCCIImageRenderer, GLKViewDelegate {
    typealias View = GLKView
    
    private var _view : GLKView!
    var view : UIView {
        get {
            return _view
        }
    }
    
    var context: CIContext?
    
    private var image : CIImage?
    
    init(_ GLContext:EAGLContext) {
        super.init()
        self.context = CIContext(eaglContext: GLContext, options: [kCIContextWorkingColorSpace : CGColorSpaceCreateDeviceRGB()])
        self._view = GLKView(frame: CGRect.zero, context: GLContext)
        self._view.delegate = self
        self._view.contentScaleFactor = UIScreen.main.scale
    }
    
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        guard let ciimage = self.image else {
            return
        }
        glClearColor(0, 0, 0, 0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        let size = rect.size.applying(CGAffineTransform(scaleX: self.view.contentScaleFactor, y: self.view.contentScaleFactor))
        self.context?.draw(ciimage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height), from: ciimage.extent)
    }
    
    func renderImage(_ image: CIImage?) {
        self.image = image
        self.view.setNeedsDisplay()
    }
}


class JCCIImageCoreGraphicsRenderer: NSObject, JCCIImageRenderer {
    private var _view : UIImageView!
    var view : UIView {
        get {
            return _view
        }
    }
    
    var context: CIContext?
    
    override init() {
        super.init()
        self._view = UIImageView(frame: CGRect.zero)
        self.context = CIContext(options: [kCIContextWorkingColorSpace:CGColorSpaceCreateDeviceRGB()])
    }
    
    func renderImage(_ image: CIImage?) {
        guard let ciimage = image,
            let outputImage = self.context?.createCGImage(ciimage, from: ciimage.extent) else {
            return
        }
        
        let result = UIImage(cgImage: outputImage)
        self._view.image = result
    }
}
