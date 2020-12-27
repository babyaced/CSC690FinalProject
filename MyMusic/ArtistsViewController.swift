//
//  ArtistsViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 12/24/20.
//

import UIKit
import Foundation

class ArtistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SongCollection.shared.artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistCell", for: indexPath)
        cell.textLabel?.text = SongCollection.shared.artists[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSelectedArtist", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? AlbumsOfSelectedArtistViewController{
            var albums = [SongCollection.Album]()
            for album in SongCollection.shared.albums{
                print("Selected Artist: ", SongCollection.shared.artists[(table.indexPathForSelectedRow?.row)!])
                print("album.value.artist: ", album.value.artist!)
                if(SongCollection.shared.artists[(table.indexPathForSelectedRow?.row)!] == album.value.artist!){
                    albums.append(album.value)
                }
            }
            destVC.selectedArtistAlbums = albums
            destVC.selectedArtistNameLabelString = SongCollection.shared.artists[(table.indexPathForSelectedRow?.row)!]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
