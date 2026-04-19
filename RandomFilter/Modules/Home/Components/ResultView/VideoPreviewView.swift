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

    var body: some View {
        VideoPlayer(player: AVPlayer(url: url))
            .onAppear {
                AVPlayer(url: url).play()
            }
    }
}