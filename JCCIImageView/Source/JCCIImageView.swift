//
//  JCCIImageView.swift
//  JCCIImageView
//
//  Created by Jake on 2018/7/24.
//  Copyright © 2018 Jake. All rights reserved.
//

import UIKit
import AVFoundation

public enum JCCIImageContentMode {
    case scaleAspectFit;
    case scaleAspectFill;
    case center;
}

public func JCCIImageViewSuggestedRenderer() -> JCCIImageRenderer {
    if let device = MTLCreateSystemDefaultDevice() {
        return JCCIImageMetalRenderer(device)
    }
    if let glcontext = EAGLContext(api: .openGLES2) {
        return JCCIImageGLKRenderer(glcontext)
    }
    return JCCIImageCoreGraphicsRenderer()
}

fileprivate func JCCIMakeRectWithAspectRatioInsideRect(aspectRatio : CGSize, boundingRect : CGRect) -> CGRect {
    return AVMakeRect(aspectRatio: aspectRatio, insideRect: boundingRect)
}

fileprivate func JCCIMakeRectWithAspectRatioFillRect(aspectRatio:CGSize, boundingRect:CGRect) -> CGRect {
    let horizontalRatio = boundingRect.size.width / aspectRatio.width;
    let verticalRatio = boundingRect.size.height / aspectRatio.height;
    let ratio = max(horizontalRatio, verticalRatio);
    
    let newSize = CGSize(width:floor(aspectRatio.width * ratio),
                         height:floor(aspectRatio.height * ratio))
    let rect = CGRect(x:boundingRect.origin.x + (boundingRect.size.width - newSize.width)/2,
                      y:boundingRect.origin.y + (boundingRect.size.height - newSize.height)/2,
                      width:newSize.width,
                      height:newSize.height);
    return rect;
}

public class JCCIImageView: UIView {
    public var renderer : JCCIImageRenderer?{
        willSet {
            renderer?.view.removeFromSuperview()
        }
        didSet {
            guard let re = renderer else {
                return
            }
            addSubview(re.view)
            re.view.frame = self.bounds.integral
        }
    }
    
    private var _image : CIImage?
    public var image : CIImage? {
        get {
            return _image
        }
        set {
            guard _image != newValue else {
                return
            }
            _image = newValue
            setNeedsLayout()
        }
    }
    
    public var imageContentMode = JCCIImageContentMode.scaleAspectFit {
        didSet {
            setNeedsLayout()
        }
    }
    
    private var scaleFactor : CGFloat {
        return UIScreen.main.nativeScale
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        guard let imageSize = self.image?.extent.size else {
            return
        }
        if imageSize == CGSize.zero || self.bounds.size == CGSize.zero {
            self.renderer?.renderImage(nil)
            return
        }
        switch self.imageContentMode {
        case .scaleAspectFit:
            self.renderer?.view.frame = JCCIMakeRectWithAspectRatioInsideRect(aspectRatio: imageSize,
                                                                              boundingRect: self.bounds).integral
        case .scaleAspectFill:
            self.renderer?.view.frame = JCCIMakeRectWithAspectRatioFillRect(aspectRatio: imageSize,
                                                                            boundingRect: self.bounds).integral
        case .center:
            let viewSize = CGSize(width:imageSize.width / scaleFactor,
                                  height:imageSize.height / scaleFactor);
            self.renderer?.view.frame = CGRect(x:((self.bounds.width) - viewSize.width)/2,
                                               y:((self.bounds.height) - viewSize.height)/2,
                                               width:viewSize.width,
                                               height:viewSize.height).integral;
        }
        self.updateContent()
    }
    
    private func updateContent(){
        renderer?.renderImage(scaleImageForDisplay(image))
    }
    
    private func scaleImageForDisplay(_ ciimage : CIImage?) -> CIImage?{
        guard let image = ciimage else {
            return nil
        }
        let scaleBounds = self.bounds.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
        let imageSize = image.extent.size
        switch self.imageContentMode {
        case .scaleAspectFit:
            let targetRect = JCCIMakeRectWithAspectRatioInsideRect(aspectRatio: imageSize,
                                                                   boundingRect: scaleBounds);
            let horizontalScale = targetRect.size.width/imageSize.width;
            let verticalScale = targetRect.size.height/imageSize.height;
            return image.transformed(by: CGAffineTransform(scaleX: horizontalScale,
                                                           y: verticalScale));
        case .scaleAspectFill:
            let targetRect = JCCIMakeRectWithAspectRatioFillRect(aspectRatio: imageSize,
                                                                 boundingRect: scaleBounds);
            let horizontalScale = targetRect.size.width/imageSize.width;
            let verticalScale = targetRect.size.height/imageSize.height;
            return image.transformed(by: CGAffineTransform(scaleX: horizontalScale,
                                                           y: verticalScale));
        default:
            return image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
