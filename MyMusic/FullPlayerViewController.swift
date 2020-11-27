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
        updateFullPlayerView()
        var playbackTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateScrubber), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func fullPlayerSetup(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(fullPlayerTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(fullPlayerSwipeLeft))
        swipeLeftRecognizer.direction = .left
        swipeLeftRecognizer.numberOfTouchesRequired = 1
        
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(fullPlayerSwipeRight))
        swipeRightRecognizer.direction = .right
        swipeRightRecognizer.numberOfTouchesRequired = 1
        
        
        self.fullPlayerAlbumArt.addGestureRecognizer(tapRecognizer)
        
        self.fullPlayerAlbumArt.addGestureRecognizer(swipeLeftRecognizer)
        
        self.fullPlayerAlbumArt.addGestureRecognizer(swipeRightRecognizer)
        
        self.fullPlayerAlbumArt.isUserInteractionEnabled = true
    }
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(FullPlayerViewController.updateFullPlayerView), name: Notification.Name(rawValue: "dsimpson.sfsu.edu.updatePlayerViewsKey"), object: nil)
    }
    
    @IBAction func fullPlayerScrub(_ sender: Any) {
        SongPlayer.shared.scrubSong(time: TimeInterval(fullPlayerScrubber.value))
    }
    @objc
    func updateScrubber(){
        fullPlayerScrubber.value = Float(SongPlayer.shared.getPlaybackTime())
        timeElapsedLabel.text = convertSecondsToTime(seconds: (Int(Float(SongPlayer.shared.player?.currentTime ?? 0))))
        timeRemainingLabel.text = "-" + convertSecondsToTime(seconds:(Int(fullPlayerScrubber.maximumValue - (Float(SongPlayer.shared.player?.currentTime ?? 0)))))
    }
    
    @objc
    func updateFullPlayerView()
    {
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
        timeElapsedLabel.textColor = song.colors?.secondary
        timeRemainingLabel.textColor = song.colors?.secondary
        
        fullPlayerScrubber.tintColor = song.colors?.secondary
    }
    
    func convertSecondsToTime(seconds: Int) -> String{
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    @objc
    func fullPlayerTap(_ gesture: UITapGestureRecognizer){
        if SongPlayer.shared.isPlaying() == true {
            SongPlayer.shared.pauseSong()
        }
        else{
            SongPlayer.shared.playSong()
        }
    }
    
    @objc
    func fullPlayerSwipeRight(_ gesture: UISwipeGestureRecognizer){
        SongPlayer.shared.prevSong()
    }
    
    @objc
    func fullPlayerSwipeLeft(_ gesture: UISwipeGestureRecognizer){
        SongPlayer.shared.nextSong()
    }
}
