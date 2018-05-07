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
    
    let hiddenFrame = CGRect(x: -UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    
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
        
        playerVC.window = self
        playerContainerView.backgroundColor = .black
        
        addSubview(playerContainerView)
        
        playerContainerView.frame = hiddenFrame
        
        playerContainerView.addSubview(playerVC.view)
        playerVC.view.frame = playerContainerView.bounds
        
        self.playerContainerView.frame = minimizedFrame
        self.playerVC.playerState = .minimized
        
    }
    
    func animateToPlayerState(_ playerState: PlayerState) {
        
        let duration: TimeInterval = 1
        switch playerState {
        case .hidden:
            UIView.animate(withDuration: duration) {
                self.playerContainerView.frame = self.hiddenFrame
            }
        case .minimized:
            UIView.animate(withDuration: duration) {
                self.playerContainerView.frame = self.minimizedFrame
            }
        case .fullscreen:
            UIView.animate(withDuration: duration) {
                self.playerContainerView.frame = self.fullScreenFrame
            }
        }
    }
    
    func playVideo() {
        playerContainerView.superview?.bringSubview(toFront: playerContainerView)
    }

}
