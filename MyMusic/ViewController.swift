//
//  ViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/24/20.
//
import UIKit
import UIImageColors

let updatePlayerViewsToPlayingStatesKey = "dsimpson.sfsu.edu.updatePlayerViewsToPlayingStatesKey"
let updatePlayerViewsToPausedStatesKey = "dsimpson.sfsu.edu.updatePlayerViewsToPausedStatesKey"

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var miniPlayerSongLabel: UILabel!
    @IBOutlet weak var miniPlayerArtistLabel: UILabel!
    
    @IBOutlet var songProgressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("mini player loaded")
        table.delegate = self
        table.dataSource = self
        setupMiniPlayer()
        createObservers()
        var playbackTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSongProgress), userInfo: nil, repeats: true)
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupMiniPlayer(){
        miniPlayerView.clipsToBounds = true
        miniPlayerView.layer.cornerRadius = 20
        miniPlayerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
        
        miniPlayerView.addGestureRecognizer(tapRecognizer)
        
        miniPlayerView.addGestureRecognizer(swipeLeftRecognizer)
        
        miniPlayerView.addGestureRecognizer(swipeRightRecognizer)
        
        miniPlayerView.addGestureRecognizer(swipeUpRecognizer)
        
        miniPlayerView.isUserInteractionEnabled = true
    }
    
    func createObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateMiniPlayerViewToPlayingView), name: Notification.Name(rawValue: "dsimpson.sfsu.edu.updatePlayerViewsToPlayingStatesKey"), object: nil)
        NotificationCenter.default.addObserver(self, selector:  #selector(ViewController.updateMiniPlayerViewToPausedView), name: Notification.Name(rawValue: "dsimpson.sfsu.edu.updatePlayerViewsToPausedStatesKey"), object: nil)
    }
        
    
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return SongCollection.shared.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = SongCollection.shared.songs[indexPath.row]
        
        //configure
        cell.textLabel?.text = song.name
        //cell.textLabel?.textColor = colors?.primary
        cell.detailTextLabel?.text = song.albumName
        //cell.detailTextLabel?.textColor = colors?.secondary
        cell.imageView?.image = UIImage(named: song.imageName!)
        //cell.backgroundColor = colors?.background
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        //present the player
        SongCollection.shared.position = indexPath.row
        updateMiniPlayerViewToPlayingView()
        SongPlayer.shared.startSong()
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
    func miniPlayerSwipeRight(_ gesture: UISwipeGestureRecognizer){
        SongPlayer.shared.prevSong()
    }
    
    @objc
    func miniPlayerSwipeLeft(_ gesture: UISwipeGestureRecognizer){
        SongPlayer.shared.nextSong()
    }
    
    @objc
    func miniPlayerSwipeUp(_ gesture: UISwipeGestureRecognizer){
        if SongCollection.shared.position != -1{
            guard let vc = storyboard?.instantiateViewController(identifier: "Full Player") as? FullPlayerViewController else {
                return
            }
            present(vc, animated: true)
        }
    }
    
    @objc
    func updateMiniPlayerViewToPlayingView(){
        let song = SongCollection.shared.songs[SongCollection.shared.position]
        UIView.animate(withDuration: 0.5, animations: {
            self.miniPlayerView.backgroundColor =  song.colors?.background
        })
        miniPlayerSongLabel.text = song.name
        miniPlayerSongLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        miniPlayerArtistLabel.text = song.artistName
        miniPlayerArtistLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        miniPlayerSongLabel.textColor = song.colors?.primary
        miniPlayerArtistLabel.textColor = song.colors?.secondary
        songProgressView.progressTintColor = song.colors?.secondary
    }
    
    @objc
    func updateMiniPlayerViewToPausedView(){
        let textColor : UIColor
        let song = SongCollection.shared.songs[SongCollection.shared.position]
        
        UIView.animate(withDuration: 0.5, animations: {
            self.miniPlayerView.backgroundColor = UIColor.systemBackground
        })
        miniPlayerSongLabel.text = song.name
        miniPlayerSongLabel.font = UIFont.systemFont(ofSize: 20.0)
        miniPlayerArtistLabel.font = UIFont.systemFont(ofSize: 15.0)
        miniPlayerArtistLabel.text = song.artistName
        
        if traitCollection.userInterfaceStyle == .light{
            textColor = UIColor.darkText
        }
        else{
            textColor = UIColor.lightText
        }
        miniPlayerSongLabel.textColor = textColor
        miniPlayerArtistLabel.textColor = textColor
        songProgressView.progressTintColor = textColor
    }
    
    @objc
    func updateSongProgress(){
        if SongPlayer.shared.player != nil{
            let songPercentage = SongPlayer.shared.getPlaybackTime()/SongPlayer.shared.getCurrentTrackLength()
            songProgressView.setProgress(Float(songPercentage), animated: true)
        }else{
            songProgressView.setProgress(0, animated: false)
        }

    }
}
    




