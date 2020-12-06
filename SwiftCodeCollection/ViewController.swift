//
//  ViewController.swift
//  SwiftCodeCollection
//
//  Created by 张鸿运 on 2020/12/5.
//

import UIKit

struct Song: Codable {
    var title: String
    var artist: String
    public static let song = Song(title: "Title", artist: "artist")
}

class ViewController: UIViewController {

    @UserDefaultEncoded(key: "songs", default: [])
    var songs: [Song]
    override func viewDidLoad() {
        super.viewDidLoad()
        songs = [.song, .song]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(songs)
    }
}

