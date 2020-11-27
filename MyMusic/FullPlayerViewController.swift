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
    @IBOutlet var timeRemainingLabel: UILabel!
    @IBOutlet var timeElapsedLabel: UILabel!
    
    var updateMiniPlayerDelegate : UpdateMiniPlayerDelegate!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createObservers()
        fullPlayerSetup()
        var playbackTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateScrubber), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func fullPlayerSetup(){
        let song = SongCollection.shared.songs[SongCollection.shared.position]
        if fullPlayerSongLabel != nil{
            fullPlayerSongLabel!.text = song.name!
            fullPlayerSongLabel.textColor = song.colors?.primary
        }
        if fullPlayerArtistLabel != nil{
            fullPlayerArtistLabel!.text = song.artistName!
            fullPlayerArtistLabel.textColor = song.colors?.secondary
        }
        if fullPlayerAlbumArt != nil{
            fullPlayerAlbumArt!.image = UIImage(named:song.imageName!)
            self.view.backgroundColor = song.colors?.background
        }
        if fullPlayerAlbumName != nil{
            fullPlayerAlbumName.text = song.albumName!
            fullPlayerAlbumName.textColor = song.colors?.secondary
        }
        if let player = SongPlayer.shared.player{
            fullPlayerScrubber.maximumValue = Float(SongPlayer.shared.player?.duration ?? 0)
        }
    }
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(FullPlayerViewController.updateFullPlayerView), name: Notification.Name(rawValue: "dsimpson.sfsu.edu.updatePlayerViewsKey"), object: nil)
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
        timeElapsedLabel.text = convertSecondsToTime(seconds: (Int(Float(SongPlayer.shared.player?.currentTime ?? 0))))
        timeRemainingLabel.text = "-" + convertSecondsToTime(seconds:(Int(fullPlayerScrubber.maximumValue - (Float(SongPlayer.shared.player?.currentTime ?? 0)))))
        
    }
    
    @objc
    func updateFullPlayerView()
    {
        fullPlayerSetup()
    }
    
    func convertSecondsToTime(seconds: Int) -> String{
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
}
