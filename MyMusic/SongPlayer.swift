//
//  SongPlayer.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/25/20.
//
import AVFoundation
import Foundation

class SongPlayer : NSObject, AVAudioPlayerDelegate{
    
    static let shared = SongPlayer()
    
    var player: AVAudioPlayer?
    
    func startSong(){
        self.player?.delegate = nil
        let song = SongCollection.shared.songs[SongCollection.shared.position]
            
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        //change song and artist name in mini player
        
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
            
            player.delegate = self
            player.play()
        }
        catch{
            print("error occurred")
        }
    }
    
    func playSong(){
        guard let player = player else{
            print("player is nil")
            return
        }
        player.play()
    }
    
    func pauseSong(){
        guard let player = player else{
            print("player is nil")
            return
        }
        player.pause()
    }
    
    func stopSong(){
        guard let player = player else{
            print("player is nil")
            return
        }
        player.stop()
    }
    
    func scrubSong(time: TimeInterval){
        guard let player = player else{
            print("player is nil")
            return
        }
        stopSong()
        player.currentTime = time
        playSong()
    }
    
    func getPlaybackTime() -> TimeInterval{
        guard let player = player else{
            print("player is nil")
            return 0
        }
        return player.currentTime
    }
    
    func isPlaying() ->Bool{
        guard let player = player else{
            print("player is nil")
            return false
        }
        return player.isPlaying
    }
    
    func prevSong(){
        if SongCollection.shared.position != -1{
            if SongCollection.shared.position > 0{
                SongCollection.shared.position -= 1
                NotificationCenter.default.post(name: Notification.Name(rawValue: updatePlayerViewsKey), object: nil)
                startSong()
            }
        }
        
    }
    
    func nextSong(){
        if SongCollection.shared.position != -1{
            if SongCollection.shared.position < (SongCollection.shared.songs.count - 1){
                SongCollection.shared.position += 1
                NotificationCenter.default.post(name: Notification.Name(rawValue: updatePlayerViewsKey), object: nil)
               startSong()
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        nextSong()
    }
}
