//
//  VideoLauncher.swift
//  floating player
//
//  Created by Jitae Kim on 5/6/18.
//  Copyright © 2018 Jitae Kim. All rights reserved.
//

import UIKit

/**
 This class will handle animating the frame of the player.
 */
class VideoLauncher: NSObject {
    
    static let shared = VideoLauncher()
    
    let playerContainerView = UIView()
    let playerVC = PlayerViewController()
    
    let hiddenFrame = CGRect(x: -UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    let minimizedFrame = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 50, width: 100*16/9, height: 100)
    
    let fullScreenFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    override init() {
        super.init()
        setupViews()
    }
    
    func setupViews() {
        
        playerContainerView.backgroundColor = .black
        
        if let window = UIApplication.shared.windows.last {
            
            window.addSubview(playerContainerView)
            
            playerContainerView.frame = hiddenFrame
            
            playerContainerView.addSubview(playerVC.view)
            playerVC.view.frame = playerContainerView.bounds
            
            UIView.animateKeyframes(withDuration: 5, delay: 0, options: .calculationModeLinear, animations: {
                
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.playerContainerView.frame = self.fullScreenFrame
                })
                
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    self.playerContainerView.frame = self.minimizedFrame
                })
            }) { (finished) in
                
            }
        }

    }
    
    func playVideo() {
        playerContainerView.superview?.bringSubview(toFront: playerContainerView)
    }
    
}
