//
//  ViewController.swift
//  FaceIt
//
//  Created by YGuan on 5/29/16.
//  Copyright © 2016 YGuan. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(_:))
                ))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            happierSwipeGestureRecognizer.direction = .Up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            sadderSwipeGestureRecognizer.direction = .Down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            updateUI()
        }
    }
    
    @IBAction func toggleEyes(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    private struct Animation {
        static let ShakeAngle = CGFloat(M_PI / 6)
        static let ShakeDuration = 0.5
    }
    
    @IBAction func headShake(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(
            Animation.ShakeDuration,
            animations: { 
                self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, Animation.ShakeAngle)
            },
            completion: { finished in
                if finished {
                    UIView.animateWithDuration(
                        Animation.ShakeDuration,
                        animations: {
                            self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, -Animation.ShakeAngle * 2)
                        },
                        completion: { finished in
                            if finished {
                                UIView.animateWithDuration(
                                    Animation.ShakeDuration,
                                    animations: {
                                        self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, Animation.ShakeAngle)
                                    },
                                    completion: { finished in
                                        if finished {
                                            
                                        }
                                    }
                                )

                            }
                        }
                    )

                }
            }
        )
        
    }
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Frown){ didSet { updateUI() } }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0,.Grin:0.5,.Smile:1.0,.Smirk: -0.5, .Neutral:0.0]
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed:0.5, .Furrowed:-0.5, .Normal:0.0]
    
    private func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
    
}

