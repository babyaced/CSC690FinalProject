//
//  AlbumsOfArtistsViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 12/24/20.
//

import UIKit

class AlbumsOfSelectedArtistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedArtistAlbums = [SongCollection.Album]()
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(selectedArtistAlbums)
        table.delegate = self
        table.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(selectedArtistAlbums.count)
        return selectedArtistAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistAlbumCell", for: indexPath)
        cell.textLabel?.text = selectedArtistAlbums[indexPath.row].name!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSelectedAlbumOfArtist", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? SelectedAlbumViewController{
            destVC.selectedAlbumSongs = selectedArtistAlbums[(table.indexPathForSelectedRow?.row)!].albumSongs
            table.deselectRow(at: table.indexPathForSelectedRow!, animated: true)
        }
    }
}
