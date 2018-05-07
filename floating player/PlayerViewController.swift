//
//  PlayerViewController.swift
//  floating player
//
//  Created by Jitae Kim on 5/6/18.
//  Copyright © 2018 Jitae Kim. All rights reserved.
//

import UIKit

enum PlayerState {
    case hidden
    case minimized
    case fullscreen
}

class PlayerViewController: UIViewController {

    weak var window: COLWindow?
    var playerState = PlayerState.hidden {
        didSet {
            window?.animateToPlayerState(playerState)
            // TODO: Hide buttons depending on state.
        }
    }
    
    let headerView = UIView()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissPlayer(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        view.backgroundColor = .blue
        headerView.backgroundColor = .red
        view.addGestureRecognizer(tapGesture)
        
        view.addSubview(headerView)
        view.addSubview(dismissButton)
        
        headerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 100)
        dismissButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 50, heightConstant: 50)
    }
    
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        
        // Only handle case when player is minimized. This will make it fullscreen.
        if playerState == .minimized {
            playerState = .fullscreen
        }
    }
    
    @objc
    func dismissPlayer(_ sender: UIButton) {
        
        if playerState == .fullscreen {
            playerState = .minimized
        }
        
    }

}
