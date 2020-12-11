//
//  SongPlayer.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/25/20.
//
import AVFoundation
import Foundation

let updatePlayerViewsToPlayingStatesKey = "dsimpson.sfsu.edu.updatePlayerViewsToPlayingStatesKey"
let updatePlayerViewsToPausedStatesKey = "dsimpson.sfsu.edu.updatePlayerViewsToPausedStatesKey"

class SongPlayer : NSObject, AVAudioPlayerDelegate{
    
    static let shared = SongPlayer()
    
    var player: AVAudioPlayer?
    
    var songQueue = [SongCollection.Song]()
    
    var queueIndex: Int?
    
    func initQueue(queue: [SongCollection.Song], startingPos: Int){
        songQueue = queue
        queueIndex = startingPos
    }
    
    
    func startSong(){
        self.player?.delegate = nil
        let currentSong = songQueue[queueIndex!]
        let urlString = currentSong.path
        //change song and artist name in mini player
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [AVAudioSession.CategoryOptions.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
            guard let urlString = urlString else{
                print("urlString is nil")
                return
            }
                
            player = try AVAudioPlayer(contentsOf:URL(string: urlString)!)
                
            guard let player = player else{
                print("player is nil")
                return
            }
            
            player.delegate = self
            NotificationCenter.default.post(name: Notification.Name(rawValue: updatePlayerViewsToPlayingStatesKey), object: nil, userInfo: ["currentSong": currentSong])
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
        let currentSong = songQueue[queueIndex!]
        NotificationCenter.default.post(name: Notification.Name(rawValue: updatePlayerViewsToPlayingStatesKey), object: nil, userInfo:["currentSong": currentSong])
        player.play()
    }
    
    func pauseSong(){
        guard let player = player else{
            print("player is nil")
            return
        }
        let currentSong = songQueue[queueIndex!]
        NotificationCenter.default.post(name: Notification.Name(rawValue: updatePlayerViewsToPausedStatesKey), object: nil, userInfo:["currentSong": currentSong])
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
    
    func getCurrentTrackLength() -> TimeInterval{
        guard let player = player else{
            print("player is nil")
            return 0
        }
        return player.duration
    }
    
    func isPlaying() ->Bool{
        guard let player = player else{
            print("player is nil")
            return false
        }
        return player.isPlaying
    }
    
    func prevSong(){
        if queueIndex != nil{
            if queueIndex! > 0{
                queueIndex! -= 1
                let currentSong = songQueue[queueIndex!]
                NotificationCenter.default.post(name: Notification.Name(rawValue: updatePlayerViewsToPlayingStatesKey), object: nil,userInfo:["currentSong": currentSong])
                startSong()
            }
        }
        
    }
    
    func nextSong(){
        if queueIndex != nil{
            if queueIndex! < (songQueue.count - 1){
                queueIndex! += 1
                let currentSong = songQueue[queueIndex!]
                NotificationCenter.default.post(name: Notification.Name(rawValue: updatePlayerViewsToPlayingStatesKey), object: nil, userInfo: ["currentSong": currentSong])
               startSong()
            }else{
                let currentSong = songQueue[queueIndex!]
                NotificationCenter.default.post(name: Notification.Name(rawValue: updatePlayerViewsToPausedStatesKey), object: nil, userInfo: ["currentSong": currentSong])
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        nextSong()
    }
    
    func getCurrentSong() -> SongCollection.Song{
        return songQueue[queueIndex ?? 1]
    }
}
