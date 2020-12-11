//
//  AlbumsViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 12/8/20.
//
import UIKit
import Foundation

extension Dictionary {
    public subscript(i:Int) -> (key: Key, Value) {
        get{
            return self[index(startIndex,offsetBy: i)]
        }
    }
}

class AlbumsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SongCollection.shared.albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath)
        cell.textLabel?.text = SongCollection.shared.albums[indexPath.row].key
        //cell.textLabel?.textColor = song.colors?.primary
        let tempKey = SongCollection.shared.albums[indexPath.row].key
        cell.detailTextLabel?.text = SongCollection.shared.albums[tempKey]![0].artistName
        //cell.detailTextLabel?.textColor = song.colors?.secondary
        cell.imageView?.image = SongCollection.shared.albums[tempKey]![0].art
        //cell.backgroundColor = colors?.background
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        cell.detailTextLabel?.font = UIFont(name: "Helvetica", size: 17)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showSelectedAlbum", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? SelectedAlbumViewController{
            let temp = SongCollection.shared.albums[(table.indexPathForSelectedRow?.row)!].key
            destVC.selectedAlbumSongs = SongCollection.shared.albums[temp]!
            table.deselectRow(at: table.indexPathForSelectedRow!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
