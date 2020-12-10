//
//  SelectedAlbumViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 12/9/20.
//

import UIKit

class SelectedAlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedAlbumSongs = [SongCollection.Song]()
    @IBOutlet weak var albumTracksTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedAlbumSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumSongCell", for: indexPath)
        let song = selectedAlbumSongs[indexPath.row]
        print(song.trackName)
        print(song.artistName)
        cell.textLabel?.text = song.trackName
        cell.detailTextLabel?.text = song.artistName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SongCollection.shared.position = selectedAlbumSongs[indexPath.row].trackIndex!
        SongPlayer.shared.startSong()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTracksTable.delegate = self
        albumTracksTable.dataSource = self
        print(selectedAlbumSongs)
    }
    



}
