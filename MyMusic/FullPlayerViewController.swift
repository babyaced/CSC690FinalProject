//
//  FullPlayerViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/25/20.
//

import UIKit

class FullPlayerViewController: UIViewController {
    
    @IBOutlet var fullPlayerSongLabel: UILabel!
    @IBOutlet var fullPlayerArtistLabel: UILabel!
    @IBOutlet var fullPlayerAlbumArt: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullPlayerSetup()
        // Do any additional setup after loading the view.
    }
    
    func fullPlayerSetup(){
        let song = SongCollection.shared.songs[SongCollection.shared.position]
        print(song)
        //print(fullPlayerSongLabel.text)
        
        if fullPlayerSongLabel != nil{
            fullPlayerSongLabel!.text = song.name!
        }
        
        
        
        if fullPlayerArtistLabel != nil{
            fullPlayerArtistLabel!.text = song.artistName!
        }
        
       
        if fullPlayerAlbumArt != nil{
            fullPlayerAlbumArt!.image = UIImage(named:song.imageName!)
        }
        
        
    }


}
