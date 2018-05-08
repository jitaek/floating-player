//
//  ViewController.swift
//  floating player
//
//  Created by Jitae Kim on 5/6/18.
//  Copyright © 2018 Jitae Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func playVideo(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.Name.playVideo, object: nil)
//        VideoLauncher.shared.playVideo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

