//
//  SongCollection.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/25/20.
//

import Foundation

class SongCollection{
    
    static let shared = SongCollection()
    
    struct Song{
        let name : String?
        let albumName : String?
        let artistName : String?
        let imageName : String?
        let trackName : String?
    }
    
    var songs = [Song]()
    var position: Int
    private init(){
        position = 0
        songs.append(Song(name: "Windows",
                          albumName: "10 Day",
                          artistName: "Chance the Rapper",
                          imageName: "cover1",
                          trackName: "song1"))
        
        songs.append(Song(name: "Intro: Stroke of Genius",
                          albumName: "Festivus",
                          artistName: "Wale",
                          imageName: "cover2",
                          trackName: "song2"))
        songs.append(Song(name: "Hot Shyt",
                          albumName: "Back to the Feature",
                          artistName: "Wale",
                          imageName: "cover3",
                          trackName: "song3"))
        songs.append(Song(name: "Windows",
                          albumName: "10 Day",
                          artistName: "Chance the Rapper",
                          imageName: "cover1",
                          trackName: "song1"))
        songs.append(Song(name: "Intro: Stroke of Genius",
                          albumName: "Festivus",
                          artistName: "Wale",
                          imageName: "cover2",
                          trackName: "song2"))
        songs.append(Song(name: "Hot Shyt",
                          albumName: "Back to the Feature",
                          artistName: "Wale",
                          imageName: "cover3",
                          trackName: "song3"))
        songs.append(Song(name: "Windows",
                          albumName: "10 Day",
                          artistName: "Chance the Rapper",
                          imageName: "cover1",
                          trackName: "song1"))
        songs.append(Song(name: "Intro: Stroke of Genius",
                          albumName: "Festivus",
                          artistName: "Wale",
                          imageName: "cover2",
                          trackName: "song2"))
        songs.append(Song(name: "Hot Shyt",
                          albumName: "Back to the Feature",
                          artistName: "Wale",
                          imageName: "cover3",
                          trackName: "song3"))
        
    }
}
