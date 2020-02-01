//
//  ViewController.swift
//  Toonkung
//
//  Created by Kanokporn Wongwaitayakul on 29/1/2563 BE.
//  Copyright © 2563 Kanokporn Wongwaitayakul. All rights reserved.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let emoji = "\u{1F928}"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.titleLabel.text = "TOONKUNG"
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "WelcomeToTimeline", sender: self)
        }
        
    }
}

