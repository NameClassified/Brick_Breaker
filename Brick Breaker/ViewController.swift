//
//  ViewController.swift
//  Brick Breaker
//
//  Created by Connor Pan on 7/9/15.
//  Copyright © 2015 Connor Pan. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var dynamicAnimator = UIDynamicAnimator()
    var collisionBehavior = UICollisionBehavior()
    
    
    @IBOutlet weak var livesLabel: UILabel!
    
    var paddle = UIView()
    var ball = UIView()
    var brick = UIView()
    var brickCount = 48
    var gameState = ""
    
    
    var lives = 5
    var allObjects : [UIView] = []
    
    var bricks : [UIView] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObjects()
        
            
        }
    func addObjects () {
        
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
        
        
        allObjects.append(paddle)
        allObjects.append(ball)
        
        print("test1")
        
        let width = Int(view.bounds.width)
        let numberofBricks = (width / 40)
        let xOffset = Int(Int(width % 40)/2)
        for var x = 0; x <= numberofBricks; x++  {
            addBrick(((40*x)+(x*xOffset)), y: 20, color: UIColor.blueColor())
            addBrick(((40*x)+(x*xOffset)), y: 45, color: UIColor.orangeColor())
            addBrick(((40*x)+(x*xOffset)), y: 70, color: UIColor.orangeColor())
            addBrick(((40*x)+(x*xOffset)), y: 95, color: UIColor.orangeColor())
            addBrick(((40*x)+(x*xOffset)), y: 120, color: UIColor.greenColor())
            addBrick(((40*x)+(x*xOffset)), y: 145, color: UIColor.greenColor())
    }
        
        
        print("test2")
        print("\(allObjects.count)")
        
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
        let brickDynamicBehavior = UIDynamicItemBehavior(items: bricks)
        brickDynamicBehavior.density = 10000
        brickDynamicBehavior.resistance = 100
        brickDynamicBehavior.allowsRotation = false
        dynamicAnimator.addBehavior(brickDynamicBehavior)
        
        
        
        //creates push for ball
        let pushBehavior = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.pushDirection = CGVectorMake(0.2, 1.0)
        pushBehavior.magnitude = 0.25
        dynamicAnimator.addBehavior(pushBehavior)
        
        print("test5")
        
        //creates collision mechanics
        
        collisionBehavior = UICollisionBehavior(items: allObjects)
        print("test6")
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        print("test7")
        dynamicAnimator.addBehavior(collisionBehavior)
        print("test8")
        
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
                //insert stop/push ball here
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
        for index in bricks {
            if brickCount == 0 {
                gameState = "Win"
                gameEnd()
                ball.removeFromSuperview()
                collisionBehavior.removeItem(ball)
                dynamicAnimator.updateItemUsingCurrentState(ball)
            }
            else {
                if (item1.isEqual(allObjects[1]) && item2.isEqual(index)) || (item2.isEqual(allObjects[1]) && item1.isEqual(index)) {
                    if index.backgroundColor == UIColor.blueColor() {
                        index.backgroundColor = UIColor.orangeColor()
                    }
                    else if index.backgroundColor == UIColor.orangeColor() {
                        index.backgroundColor = UIColor.greenColor()
                    }
                    else {
                        index.hidden = true
                        collisionBehavior.removeItem(index)
                        brickCount--
                        if brickCount == 0 {
                            gameState = "Win"
                            gameEnd()
                            ball.removeFromSuperview()
                            collisionBehavior.removeItem(ball)
                            dynamicAnimator.updateItemUsingCurrentState(ball)
                        }
                    }
                }
            }
        }
        
    }
    
    func addBrick(x: Int, y: Int, color: UIColor) {
        brick = UIView(frame: CGRectMake(CGFloat(x), CGFloat(y), 40, 20))
        brick.backgroundColor = color
        bricks.append(brick)
        allObjects.append(brick)
        view.addSubview(brick)
    }
  
    func reset () {
        self.dismissViewControllerAnimated(false, completion: {});
        self.presentViewController(self, animated: false, completion: nil)
        
        /*
        for index in view.subviews {
            view.removeFromSuperview()
        }
        addObjects()
        lives = 5
        */
    }

    
    func gameEnd () {
        let actionSheet = UIAlertController(title: "\(gameState)", message: "", preferredStyle: .ActionSheet)
        let winAction = UIAlertAction(title: "Reset", style: .Default) { (action) -> Void in
            self.reset()
        }
        let quitAction = UIAlertAction(title: "Quit", style: .Destructive) { (action) -> Void in
            exit(0)
        }
        actionSheet.addAction(winAction)
        actionSheet.addAction(quitAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
}

