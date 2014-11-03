//
//  FirstViewController.swift
//  ISB
//
//  Created by Christopher Martin on 11/2/14.
//
//

import UIKit

class FirstViewController: UIViewController {
    
    let soundController = SoundController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchInternet(sender: UIButton) {
        soundController.playInternet()
    }

    @IBAction func touchEat(sender: UIButton) {
        soundController.playEat()
    }
    
    @IBAction func touchBalls(sender: UIButton) {
        soundController.playBalls()
    }
}

