//
//  ViewController.swift
//  CollisionDemo
//
//  Created by Jeff Barg on 8/8/15.
//  Copyright © 2015 Jeff Barg. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    var itemViews : [UIView] = []
    
    let motionManager = CMMotionManager()
    let motionQueue = NSOperationQueue()
    
    var animator : UIDynamicAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 1...10 {
            
            let width = arc4random() % 75 + 25
            let height = arc4random() % 75 + 25
            
            let itemView = UIView(
                frame: CGRectMake(
                    CGFloat(self.view.frame.size.width / 2.0),
                    CGFloat(self.view.frame.size.height / 2.0),
                    CGFloat(width),
                    CGFloat(height)
                )
            )
            
            itemView.backgroundColor = UIColor.randomFlatColor()
            itemViews.append(itemView)
            view.addSubview(itemView)
        }
        
        animator = UIDynamicAnimator(referenceView: view)
        
        let gravityBehavior = UIGravityBehavior(items: itemViews)

        motionManager.startDeviceMotionUpdatesToQueue(self.motionQueue, withHandler: {motion, error in
            if error != nil {
                return
            }
            
            guard let gravity = motion?.gravity else {
                return
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                gravityBehavior.gravityDirection = CGVectorMake(
                    CGFloat(gravity.x),
                    CGFloat(-gravity.y)
                )
            }
        })
        
        let collisionBehavior = UICollisionBehavior(items: itemViews)

        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        animator?.addBehavior(gravityBehavior)
        animator?.addBehavior(collisionBehavior)
        
        for item in itemViews {
            let dynamicBehavior = UIDynamicItemBehavior(items: [item])
            
            let area = item.frame.size.width * item.frame.size.height
            dynamicBehavior.elasticity = area / (100 * 100)
            dynamicBehavior.friction = 0.1
            
            animator?.addBehavior(dynamicBehavior)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
