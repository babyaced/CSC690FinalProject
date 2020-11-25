//
//  MiniPlayerViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/25/20.
//

import UIKit

class MiniPlayerViewController: UIViewController {

    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.songName.text = "Windows"
        self.artistName.text = "Chance the Rapper"
    }
}
