//
//  ImageScrollViewNew.swift
//  VideoApp
//
//  Created by Lauren on 10/6/20.
//  Copyright © 2020 VideoApp. All rights reserved.
//

import UIKit
import AVKit

protocol MovableMediaDelegate: class {
    func didTap(on imageTag: Int)
}

class ImageScrollView: UIScrollView {
    
    weak var movableMediaDelegate: MovableMediaDelegate?
    
    public enum assetType {
        case image
        case video
    }
    
    public var isTapEnabled = true
    public var plusView: UIView?
    public var type: assetType?
    
    public var zoomView: MovableView? = nil

    private var dragInteraction: UIDragInteraction!
    private var dropInteraction: UIDropInteraction!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var doubleTapGestureRecognizer: UITapGestureRecognizer!
    private var imageSize: CGSize = CGSize.zero
    private var pointToCenterAfterResize: CGPoint = CGPoint.zero
    private var scaleToRestoreAfterResize: CGFloat = 1.0
    private var maxScaleFromMinScale: CGFloat = 3.0

    override var frame: CGRect {
        willSet {
            if !frame.equalTo(newValue) && !newValue.equalTo(.zero) && !imageSize.equalTo(.zero) {
                prepareToResize()
            }
        }
        
        didSet {
            if !frame.equalTo(oldValue) && !frame.equalTo(.zero) && !imageSize.equalTo(.zero) {
                recoverFromResizing()
            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    deinit {
        delegate = nil
    }
    
    private func commonInit() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        decelerationRate = .fast
        delegate = self
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
        
        //configure upon initialisation instead of upon orientation change
        // TODO: Check if can remove
        self.configureImageForSize(self.imageSize)
    }
    
    private func adjustFrameToCenter() {
        guard let unwrappedZoomView = zoomView else {
            return
        }
        
        var frameToCenter = unwrappedZoomView.frame
        
        // center horizontally
        if frameToCenter.size.width < bounds.width {
            frameToCenter.origin.x = (bounds.width - frameToCenter.size.width) / 2
        }
        else {
            frameToCenter.origin.x = 0
        }
        
        // center vertically
        if frameToCenter.size.height < bounds.height {
            frameToCenter.origin.y = (bounds.height - frameToCenter.size.height) / 2
        }
        else {
            frameToCenter.origin.y = 0
        }
        
        unwrappedZoomView.frame = frameToCenter
    }
    
    private func prepareToResize() {
        let boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        pointToCenterAfterResize = convert(boundsCenter, to: zoomView)
        
        scaleToRestoreAfterResize = zoomScale
        
        // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
        // allowable scale when the scale is restored.
        if scaleToRestoreAfterResize <= minimumZoomScale + CGFloat(Float.ulpOfOne) {
            scaleToRestoreAfterResize = 0
        }
    }
    
    private func recoverFromResizing() {
        setMaxMinZoomScalesForCurrentBounds()
        
        // restore zoom scale, first making sure it is within the allowable range.
        let maxZoomScale = max(minimumZoomScale, scaleToRestoreAfterResize)
        zoomScale = min(maximumZoomScale, maxZoomScale)
        
        // restore center point, first making sure it is within the allowable range.
        
        // convert our desired center point back to our own coordinate space
        let boundsCenter = convert(pointToCenterAfterResize, to: zoomView)
        
        // calculate the content offset that would yield that center point
        var offset = CGPoint(x: boundsCenter.x - bounds.size.width/2.0, y: boundsCenter.y - bounds.size.height/2.0)
        
        // restore offset, adjusted to be within the allowable range
        let maxOffset = maximumContentOffset()
        let minOffset = minimumContentOffset()
        
        var realMaxOffset = min(maxOffset.x, offset.x)
        offset.x = max(minOffset.x, realMaxOffset)
        
        realMaxOffset = min(maxOffset.y, offset.y)
        offset.y = max(minOffset.y, realMaxOffset)
        
        contentOffset = offset
    }
    
    private func maximumContentOffset() -> CGPoint {
        return CGPoint(x: contentSize.width - bounds.width,y:contentSize.height - bounds.height)
    }
    
    private func minimumContentOffset() -> CGPoint {
        return CGPoint.zero
    }
    
    // MARK: - Set up
    
    public func setup() {
        var topSupperView = superview

        while topSupperView?.superview != nil {
            topSupperView = topSupperView?.superview
        }
        
        topSupperView?.layoutIfNeeded()
    }
    
    // MARK: - Display image
    
    public func display(image: UIImage) {
        self.type = .image
        
        if let zoomView = zoomView {
            zoomView.removeFromSuperview()
        }

        zoomView = MovableView(image: image)
        
        plusView?.isHidden = true

        addSubview(zoomView!)
        
        // TODO: Follow the video display style?
        configureImageForSize(image.size)
    }
    
    public func display(video: AVAsset) {
        self.type = .video
        
        if let zoomView = zoomView {
            zoomView.removeFromSuperview()
        }
        
        zoomView = MovableView(video: video)

        plusView?.isHidden = true
        
        addSubview(zoomView!)
        
        configureImageForSize(zoomView!.previewImageView!.image!.size)
    }
    
    public func removeMediaView() {
        zoomView?.removeFromSuperview()
        zoomView = nil
        plusView?.isHidden = false
    }
    
    private func configureImageForSize(_ size: CGSize) {
        imageSize = size
        contentSize = imageSize
        setMaxMinZoomScalesForCurrentBounds()
        
        zoomScale = minimumZoomScale
        
        let xOffset = contentSize.width < bounds.width ? 0 : (contentSize.width - bounds.width)/2
        let yOffset = contentSize.height < bounds.height ? 0 : (contentSize.height - bounds.height)/2

        contentOffset = CGPoint(x: xOffset, y: yOffset)
    }
    
    private func setMaxMinZoomScalesForCurrentBounds() {
        // calculate min/max zoomscale
        let xScale = bounds.width / imageSize.width    // the scale needed to perfectly fit the image width-wise
        let yScale = bounds.height / imageSize.height   // the scale needed to perfectly fit the image height-wise
        
        var minScale: CGFloat = 1
        
        minScale = max(xScale, yScale)
        let maxScale = maxScaleFromMinScale * minScale
        
        // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
        if minScale > maxScale {
            minScale = maxScale
        }
        
        maximumZoomScale = maxScale
        minimumZoomScale = minScale
    }
}

extension ImageScrollView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (gestureRecognizer == self.tapGestureRecognizer && otherGestureRecognizer == self.doubleTapGestureRecognizer)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if isTapEnabled {
            movableMediaDelegate?.didTap(on: self.tag)
        }
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustFrameToCenter()
    }
    
}

