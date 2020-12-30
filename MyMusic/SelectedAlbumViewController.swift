//
//  SelectedAlbumViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 12/9/20.
//

import UIKit
import AVFoundation

class SelectedAlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var selectedAlbumImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        albumTracksTable.delegate = self
        albumTracksTable.dataSource = self
        selectedAlbumImageView.image = selectedAlbumSongs[0].art
        if traitCollection.userInterfaceStyle == .light{
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.selectedAlbumImageView.bounds
            gradientLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
            gradientLayer.locations = [0.075, 1]
            selectedAlbumImageView.layer.insertSublayer(gradientLayer, at: 0)
            selectedAlbumImageView.layer.shadowColor = UIColor.black.cgColor
        }
        else{
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.selectedAlbumImageView.bounds
            gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
            gradientLayer.locations = [0.075, 1]
            selectedAlbumImageView.layer.insertSublayer(gradientLayer, at: 0)
            selectedAlbumImageView.layer.shadowColor = UIColor.white.cgColor
        }
        
        selectedAlbumImageView.layer.shadowOffset = CGSize(width: -10, height: -10)
        selectedAlbumImageView.layer.shadowOpacity = 1.0
        selectedAlbumImageView.layer.shadowRadius = 100.0

        
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
        cell.detailTextLabel?.text = song.trackDuration

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        print(indexPath.row)
        SongPlayer.shared.initQueue(queue: selectedAlbumSongs, startingPos: indexPath.row)
        SongPlayer.shared.startSong()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
