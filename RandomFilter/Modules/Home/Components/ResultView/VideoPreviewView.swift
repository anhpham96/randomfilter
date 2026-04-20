//
//  VideoPreviewView.swift
//  RandomFilter
//
//  Created by Pham Nguyen Nhat Anh on 19/4/26.
//


import AVKit
import SwiftUI

struct VideoPreviewView: View {
    let url: URL
    
    @State private var player: AVPlayer
    
    init(url: URL) {
        self.url = url
        _player = State(initialValue: AVPlayer(url: url))
    }

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                player.play()
            }
            .onDisappear {
                player.pause()
            }
    }
}

#Preview {
    VideoPreviewView(url: URL(string: "https://www.w3schools.com/html/mov_bbb.mp4")!)
}

