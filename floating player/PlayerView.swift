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

    let player = AVPlayer(url: URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!)
    let playerLayer = AVPlayerLayer()
    
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
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.insertSublayer(playerLayer, at: 0)
        
        player.play()
        
        
    }

}
