//
//  GameScene.swift
//  Simple Game
//
//  Created by Cooper Richard on 3/9/18.
//  Copyright © 2018 Cooper Richard. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene : SKScene, SKPhysicsContactDelegate {
    
    let duck = SKSpriteNode(imageNamed: "duck.png")
    let gun = SKSpriteNode(imageNamed: "gun.png")
    
    let quack = SKAction.playSoundFileNamed("quack.mp3", waitForCompletion: false)
    
    var spriteSize: CGSize?, bulletSize: CGSize?
    let duckCategory:UInt32 = 0x1 << 0;
    let bulletCategory:UInt32 = 0x1 << 1;
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.cyan
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8);
        physicsWorld.contactDelegate = self
        let spriteDimension = size.width / 10
        spriteSize = spriteSize == nil ? CGSize(width: spriteDimension, height: spriteDimension) : spriteSize
        bulletSize = bulletSize == nil ? CGSize(width: spriteSize!.width / 3, height: spriteSize!.height / 1.5) : bulletSize
        addDuck()
        addGun()
        moveDuck()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        firebullet(touchLocation: touch.location(in: self))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Collision!")
        if (isDuckOrBullet(contact: contact)) {
            run(quack)
        }
    }
    
    private func isDuckOrBullet(contact: SKPhysicsContact) -> Bool  {
        return contact.bodyA.node?.physicsBody?.categoryBitMask == duckCategory
            || contact.bodyB.node?.physicsBody?.categoryBitMask == bulletCategory
    }
    
    private func firebullet(touchLocation: CGPoint) {
        let bullet = SKSpriteNode(imageNamed: "bullet.png")
        bullet.position = gun.position
        bullet.size = bulletSize!
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = bulletCategory
        bullet.physicsBody?.contactTestBitMask = duckCategory | bulletCategory

        let k: CGFloat = 5.0
        let vector = CGVector(dx: k * (touchLocation.x - gun.position.x), dy: k * (touchLocation.y - gun.position.y))
        let sequence = SKAction.sequence([SKAction.move(by: vector, duration: 2.0), SKAction.removeFromParent()])
        addChild(bullet)
        bullet.run(sequence)
    }
    
    private func addDuck() {
        duck.position = CGPoint(x: self.size.width / 2, y: size.height / 2)
        duck.size = spriteSize!
        duck.physicsBody?.categoryBitMask = duckCategory
        duck.physicsBody?.contactTestBitMask = bulletCategory
        duck.physicsBody?.isDynamic = true
        duck.physicsBody = SKPhysicsBody(rectangleOf: duck.frame.size)

        addChild(duck)
    }
    
    private func addGun() {
        gun.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        gun.size = spriteSize!
        addChild(gun)
    }
    
    private func moveDuck() {
        let action1 = SKAction.move(to: CGPoint(x: size.width * 0.1, y: size.height * 0.8), duration: 0)
        let action2 = SKAction.move(to: CGPoint(x: size.width * 0.9, y: size.height * 0.8), duration: 2)
        let action3 = SKAction.move(to: CGPoint(x: size.width * 0.1, y: size.height * 0.8), duration: 2)
        let sequence = SKAction.sequence([action1, action2, action3])
        
        duck.run(SKAction.repeatForever(sequence))
    }
    
}
