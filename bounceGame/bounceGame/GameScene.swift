//
//  GameScene.swift
//  bounceGame
//
//  Created by 翁培钧 on 2019/12/22.
//  Copyright © 2019 翁培钧. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -0.01)
//        physicsWorld.speed = 5
        physicsWorld.contactDelegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentCreated = false
    
    override func didMove(to view: SKView) {
        if !contentCreated {
            createContent()
            contentCreated = true
        }
    }
    
    private func createContent() {
        for row in 0..<5 {
            let ball = Ball(circleOfRadius: 10)
            ball.fillColor = .red
            addChild(ball)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
            ball.physicsBody?.applyForce(CGVector(dx: 600 + CGFloat(row) * 0.1, dy: 600))
            ball.position = CGPoint(x: size.width / 2, y: 400)
            ball.physicsBody?.categoryBitMask = BitMask.Ball
            ball.physicsBody?.contactTestBitMask = BitMask.Box
            ball.physicsBody?.collisionBitMask = BitMask.Box
            ball.physicsBody?.usesPreciseCollisionDetection = true;
            ball.physicsBody?.linearDamping = 0
            ball.physicsBody?.restitution = 1.0
        }
        
        for row in 0..<5 {
            let box = Box(rectOf: CGSize(width: 50, height: 50))
            box.position = CGPoint(x: 50 + (row * 50 + 20), y: (800 - row * 50 + 20))
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
            box.physicsBody?.categoryBitMask = BitMask.Box
            box.physicsBody?.contactTestBitMask = BitMask.Ball
            box.physicsBody?.collisionBitMask = BitMask.Box
            box.physicsBody?.linearDamping = 0
            box.physicsBody?.restitution = 1.0
            box.physicsBody?.isDynamic = false
            box.fillColor = .red
            
            let label = Label(text: "\(row + 1)")
            label.fontSize = 22
            label.typoTag = 666
            label.fontName = "Arial-BoldMT"
            label.color = .white
            label.position = CGPoint(x: 0, y: -label.frame.size.height / 2)
            box.addChild(label)
            
            addChild(box)
        }
        
        let ground = SKSpriteNode(color: .gray, size: CGSize(width: size.width, height: 200))
        ground.position = CGPoint(x: size.width / 2, y: ground.size.height / 2)
        addChild(ground)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
//        ground.physicsBody?.linearDamping = 0
        ground.physicsBody?.collisionBitMask = BitMask.Ground
        ground.physicsBody?.categoryBitMask = BitMask.Ground
        ground.physicsBody?.contactTestBitMask = BitMask.Ground
        
        let wall = SKNode()
        wall.position = CGPoint(x: 0, y: 0)
        wall.physicsBody?.friction = 0
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.restitution = 1.0
        wall.physicsBody?.collisionBitMask = BitMask.Ground
        wall.physicsBody?.categoryBitMask = BitMask.Ground
        wall.physicsBody?.contactTestBitMask = BitMask.Ground
        wall.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        addChild(wall)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        print("\(contact.bodyA.contactTestBitMask) == \(contact.bodyB.contactTestBitMask)")
        
        
        switch contact.bodyA.categoryBitMask {
        case BitMask.Box:
            checkNodeIsBox(contact.bodyA.node)
            
        default:
            break
        }
        
        switch contact.bodyB.categoryBitMask {
        case BitMask.Box:
            checkNodeIsBox(contact.bodyB.node)
            
        default:
            break
        }
    }
}

extension GameScene {
    private func checkNodeIsBox(_ node: SKNode?) {
        guard let box = node else { return }
        
        if box.physicsBody?.categoryBitMask == BitMask.Box {
            let label = box.children.first! as! Label
            var tag = Int(label.text!)!
            if (tag > 0) {
                tag -= 1
                label.text = "\(tag)"
            } else {
                box.removeFromParent()
            }
        }
    }
}
