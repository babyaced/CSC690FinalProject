//
//  ViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/24/20.
//
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var miniPlayerSongLabel: UILabel!
    @IBOutlet weak var miniPlayerArtistLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("mini player loaded")
        table.delegate = self
        table.dataSource = self
        setupMiniPlayer()
    }
    
    func setupMiniPlayer(){
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
        
    
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return SongCollection.shared.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let song = SongCollection.shared.songs[indexPath.row]
        //configure
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.albumName
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: song.imageName!)
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
        let song = SongCollection.shared.songs[SongCollection.shared.position]
        miniPlayerSongLabel.text = song.name
        miniPlayerArtistLabel.text = song.artistName
        SongPlayer.shared.playSong()
    }
    
    
    
    @objc
    func miniPlayerTap(_ gesture: UITapGestureRecognizer){
        if SongPlayer.shared.player?.isPlaying == true {
            //pause
            SongPlayer.shared.player?.pause()
        }
        else{
            //play
            SongPlayer.shared.player?.play()
        }
    }
    
    @objc
    func miniPlayerSwipeRight(_ gesture: UISwipeGestureRecognizer){
        if SongCollection.shared.position != -1{
            if SongCollection.shared.position > 0{
                SongCollection.shared.position = SongCollection.shared.position - 1
                SongPlayer.shared.player?.stop()
                miniPlayerSongLabel.text = SongCollection.shared.songs[SongCollection.shared.position].name
                miniPlayerArtistLabel.text = SongCollection.shared.songs[SongCollection.shared.position].artistName
                SongPlayer.shared.playSong()
            }
        }
    }
    
    @objc
    func miniPlayerSwipeLeft(_ gesture: UISwipeGestureRecognizer){
        if SongCollection.shared.position != -1{
            if SongCollection.shared.position < (SongCollection.shared.songs.count - 1){
                SongCollection.shared.position = SongCollection.shared.position + 1
                SongPlayer.shared.player?.stop()
                miniPlayerSongLabel.text = SongCollection.shared.songs[SongCollection.shared.position].name
                miniPlayerArtistLabel.text = SongCollection.shared.songs[SongCollection.shared.position].artistName
                SongPlayer.shared.playSong()
            }
        }
    }
    
    @objc
    func miniPlayerSwipeUp(_ gesture: UISwipeGestureRecognizer){
        if SongCollection.shared.position != -1{
            guard let vc = storyboard?.instantiateViewController(identifier: "Full Player") as? FullPlayerViewController else {
                return
            }
            vc.updateMiniPlayerDelegate = self
            present(vc, animated: true)
        }
    }
}

extension ViewController: UpdateMiniPlayerDelegate{
    func changedSong(){
        miniPlayerSongLabel.text = SongCollection.shared.songs[SongCollection.shared.position].name
        miniPlayerArtistLabel.text = SongCollection.shared.songs[SongCollection.shared.position].artistName
    }
}
    




