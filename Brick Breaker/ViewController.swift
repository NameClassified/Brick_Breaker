//
//  ViewController.swift
//  Brick Breaker
//
//  Created by Connor Pan on 7/9/15.
//  Copyright © 2015 Connor Pan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var dynamicAnimator = UIDynamicAnimator()
    var collisionBehavior = UICollisionBehavior()
    
    @IBOutlet weak var livesLabel: UILabel!
    
    var paddle = UIView()
    var ball = UIView()
    var brick = UIView()
    var lives = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //adds ball
        ball = UIView(frame: CGRectMake(view.center.x - 10, view.center.y, 20, 20))
        ball.backgroundColor = UIColor.whiteColor()
        ball.layer.cornerRadius = 10
        ball.clipsToBounds = true
        view.addSubview(ball)
        
        //adds paddle
        paddle = UIView(frame: CGRectMake(view.center.x - 40, view.center.y * 1.7, 80, 20))
        paddle.backgroundColor = UIColor.cyanColor()
        view.addSubview(paddle)
        
        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        //adds blue brick
        brick = UIView(frame: CGRectMake(20, 20, 40, 20))
        brick.backgroundColor = UIColor.blueColor()
        view.addSubview(brick)
        
        //adds dynamic behavior for ball
        let ballDynamicBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamicBehavior.friction = 0 //friction
        ballDynamicBehavior.resistance = 0 //deceleration over time
        ballDynamicBehavior.elasticity = 1.0 //bounce factor
        ballDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(ballDynamicBehavior)
        
        //adds dynamic paddle behavior
        let paddleDynamicBehavior = UIDynamicItemBehavior(items: [paddle])
        paddleDynamicBehavior.density = 10000
        paddleDynamicBehavior.resistance = 100
        paddleDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(paddleDynamicBehavior)
        
        //adds dynamic behavior for brick
        let brickDynamicBehavior = UIDynamicItemBehavior(items: [brick])
        brickDynamicBehavior.density = 10000
        brickDynamicBehavior.resistance = 100
        brickDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(brickDynamicBehavior)
        
        
        //creates push for ball
        let pushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.pushDirection = CGVectorMake(0.2, 1.0)
        pushBehavior.magnitude = 0.25
        dynamicAnimator.addBehavior(pushBehavior)
        
        //creates collision mechanics
        collisionBehavior = UICollisionBehavior(items: [ball, paddle, brick])
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        dynamicAnimator.addBehavior(collisionBehavior)
        
        livesLabel.text = "Lives: \(lives)"
        
    }
    
    @IBAction func dragPaddle(sender: UIPanGestureRecognizer) {
        let panGesture = sender.locationInView(view)
        paddle.center = CGPointMake(panGesture.x, paddle.center.y)
        dynamicAnimator.updateItemUsingCurrentState(paddle)
    }
    
    //collision behavior for life loss
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        if item.isEqual(ball) && p.y > paddle.center.y {
            lives--
            if lives > 0 {
                livesLabel.text = "Lives: \(lives)"
                ball.center = view.center
                dynamicAnimator.updateItemUsingCurrentState(ball)
            }
            else {
                livesLabel.text = "Game over, pls uninstall"
                ball.removeFromSuperview()
            }
        }
        
    }
    
    //collision behavior delegate for bricks
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        if (item1.isEqual(ball) && item2.isEqual(brick)) || (item2.isEqual(ball) && item1.isEqual(brick)) {
            if brick.backgroundColor == UIColor.blueColor() {
                brick.backgroundColor = UIColor.yellowColor()
            }
            else {
                brick.hidden = true
                collisionBehavior.removeItem(brick)
                livesLabel.text = "You win, +25 MMR"
                ball.removeFromSuperview()
                collisionBehavior.removeItem(ball)
                dynamicAnimator.updateItemUsingCurrentState(ball)
            }
        }
        
    }
    
    
    
}

