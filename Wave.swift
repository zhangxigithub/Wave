//
//  Wave.swift
//  Wave
//
//  Created by zhangxi on 6/23/16.
//  Copyright © 2016 zhangxi.me. All rights reserved.
//

import UIKit


public enum WaveDirection
{
    case left
    case stop
    case right
}

open class Wave : UIView
{
    open var fps:        Double  = 30        { didSet{ setup(true) } }
    open var waveWidth:  CGFloat = 100.0     { didSet{ setup()     } }
    open var waveHeight: CGFloat = 30.0      { didSet{ setup()     } }
    open var waveTop:    CGFloat = 0.5       { didSet{ setup(true)     } }
    open var variance:   Int     = 50        { didSet{ setup(true) } }
    open var stokeColor: UIColor = UIColor(red: 190.0/255.0, green: 192.0/255.0, blue: 228.0/255.0, alpha: 1)
    open var fillColor:  UIColor = UIColor(red: 106.0/255.0, green: 175.0/255.0, blue: 230.0/255.0, alpha: 1)

    open var direction:WaveDirection = .right
        {
        didSet{
            switch direction
            {
            case .left:  start()
            case .stop:  timer.invalidate()
            case .right: start()
            }
        }
    }

    fileprivate var timer:Timer!
    fileprivate var variances = [CGFloat]()
    fileprivate var step:CGFloat = 0

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor =  UIColor.white
        setup(true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(true)
    }
    
    func start()
    {
        timer?.invalidate()
        timer  = Timer.scheduledTimer(timeInterval: 1.0/fps, target: self, selector: #selector(self.f), userInfo: nil, repeats: true)
    }
    
    func setup(_ restartTimer:Bool = false)
    {
        if restartTimer
        {
            variances.removeAll()
            start()
        }
        
        let count = Int(self.frame.size.width / waveWidth) + 3
        for _ in 0 ..< count
        {
            variances.append(CGFloat(arc4random_uniform(UInt32(variance))))
        }
        variances.removeSubrange(count ..< variances.count)
        self.setNeedsDisplay()
    }
    func f()
    {
        self.setNeedsDisplay()
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        
        stokeColor.setStroke()
        fillColor.setFill()
        
        //left-top
        let LT = CGPoint(x: step-waveWidth, y: self.frame.size.height/2)
        //right-bottom
        let RB = CGPoint(x: step + waveWidth*CGFloat(variances.count), y: self.frame.size.height)
        
        context.beginPath();
        context.move(to: CGPoint(x: LT.x, y: LT.y));
        
        for (x,height) in variances.enumerated()
        {
            let p = CGPoint(x: step + waveWidth*CGFloat(x), y: self.frame.size.height * (1-waveTop))
            let cp1 = CGPoint(x: p.x - (3.0/4.0)*waveWidth ,y: p.y + (waveHeight + CGFloat(variance/2) - height))
            let cp2 = CGPoint(x: p.x - (1.0/4.0)*waveWidth, y: p.y - (waveHeight + CGFloat(variance/2) - height))
        
            context.addCurve(to:p,control1:cp1,control2:cp2)
        }
        
        context.addLine(to: CGPoint(x: RB.x, y: RB.y));
        context.addLine(to: CGPoint(x: LT.x, y: RB.y));
        context.addLine(to: CGPoint(x: LT.x, y: LT.y));
        
        switch direction {
        case .left:  step -= 1
        case .stop:  break
        case .right: step += 1
        }
        
        if abs(step) >= waveWidth
        {
            switch direction {
            case .left:
                step = 0
                variances.append(CGFloat(arc4random_uniform(UInt32(variance))))
                variances.removeFirst()
            case .right, .stop:
                step = 0
                variances.insert(CGFloat(arc4random_uniform(UInt32(variance))), at: 0)
                variances.removeLast()
            }
        }
        context.drawPath(using: .fillStroke)
    }
}
