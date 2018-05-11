//
//  PlayerViewController.swift
//  floating player
//
//  Created by Jitae Kim on 5/6/18.
//  Copyright © 2018 Jitae Kim. All rights reserved.
//

import UIKit
import AVKit

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

class PlayerViewController: UIViewController, UIGestureRecognizerDelegate {

    weak var playerFrameDelegate: TabBarViewController?
    weak var window: COLWindow?
    var playerState = PlayerState.minimized {
        didSet {
//            playerFrameDelegate?.animateToPlayerState(playerState)
            // TODO: Hide buttons depending on state.
            switch playerState {
            case .hidden:
                UIApplication.shared.isStatusBarHidden = false
            case .minimized:
                UIApplication.shared.isStatusBarHidden = false
                dismissButton.isHidden = true
            case .fullscreen:
                UIApplication.shared.isStatusBarHidden = true
                dismissButton.isHidden = false
            }
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
    
    
//    let playerViewController = AVPlayerViewController()
//    let player = AVPlayer(url: URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!)
//    lazy var playerLayer = AVPlayerLayer(player: player)

    let playerView = PlayerView()
    
    func fullScreenVideo() {
        
        playerViewBottomConstraint?.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    var playerViewBottomConstraint: NSLayoutConstraint?
    
    func setupViews() {
        
        playerView.delegate = self
        view.backgroundColor = .black

        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(panGesture)
        tapGesture.delegate = self
        panGesture.delegate = self
        
        view.addSubview(playerView)
        view.addSubview(dismissButton)
        
        playerView.backgroundColor = .black
        
        playerView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, topConstant: 0, leadingConstant: 0, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        let aspectRatioConstraint = NSLayoutConstraint(item: playerView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: playerView, attribute: NSLayoutAttribute.height, multiplier: 16/9, constant: 0)
        playerView.addConstraint(aspectRatioConstraint)
        playerViewBottomConstraint = playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        dismissButton.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: nil, bottom: nil, topConstant: 10, leadingConstant: 10, trailingConstant: 0, bottomConstant: 0, widthConstant: 0, heightConstant: 50)
        

        
//        playerLayer.frame = headerView.bounds
//        headerView.layer.insertSublayer(playerLayer, at: 0)
//        player.play()
        
//        playerViewController.player = player
//
//        addChildViewController(playerViewController)
//
//        headerView.addSubview(playerViewController.view)
//        playerViewController.view.frame = headerView.bounds
//        playerViewController.didMove(toParentViewController: self)

    }
    
    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        
        // Only handle case when player is minimized. This will make it fullscreen.
        if playerState == .minimized {
            playerState = .fullscreen
            playerFrameDelegate?.animateToPlayerState(playerState)
        }
    }
    
    var shouldCompleteTransition = false
    @objc
    func handlePan(_ sender: UIPanGestureRecognizer) {

        guard let playerFrameDelegate = playerFrameDelegate else { return }
        let translation: CGFloat
        // Check player's current state.
        // Only track horizontal/vertical based on the current state.
        switch playerState {
        case .hidden:
            // How is it possible to pan a view that is hidden?
            return
        case .minimized:
            // can be both horizontal (swipe to dismiss) or vertical (maximize to fullscreen)
            let velocity = sender.velocity(in: nil)
            if abs(velocity.x) > abs(velocity.y) {
                self.direction = .horizontal
                translation = sender.translation(in: sender.view!).x
                
            } else {
                // Check if swiping up or down
                translation = sender.translation(in: sender.view!).y
                if velocity.y > 0 {
                    self.direction = .down
                }
                else {
                    self.direction = .up
                }
            }

        case .fullscreen:
            // Only vertical (down?) to minimize
            self.direction = .down
            translation = sender.translation(in: sender.view!).y
            
        }

        guard let superview = sender.view?.superview, let updatedFrame = sender.view?.convert(superview.frame, to: superview) else { return }
//        print(updatedFrame)
//        var progress = translation / 200
//        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        if sender.state == .changed {
            
            switch playerState {
                
            case .hidden:
                return
            case .minimized:
                if self.direction == .horizontal {
                    shouldCompleteTransition = abs(updatedFrame.origin.x - playerFrameDelegate.minimizedFrame.origin.x) > 100
                }
                else {
                    shouldCompleteTransition = (updatedFrame.origin.y - playerFrameDelegate.fullScreenFrame.origin.y)/playerFrameDelegate.minimizedFrame.origin.y < 0.5
                }

            case .fullscreen:
                shouldCompleteTransition = (updatedFrame.origin.y - playerFrameDelegate.fullScreenFrame.origin.y)/playerFrameDelegate.minimizedFrame.origin.y > 0.5
            }
        }
        
        var endState = PlayerState.fullscreen
        switch playerState {
            
        case .minimized:
            
            if self.direction == .horizontal {
                endState = .hidden
                playerFrameDelegate.handlePan(sender, playerState: endState)
            }
            else if self.direction == .up {
                endState = .fullscreen
                playerFrameDelegate.handlePan(sender, playerState: endState)
            }
            
        case .fullscreen:
            
            if self.direction == .down {
                endState = .minimized
                playerFrameDelegate.handlePan(sender, playerState: endState)
            }
            
        default:
            break
        }
        
        if sender.state == .ended {
            if shouldCompleteTransition {
                playerState = endState
                playerFrameDelegate.animateToPlayerState(endState)
            }
            else {
                playerFrameDelegate.animateToPlayerState(playerState)
            }
        }

        
    }
    
    @objc
    func dismissPlayer(_ sender: UIButton) {
        
        if playerState == .fullscreen {
            playerState = .minimized
            UIView.animate(withDuration: 0.5) {
                self.playerFrameDelegate?.playerContainerView.frame = self.playerFrameDelegate!.minimizedFrame
            }
        }
        
    }

}
