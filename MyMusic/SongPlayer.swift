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
    
    func playSong(){
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
            
            player.volume = 0.5
            player.delegate = self
            player.play()
        }
        catch{
            print("error occurred")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool){
        SongCollection.shared.position += 1
        playSong()
    }
}
