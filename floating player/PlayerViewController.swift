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

enum Direction {
    case up
    case down
    case horizontal
    case none
}

class PlayerViewController: UIViewController {

    weak var window: COLWindow?
    var playerState = PlayerState.minimized {
        didSet {
//            window?.animateToPlayerState(playerState)
            // TODO: Hide buttons depending on state.
//            switch playerState {
//            case .hidden:
//                UIApplication.shared.isStatusBarHidden = false
//            case .minimized:
//                UIApplication.shared.isStatusBarHidden = false
//            case .fullscreen:
//                UIApplication.shared.isStatusBarHidden = true
//            }
        }
    }
    var direction = Direction.none

    
    let headerView = UIView()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Dismiss", for: .normal)
        button.addTarget(self, action: #selector(dismissPlayer(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
    lazy var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        view.backgroundColor = .blue
        headerView.backgroundColor = .red
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
        
        view.addSubview(headerView)
        view.addSubview(dismissButton)
        
        headerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 100)
        dismissButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
    }
    
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        
        // Only handle case when player is minimized. This will make it fullscreen.
        if playerState == .minimized {
            playerState = .fullscreen
            window?.animateToPlayerState(playerState)
        }
    }
    
    @objc
    func handlePan(_ sender: UIPanGestureRecognizer) {
                
        if sender.state == .began {
            
            // 1. User vertically swiping (min/max)
            // 2. User horizontally swiping (min/hidden)
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) < abs(velocity.y) {
                // Check if swiping up or down
                if velocity.y > 0 {
                    self.direction = .down
                }
                else {
                    self.direction = .up
                }
            } else {
                self.direction = .horizontal
            }
        }
            
//        case .changed:
        
        var endState = PlayerState.fullscreen
            switch playerState {
                
            case .minimized:
                
                if self.direction == .horizontal {
                    endState = .hidden
                    window?.handlePan(sender, playerState: endState)
                }
                else if self.direction == .up {
                    endState = .fullscreen
                    window?.handlePan(sender, playerState: endState)
                }
                
            case .fullscreen:
                
                if self.direction == .down {
                    endState = .minimized
                    window?.handlePan(sender, playerState: endState)
                }
                
            default:
                break
            }
            
        if sender.state == .ended {

            window?.animateToPlayerState(endState)
            // check if user dragged enough.
//            self.playerState = endState
//            switch playerState {
//
//            case .hidden:
//                window?.animateToPlayerState(playerState)
//
//            case .minimized:
//                // check if user swiped more than halfway, then complete the animation
//                if self.direction == .horizontal || self.direction == .down {
//                    window?.animateToPlayerState(playerState)
//                }
//
//            case .fullscreen:
//
//                if self.direction == .up {
//                    window?.animateToPlayerState(playerState)
//                }
//
//            }
        }
            
//        default:
//            break
//        }
        
    }
    
    @objc
    func dismissPlayer(_ sender: UIButton) {
        
        if playerState == .fullscreen {
            playerState = .minimized
            window?.playerContainerView.frame = window!.minimizedFrame
        }
        
    }

}
