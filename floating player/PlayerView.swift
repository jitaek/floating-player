//
//  PlayerView.swift
//  floating player
//
//  Created by Jitae Kim on 5/10/18.
//  Copyright © 2018 Jitae Kim. All rights reserved.
//

import UIKit
import AVKit

class PlayerView: UIView {

    weak var delegate: PlayerViewController?
    
    let player = AVPlayer(url: URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!)
    let playerLayer = AVPlayerLayer()
    
    let centerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 30
        return stackView
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "pause"), for: UIControlState.normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    func setupViews() {
        
        playButton.addTarget(self, action: #selector(didTouchUpInsideButton(_:)), for: .touchUpInside)
        
        addSubview(playButton)
        addSubview(centerStackView)
        
        centerStackView.addArrangedSubview(playButton)
        
        centerStackView.anchorCenterSuperview()
        
        layer.insertSublayer(playerLayer, at: 0)
        playerLayer.player = player
        player.play()
        
        
    }

    @objc
    func didTouchUpInsideButton(_ sender: UIButton) {
        
        switch sender {
            
        case playButton:
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                player.play()
                sender.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
                delegate?.fullScreenVideo()
            }
            else {
                sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
                player.pause()
            }
        default:
            break
        }

    }
}
