//
//  ViewController.swift
//  Wave
//
//  Created by zhangxi on 6/23/16.
//  Copyright © 2016 zhangxi.me. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var wave: Wave!
    
    
    @IBAction func directionChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            wave.direction = .Left
        case 1:
            wave.direction = .Stop
        case 2:
            wave.direction = .Right
        default:
            break;
        }
    }
    
    @IBAction func change(sender: UISlider) {
        
        switch sender.tag
        {
        case 1:
            wave.waveHeight = CGFloat(sender.value)
        case 2:
            wave.waveWidth  = CGFloat(sender.value)
        case 3:
            wave.variance   = Int(sender.value)
        case 4:
            wave.fps        = Double(sender.value)
        default:
            break
        }

    }
    
}

