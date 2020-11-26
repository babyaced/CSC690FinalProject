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
            player?.stop()
            fullPlayerSetup()
            playSong()
        }
    }
    
    @IBAction func fullPlayerPlayPause(_ sender: Any) {
        if player?.isPlaying == true {
            //pause
            player?.pause()
        }
        else{
            //play
            player?.play()
        }
    }
    
    @IBAction func fullPlayerNextTrack(_ sender: Any) {
        if SongCollection.shared.position < (SongCollection.shared.songs.count - 1){
            SongCollection.shared.position = SongCollection.shared.position + 1
            player?.stop()
            fullPlayerSetup()
            playSong()
        }
    }
    
    func playSong(){
        let song = SongCollection.shared.songs[SongCollection.shared.position]
            
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
            guard let urlString = urlString else{
                print("urlString is nil")
                return
            }
                
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
                
            guard let player = player else{
                print("player is nil")
                return
            }
            player.volume = 0.5
            player.play()
           
        }
        catch{
            print("error occurred")
        }
    }
}
