//
//  SelectedAlbumViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 12/9/20.
//

import UIKit

class SelectedAlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTracksTable.delegate = self
        albumTracksTable.dataSource = self
//        print(selectedAlbumSongs)
    }
    
    var selectedAlbumSongs = [SongCollection.Song]()
    
    @IBOutlet weak var albumTracksTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedAlbumSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumSongCell", for: indexPath)
        let song = selectedAlbumSongs[indexPath.row]
//        print(song.artistName)
        cell.textLabel?.text = song.trackName
        cell.detailTextLabel?.text = song.artistName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        print(indexPath.row)
        SongPlayer.shared.initQueue(queue: selectedAlbumSongs, startingPos: indexPath.row)
        SongPlayer.shared.startSong()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
