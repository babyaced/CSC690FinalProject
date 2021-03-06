//
//  MiniPlayerViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 12/8/20.
//

import UIKit

class MiniPlayerViewController: UIViewController {
    

    
    @IBOutlet var miniPlayerSongLabel: UILabel!
    @IBOutlet var miniPlayerArtistLabel: UILabel!
    
    @IBOutlet var miniPlayerSongProgress: UIProgressView!
    
    override func viewDidLoad() {
        print("MiniPlayerViewController did load")
 
        super.viewDidLoad()
//        self.view.layer.borderWidth = 3
        
        setupMiniPlayer()
        createObservers()

        
//        if traitCollection.userInterfaceStyle == .light{
//            self.view.layer.borderColor = UIColor.darkText.cgColor
//        }
//        else{
//            self.view.layer.borderColor = UIColor.lightText.cgColor
//        }
        if(SongPlayer.shared.isPlaying())
        {
            self.view.isUserInteractionEnabled = true
            initMiniPlayerViewToPlayingView()
            updateSongProgress()
        }
        else if SongPlayer.shared.player != nil {
            self.view.isUserInteractionEnabled = true
            initMiniPlayerViewToPausedView()
            updateSongProgress()
        }


        var playbackTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSongProgress), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("MiniPlayerViewController will appear")
        if traitCollection.userInterfaceStyle == .light{
            self.view.layer.shadowColor = UIColor.black.cgColor
        }
        else{
            self.view.layer.shadowColor = UIColor.white.cgColor
        }
        
        self.view.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        self.view.layer.shadowOpacity = 0.5
        self.view.layer.shadowRadius = 5.0
        if(SongPlayer.shared.isPlaying())
        {
            self.view.isUserInteractionEnabled = true
            initMiniPlayerViewToPlayingView()
            updateSongProgress()
        }
        else if SongPlayer.shared.player != nil {
            self.view.isUserInteractionEnabled = true
            initMiniPlayerViewToPausedView()
            updateSongProgress()
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    

    
    
    func setupMiniPlayer(){
//        self.view.clipsToBounds = true
//        self.view.layer.cornerRadius = 20
//        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(miniPlayerTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(miniPlayerSwipeLeft))
        swipeLeftRecognizer.direction = .left
        swipeLeftRecognizer.numberOfTouchesRequired = 1
        
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(miniPlayerSwipeRight))
        swipeRightRecognizer.direction = .right
        swipeRightRecognizer.numberOfTouchesRequired = 1
        
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(miniPlayerSwipeUp))
        swipeUpRecognizer.direction = .up
        swipeUpRecognizer.numberOfTouchesRequired = 1
        
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.view.addGestureRecognizer(swipeLeftRecognizer)
        
        self.view.addGestureRecognizer(swipeRightRecognizer)
        
        self.view.addGestureRecognizer(swipeUpRecognizer)
        
        self.view.isUserInteractionEnabled = true
    }
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(MiniPlayerViewController.updateMiniPlayerViewToPlayingView), name: Notification.Name(rawValue: "dsimpson.sfsu.edu.updatePlayerViewsToPlayingStatesKey"), object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(MiniPlayerViewController.updateMiniPlayerViewToPausedView), name: Notification.Name(rawValue: "dsimpson.sfsu.edu.updatePlayerViewsToPausedStatesKey"), object: nil)
    }
    
    @objc
    func miniPlayerTap(_ gesture: UITapGestureRecognizer){
        if SongPlayer.shared.isPlaying() == true {
            //pause
            SongPlayer.shared.pauseSong()
        }
        else{
            //play
            SongPlayer.shared.playSong()
        }
    }
    
    @objc
    func miniPlayerSwipeUp(_ gesture: UISwipeGestureRecognizer){
            guard let vc = storyboard?.instantiateViewController(identifier: "FullPlayer") as? FullPlayerViewController else {
                return
            }
            present(vc, animated: true)
    }
    
    @objc
    func miniPlayerSwipeRight(_ gesture: UISwipeGestureRecognizer){
        SongPlayer.shared.prevSong()
    }
    
    @objc
    func miniPlayerSwipeLeft(_ gesture: UISwipeGestureRecognizer){
        SongPlayer.shared.nextSong()
    }
    
    @objc
    func updateMiniPlayerViewToPlayingView(){
        let song = SongPlayer.shared.getCurrentSong()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = song.colors?.background
        })

        miniPlayerSongLabel.text = song.trackName
        miniPlayerSongLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        miniPlayerArtistLabel.text = song.artistName
        miniPlayerArtistLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        miniPlayerSongLabel.textColor = song.colors?.primary
        miniPlayerArtistLabel.textColor = song.colors?.secondary
        miniPlayerSongProgress.progressTintColor = song.colors?.secondary
    }
    
    func initMiniPlayerViewToPlayingView(){
        let song = SongPlayer.shared.getCurrentSong()
        
        self.view.backgroundColor = song.colors?.background

        miniPlayerSongLabel.text = song.trackName
        miniPlayerSongLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        miniPlayerArtistLabel.text = song.artistName
        miniPlayerArtistLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        miniPlayerSongLabel.textColor = song.colors?.primary
        miniPlayerArtistLabel.textColor = song.colors?.secondary
        miniPlayerSongProgress.progressTintColor = song.colors?.secondary
    }
    
    @objc
    func updateMiniPlayerViewToPausedView(_ animated: Bool = true){
        let textColor : UIColor
        let song = SongPlayer.shared.getCurrentSong()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.backgroundColor = UIColor.systemBackground
        })

        miniPlayerSongLabel.text = song.trackName
        miniPlayerSongLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        miniPlayerArtistLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        miniPlayerArtistLabel.text = song.artistName
        
        if traitCollection.userInterfaceStyle == .light{
            textColor = UIColor.darkText
        }
        else{
            textColor = UIColor.lightText
        }
        miniPlayerSongLabel.textColor = textColor
        miniPlayerArtistLabel.textColor = textColor
        miniPlayerSongProgress.progressTintColor = textColor
    }
    
    func initMiniPlayerViewToPausedView(){
        let textColor : UIColor
        let song = SongPlayer.shared.getCurrentSong()
        
        self.view.backgroundColor = UIColor.systemBackground

        miniPlayerSongLabel.text = song.trackName
        miniPlayerSongLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        miniPlayerArtistLabel.text = song.artistName
        miniPlayerArtistLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        if traitCollection.userInterfaceStyle == .light{
            textColor = UIColor.darkText
        }
        else{
            textColor = UIColor.lightText
        }
        miniPlayerSongLabel.textColor = textColor
        miniPlayerArtistLabel.textColor = textColor
        miniPlayerSongProgress.progressTintColor = textColor
    }
    
    @objc
    func updateSongProgress(){
        if SongPlayer.shared.player != nil{
            let songPercentage = SongPlayer.shared.getPlaybackTime()/SongPlayer.shared.getCurrentTrackLength()
            miniPlayerSongProgress.setProgress(Float(songPercentage), animated: false)
        }else{
            miniPlayerSongProgress.setProgress(0, animated: false)
        }

    }
}
