//
//  SongCollection.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/25/20.
//

import UIImageColors
import UIKit
import Foundation

class SongCollection{
    
    static let shared = SongCollection()
    
    let preferredColorQuality = UIImageColorsQuality.low
    
    struct Song{
        let name : String?
        let albumName : String?
        let artistName : String?
        let imageName : String?
        let trackName : String?
        let colors: UIImageColors?
    }
    
    var songs = [Song]()
    var position: Int
    private init(){
        position = -1
        songs.append(Song(name: "Windows",
                          albumName: "10 Day",
                          artistName: "Chance the Rapper",
                          imageName: "cover1",
                          trackName: "song1",
                          colors: (UIImage(named: "cover1")?.getColors(quality: preferredColorQuality))))
        
        songs.append(Song(name: "Intro: Stroke of Genius",
                          albumName: "Festivus",
                          artistName: "Wale",
                          imageName: "cover2",
                          trackName: "song2",
                          colors: (UIImage(named: "cover2")?.getColors(quality: preferredColorQuality))))
        songs.append(Song(name: "Hot Shyt",
                          albumName: "Back to the Feature",
                          artistName: "Wale",
                          imageName: "cover3",
                          trackName: "song3",
                          colors: (UIImage(named: "cover3")?.getColors(quality: preferredColorQuality))))
        songs.append(Song(name: "Windows",
                          albumName: "10 Day",
                          artistName: "Chance the Rapper",
                          imageName: "cover1",
                          trackName: "song1",
                          colors: (UIImage(named: "cover1")?.getColors(quality: preferredColorQuality))))
        
        songs.append(Song(name: "Intro: Stroke of Genius",
                          albumName: "Festivus",
                          artistName: "Wale",
                          imageName: "cover2",
                          trackName: "song2",
                          colors: (UIImage(named: "cover2")?.getColors(quality: preferredColorQuality))))
        songs.append(Song(name: "Hot Shyt",
                          albumName: "Back to the Feature",
                          artistName: "Wale",
                          imageName: "cover3",
                          trackName: "song3",
                          colors: (UIImage(named: "cover3")?.getColors(quality: preferredColorQuality))))
        songs.append(Song(name: "Windows",
                          albumName: "10 Day",
                          artistName: "Chance the Rapper",
                          imageName: "cover1",
                          trackName: "song1",
                          colors: (UIImage(named: "cover1")?.getColors(quality: preferredColorQuality))))
        
        songs.append(Song(name: "Intro: Stroke of Genius",
                          albumName: "Festivus",
                          artistName: "Wale",
                          imageName: "cover2",
                          trackName: "song2",
                          colors: (UIImage(named: "cover2")?.getColors(quality: preferredColorQuality))))
        songs.append(Song(name: "Hot Shyt",
                          albumName: "Back to the Feature",
                          artistName: "Wale",
                          imageName: "cover3",
                          trackName: "song3",
                          colors: (UIImage(named: "cover3")?.getColors(quality: preferredColorQuality))))
        
    }
}
