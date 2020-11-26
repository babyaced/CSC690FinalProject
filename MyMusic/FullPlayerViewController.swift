//
//  FullPlayerViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/25/20.
//

import AVFoundation
import UIKit

let scrubNotificationKey = "dsimpson.sfsu.edu.scrub"

protocol UpdateMiniPlayerDelegate{
    func changedSong()
}

class FullPlayerViewController: UIViewController {
    
    @IBOutlet var fullPlayerSongLabel: UILabel!
    @IBOutlet var fullPlayerArtistLabel: UILabel!
    @IBOutlet var fullPlayerAlbumArt: UIImageView!
    @IBOutlet var fullPlayerAlbumName: UILabel!
    @IBOutlet var fullPlayerYearOfRelease: UILabel!
    
    @IBOutlet var fullPlayerScrubber: UISlider!
    
    var updateMiniPlayerDelegate : UpdateMiniPlayerDelegate!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createObservers()
        fullPlayerSetup()
        var playbackTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateScrubber), userInfo: nil, repeats: true)
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
        
        if let player = SongPlayer.shared.player{
            fullPlayerScrubber.maximumValue = Float(SongPlayer.shared.player?.duration ?? 0)
        }
        
    }
    
    @IBAction func fullPlayerPreviousTrack(_ sender: Any) {
        if SongCollection.shared.position > 0{
            SongCollection.shared.position = SongCollection.shared.position - 1
            SongPlayer.shared.player?.stop()
            fullPlayerSetup()
            updateMiniPlayerDelegate.changedSong()
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
            updateMiniPlayerDelegate.changedSong()
            SongPlayer.shared.playSong()
        }
    }
    
    @IBAction func fullPlayerScrub(_ sender: Any) {
        SongPlayer.shared.player?.stop()
        SongPlayer.shared.player?.currentTime = TimeInterval(fullPlayerScrubber.value)
        SongPlayer.shared.player?.play()
        
    }
    @objc
    func updateScrubber(){
        fullPlayerScrubber.value = Float(SongPlayer.shared.player?.currentTime ?? 0)
    }
}
