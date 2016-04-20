//
//  ViewController.swift
//  my-little-monster
//
//  Created by Eddie Keller on 3/22/16.
//  Copyright © 2016 Eddie Keller. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImage: MonsterImg!
    @IBOutlet weak var heartImage: DragImage!
    @IBOutlet weak var foodImage: DragImage!

    @IBOutlet weak var penalty1: UIImageView!
    @IBOutlet weak var penalty2: UIImageView!
    @IBOutlet weak var penalty3: UIImageView!

    @IBOutlet weak var pinkMonsterImage: PinkMonsterImg!
    
    @IBAction func resetButton(sender: AnyObject) {
        resetGame()
    }
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var currentPenalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        
        penalty1.alpha = DIM_ALPHA
        penalty2.alpha = DIM_ALPHA
        penalty3.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: "onTargetDropped", object: nil)
        
        do {
            
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy{
            currentPenalties += 1
            sfxSkull.play()
            
            if currentPenalties == 1 {
                penalty1.alpha = OPAQUE
                penalty2.alpha = DIM_ALPHA
            } else if currentPenalties == 2 {
                penalty2.alpha = OPAQUE
                penalty3.alpha = DIM_ALPHA
            } else if currentPenalties >= 3 {
                penalty3.alpha = OPAQUE
            } else {
                penalty1.alpha = DIM_ALPHA
                penalty2.alpha = DIM_ALPHA
                penalty3.alpha = DIM_ALPHA
            }
        }
        
        let rand = arc4random_uniform(2) // 0 or 1
        
        if rand == 0 {
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            
            heartImage.alpha = OPAQUE
            heartImage.userInteractionEnabled = true
        } else {
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            
            foodImage.alpha = OPAQUE
            foodImage.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
        
        if currentPenalties >= MAX_PENALTIES {
            gameOver()
        }
        
        
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImage.playDeathAnimation()
        sfxDeath.play()
    }
    
    func resetGame() {
        currentPenalties = 0
        penalty1.alpha = DIM_ALPHA
        penalty2.alpha = DIM_ALPHA
        penalty3.alpha = DIM_ALPHA
        
        startTimer()
        
        monsterImage.playIdleAnimation()
    }

    


}

