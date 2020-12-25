//
//  SongCollection.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/25/20.
//

import UIImageColors
import UIKit
import Foundation
import AVFoundation

class SongCollection{
    
    static let shared = SongCollection()
    
    let preferredColorQuality = UIImageColorsQuality.low
    
    struct Song{
        let name : String?
        let albumName : String?
        let artistName : String?
        let art : UIImage?
        let trackName : String?
        var trackNum: Int?
        let trackIndex: Int?
        let colors: UIImageColors?
        let path: String?
        let trackDuration: String?
    }
    
    struct Album{
        var name: String?
        var artist: String?
        var art: UIImage?
        var albumSongs = [Song]()
    }
    
    struct Artist{
        var name: String?
        var albums = [Album]()
    }
    
    var songs = [Song]()
    var albums = [String: Album]()
    var artists = [String]()
    
    private init(){
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        
        do{
            let folder = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            var index = 0;
            
            for file in folder{
                let pathString = file.absoluteString
                var mp3Name : String?
                var mp3Index: Int?
                var trackMeta : String?
                var albumMeta : String?
                var artistMeta : String?
                var artMeta: UIImage?
                var tracknumMeta = 0
                var trackDur: String?
               
                
//                print(pathString)
                if pathString.contains(".mp3")
                {
                    let components = pathString.components(separatedBy: "/")
                    mp3Name = components[components.count-1]
                    mp3Name = mp3Name?.removingPercentEncoding
                    mp3Name = mp3Name?.replacingOccurrences(of: ".mp3", with: "")
                    //print("MP3 NAME: ",mp3Name)
                }
                
                guard let audioPath = Bundle.main.path(forResource: mp3Name, ofType: ".mp3") else{
                    //print("\n")
                    continue
                }
                let playerItem = AVPlayerItem(url: NSURL(fileURLWithPath: audioPath) as URL)
                
                let metadataList = playerItem.asset.metadata as [AVMetadataItem]
//                print(metadataList)
                for item in metadataList {
                        guard let ckey = item.commonKey?.rawValue, let cvalue = item.value else{
                            continue
                        }
//                        print("Key", ckey)
//                        print("Value", cvalue)

                       switch ckey {
                        case "title" : trackMeta = cvalue as? String
                        case "artist": artistMeta = cvalue as? String
                        case "albumName": albumMeta = cvalue as? String
                        case "artwork" where cvalue is Data : artMeta = UIImage(data: cvalue as! Data)
                        default:
                          continue
                       }
                }
                mp3Index = index
                
                trackDur = convertSecondsToTime(seconds: Int(Double(playerItem.asset.duration.value) / Double(playerItem.asset.duration.timescale)))
                var newSong = Song(name: mp3Name, albumName: albumMeta, artistName: artistMeta, art: artMeta, trackName: trackMeta, trackNum: tracknumMeta , trackIndex: mp3Index,colors: (artMeta?.getColors(quality: preferredColorQuality)),path: pathString, trackDuration: trackDur)     
                
                if(mp3Name != nil){
                    songs.append(newSong)
                    index += 1
                    if(albumMeta != nil){
                        if(albums.keys.contains(albumMeta!)){
                            newSong.trackNum = albums[albumMeta!]!.albumSongs.count + 1
                            albums[albumMeta!]!.albumSongs.append(newSong)
                            albums[albumMeta!]!.albumSongs.sort {$0.trackNum ?? 0 < $1.trackNum ?? 0}
                        }
                        else{
                            print(albumMeta!)
                            //Initalize Songs array of album
                            var albumSongs = [Song]()
                            newSong.trackNum = albumSongs.count + 1
                            albumSongs.append(newSong)
                            var newAlbum = Album(name: albumMeta, artist: artistMeta, art: artMeta, albumSongs: albumSongs)
                            
                            //Add New album to dictionary
                            albums[albumMeta!] = newAlbum
                        }
                    }
                    
                    if(artistMeta != nil){
                        if(!artists.contains(artistMeta!))
                        {
                            artists.append(artistMeta!)
                        }
                    }
                }
            }
        }
        catch{
            print("Could not import songs")
        }
        songs.sort{$0.trackName! < $1.trackName!}
        print("Initialized songcollection")
        print(albums)
    }
}

func convertSecondsToTime(seconds: Int) -> String{
    let minutes = seconds / 60
    let seconds = seconds % 60
    return String(format:"%02i:%02i", minutes, seconds)
}
