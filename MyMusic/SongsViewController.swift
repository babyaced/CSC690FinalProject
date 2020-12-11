//
//  ViewController.swift
//  MyMusic
//
//  Created by Daniel Simpson on 11/24/20.
//
import UIKit
import UIImageColors




class SongsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return SongCollection.shared.songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        let song = SongCollection.shared.songs[indexPath.row]
        
        //configure
        cell.textLabel?.text = song.trackName
        //cell.textLabel?.textColor = song.colors?.primary
        cell.detailTextLabel?.text = song.artistName
        //cell.detailTextLabel?.textColor = song.colors?.secondary
        cell.imageView?.image = song.art
        //cell.backgroundColor = colors?.background
        
        /*let backgroundView = UIView()
        backgroundView.backgroundColor = song.colors?.background
        cell.selectedBackgroundView = backgroundView*/
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //present the player
        tableView.deselectRow(at: indexPath, animated: true)
        SongPlayer.shared.initQueue(queue: SongCollection.shared.songs, startingPos: indexPath.row)
        SongPlayer.shared.startSong()
    }
}
    




