//
//  PingView.swift
//  OverPing
//
//  Created by Nevyn Bengtsson on 1/8/17.
//  Copyright © 2017 Nevyn Bengtsson. All rights reserved.
//

import Cocoa

class PingView: NSView {
    
    let timeline = CAShapeLayer()
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        self.wantsLayer = true
        timeline.lineCap = .round
        self.layer?.addSublayer(timeline)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: self.bounds.midY))
        path.addLine(to: CGPoint(x: 0, y: self.bounds.midY))
        
        timeline.path = path.copy()
        timeline.strokeColor = CGColor(gray: 0.5, alpha: 1)
        timeline.lineWidth = 8
        
    }
    
    var layerTimeAtStart : CFTimeInterval = 0
    public func startPing()
    {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        timeline.strokeColor = CGColor(gray: 0.5, alpha: 1)
        CATransaction.commit()
        
        timeline.timeOffset = 0;
        timeline.speed = 1.0;
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: self.bounds.midY))
        path.addLine(to: CGPoint(x: 1000, y: self.bounds.midY))
        
        let anim = CABasicAnimation(keyPath: "path")
        anim.toValue = path
        anim.duration = 1.0
        anim.isRemovedOnCompletion = false
        anim.fillMode = .forwards
        
        timeline.add(anim, forKey: "ping")
        
        layerTimeAtStart = timeline.convertTime(CACurrentMediaTime(), from: nil)
    }
    
    public func pongReceived(time: Double)
    {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        // 0.0      0.1     0.7 --->
        // green    yellow  orange
        timeline.strokeColor = time < 0.1 ?
            CGColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1) :
            time < 0.7 ?
                CGColor(red: 1, green: 1, blue: 0, alpha: 1) :
                CGColor(red: 1, green: 0.5, blue: 0, alpha: 1)
        
        CATransaction.commit()
        timeline.speed = 0.0;
        timeline.timeOffset = layerTimeAtStart + (time >= 1 ? 0.99 : time);
    }
    
    public func error()
    {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        timeline.strokeColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        CATransaction.commit()
        
    }
    
    
}
