//
//  Wave.swift
//  Wave
//
//  Created by zhangxi on 6/23/16.
//  Copyright © 2016 zhangxi.me. All rights reserved.
//

import UIKit

public class Wave : UIView
{
    public var fps:Double         = 30        { didSet{ setupFPS() } }
    public var waveWidth:CGFloat  = 100.0     { didSet{ setupWave() } }
    public var waveHeight:CGFloat = 30.0      { didSet{ setupWave() } }
    public var variance:Int       = 50        { didSet{ variances.removeAll(); setupWave() } }
    public var stokeColor:UIColor = UIColor(red: 190.0/255.0, green: 192.0/255.0, blue: 228.0/255.0, alpha: 1)
    public var fillColor:UIColor  = UIColor(red: 106.0/255.0, green: 175.0/255.0, blue: 230.0/255.0, alpha: 1)
    

    private var timer:NSTimer?
    private var variances = [CGFloat]()
    private var left:CGFloat = 0

    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFPS()

    }
    

    func setupFPS()
    {
        timer?.invalidate()
        timer  = NSTimer.scheduledTimerWithTimeInterval(1.0/fps, target: self, selector: #selector(self.f), userInfo: nil, repeats: true)
        setupWave()
    }
    func setupWave()
    {
        let count = Int(self.frame.size.width / waveWidth) + 2
        for _ in 0 ..< count
        {
            variances.append(CGFloat(arc4random_uniform(UInt32(variance))))
        }
        variances.removeRange(count ..< variances.count)
        self.setNeedsDisplay()
    }
    func f()
    {
        self.setNeedsDisplay()
    }

    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        stokeColor.setStroke()
        fillColor.setFill()
        
        
        CGContextBeginPath(context);
        CGContextMoveToPoint(context,left-waveWidth,self.frame.size.height/2);
        
        
        
        for (x,height) in variances.enumerate()
        {
            let p = CGPointMake(left+waveWidth*CGFloat(x), self.frame.size.height/2)
            var cp1 = p
            cp1.x  -= (3.0/4.0)*waveWidth
            cp1.y  += (waveHeight + CGFloat(variance/2) - height)
            var cp2 = p
            cp2.x  -= waveWidth/4.0
            cp2.y  -= (waveHeight + CGFloat(variance/2) - height)
            
            CGContextAddCurveToPoint(context, cp1.x, cp1.y, cp2.x, cp2.y, p.x, p.y);
        }
        
        CGContextAddLineToPoint(context, left + self.frame.size.width , self.frame.size.height);
        CGContextAddLineToPoint(context, left - waveWidth             , self.frame.size.height);
        CGContextAddLineToPoint(context, left - waveWidth             , self.frame.size.height/2);
        
        left += 1
        
        if left >= waveWidth
        {
            left = 0
            variances.insert(CGFloat(arc4random_uniform(UInt32(variance))), atIndex: 0)
        }
    
        CGContextDrawPath(context,.FillStroke)
    }
}