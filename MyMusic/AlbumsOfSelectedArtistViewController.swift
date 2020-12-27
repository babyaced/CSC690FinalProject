//
//  AlbumsOfArtistsViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 12/24/20.
//

import UIKit

class AlbumsOfSelectedArtistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedArtistAlbums = [SongCollection.Album]()
    var selectedArtistNameLabelString: String?
    @IBOutlet var table: UITableView!
    @IBOutlet var navigationItemBackgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(selectedArtistAlbums)
        table.delegate = self
        table.dataSource = self
        self.navigationItem.title = selectedArtistNameLabelString
        navigationItemBackgroundImage.image = selectedArtistAlbums[Int.random(in: 0..<selectedArtistAlbums.count)].art
        
        
        self.view.sendSubviewToBack(navigationItemBackgroundImage)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(selectedArtistAlbums.count)
        return selectedArtistAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistAlbumCell", for: indexPath)
        cell.textLabel?.text = selectedArtistAlbums[indexPath.row].name!
        cell.textLabel
        cell.imageView?.image = selectedArtistAlbums[indexPath.row].art!
        print(selectedArtistAlbums[indexPath.row].year!)
        cell.detailTextLabel?.text = selectedArtistAlbums[indexPath.row].year!
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
