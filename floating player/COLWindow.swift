//
//  COLWindow.swift
//  floating player
//
//  Created by Jitae Kim on 5/6/18.
//  Copyright © 2018 Jitae Kim. All rights reserved.
//

import UIKit

class COLWindow: UIWindow {

    let playerContainerView = UIView()
    let playerVC = PlayerViewController()

//    let hiddenFrame = CGRect(x: -UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

    let hiddenFrame = CGRect(x: -UIScreen.main.bounds.width, y: UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 50, width: 100*16/9, height: 100)
    
    let minimizedFrame = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32) - 50, width: 100*16/9, height: 100)
    
    let fullScreenFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bringSubview(toFront: playerContainerView)
    }
    
    func setupViews() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(playVideo), name: NSNotification.Name.playVideo, object: nil)
        playerVC.window = self
        playerContainerView.backgroundColor = .black
        
        addSubview(playerContainerView)
        
        playerContainerView.frame = hiddenFrame
        
        playerContainerView.addSubview(playerVC.view)
        playerVC.view.frame = playerContainerView.bounds
        
        self.playerContainerView.frame = minimizedFrame
        self.playerVC.playerState = .minimized
        
    }
    
    /**
     Only animate to final state if user has dragged enough
     */
    func animateToPlayerState(_ playerState: PlayerState) {
        
        let duration: TimeInterval = 0.5
        let finalFrame: CGRect
        let dismissButtonHidden: Bool
        
        switch playerState {
            
        case .hidden:
            finalFrame = hiddenFrame
            dismissButtonHidden = true

        case .minimized:
            finalFrame = minimizedFrame
            dismissButtonHidden = true

        case .fullscreen:
            finalFrame = fullScreenFrame
            dismissButtonHidden = false

        }
        
        UIView.animate(withDuration: duration) {
            self.playerVC.dismissButton.isHidden = dismissButtonHidden
            self.playerContainerView.frame = finalFrame
        }
    }
    
    func handlePan(_ sender: UIPanGestureRecognizer, playerState: PlayerState) {
        
        let translation = sender.translation(in: sender.view!)

        switch playerState {
            
        case .hidden:
            
            playerContainerView.center = CGPoint(x: playerContainerView.center.x + translation.x, y: playerContainerView.center.y)
            sender.setTranslation(.zero, in: self)
            
        case .minimized:

            playerContainerView.frame.origin = CGPoint(x: playerContainerView.frame.origin.x, y: max(0, playerContainerView.frame.origin.y + translation.y))
            print(playerContainerView.center.y + translation.y)
            sender.setTranslation(.zero, in: self)
            
        case .fullscreen:
            
            playerContainerView.center = CGPoint(x: playerContainerView.center.x, y: playerContainerView.center.y + translation.y)
            sender.setTranslation(.zero, in: self)
            
        }

    }
    
    @objc
    func playVideo(_ notification: Notification) {
        playerVC.playerState = .fullscreen
        UIView.animate(withDuration: 0.5) {
            self.playerContainerView.frame = self.fullScreenFrame
        }
//        animateToPlayerState(.fullscreen)
        playerContainerView.superview?.bringSubview(toFront: playerContainerView)
    }

}
