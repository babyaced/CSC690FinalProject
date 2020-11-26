//
//  FullPlayerViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/25/20.
//

import AVFoundation
import UIKit

class FullPlayerViewController: UIViewController {
    
    @IBOutlet var fullPlayerSongLabel: UILabel!
    @IBOutlet var fullPlayerArtistLabel: UILabel!
    @IBOutlet var fullPlayerAlbumArt: UIImageView!
    @IBOutlet var fullPlayerAlbumName: UILabel!
    @IBOutlet var fullPlayerYearOfRelease: UILabel!
    

    
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
        
        if fullPlayerAlbumName != nil{
            fullPlayerAlbumName.text = song.albumName!
        }
        
        
    }
    
    @IBAction func fullPlayerPreviousTrack(_ sender: Any) {
        if SongCollection.shared.position > 0{
            SongCollection.shared.position = SongCollection.shared.position - 1
            SongPlayer.shared.player?.stop()
            fullPlayerSetup()
            SongPlayer.shared.playSong()
        }
    }
    
    @IBAction func fullPlayerPlayPause(_ sender: Any) {
        if SongPlayer.shared.player?.isPlaying == true {
            //pause
            SongPlayer.shared.player?.pause()
        }
        else{
            //play
            SongPlayer.shared.player?.play()
        }
    }
    
    @IBAction func fullPlayerNextTrack(_ sender: Any) {
        if SongCollection.shared.position < (SongCollection.shared.songs.count - 1){
            SongCollection.shared.position = SongCollection.shared.position + 1
            SongPlayer.shared.player?.stop()
            fullPlayerSetup()
            SongPlayer.shared.playSong()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("modal dismissed")
    }
}
