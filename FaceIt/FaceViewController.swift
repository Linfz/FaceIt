//
//  ViewController.swift
//  FaceIt
//
//  Created by YGuan on 5/29/16.
//  Copyright © 2016 YGuan. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView! { didSet { updateUI() } }
    
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Frown){ didSet { updateUI() } }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0,.Grin:0.5,.Smile:1.0,.Smirk: -0.5, .Neutral:0.0]
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed:0.5, .Furrowed:-0.5, .Normal:0.0]
    
    private func updateUI() {
        switch expression.eyes {
        case .Open: faceView.eyesOpen = true
        case .Closed: faceView.eyesOpen = false
        case .Squinting: faceView.eyesOpen = false
        }
        
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
    }

}

