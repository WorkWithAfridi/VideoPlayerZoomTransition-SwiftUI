//
//  VideoDetailView.swift
//  ZoomTransitions
//
//  Created by Khondakar Afridi on 27/12/24.
//

import SwiftUI
import AVKit

struct VideoDetailView: View {
    var video: VideoModel
    var animation: Namespace.ID
    @Environment(SharedModel.self) private var sharedModel
    
    /// View Properties
    @State private var hidesThumbnail: Bool = false
    
    @State private var scrollID: UUID?
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            Color.black
            
            ScrollView{
                LazyVStack(spacing: 0){
                    ForEach(sharedModel.videos){
                        video in
                        VideoPlayerView(video: video)
                            .frame(width: size.width, height: size.height)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $scrollID)
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .zIndex(hidesThumbnail ? 1 : 0)
            if let thumbnail = video.thumbnailUrl, !hidesThumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 15))
                    .task {
                        scrollID  = video.id
                        try? await Task.sleep(for: .seconds(0.15))
                        hidesThumbnail = true
                    }
            }
        }
        .ignoresSafeArea()
        .navigationTransition(.zoom(sourceID: hidesThumbnail ? scrollID ?? video.id : video.id, in: animation))
    }
}


struct VideoPlayerView: View{
    var video: VideoModel
    @State private var player: AVPlayer?
    var body: some View{
        CustomVideoPlayerView(player: $player)
            .onAppear {
                guard player == nil else { return }
                player = AVPlayer(url: video.fileUrl)
            }
            .onScrollVisibilityChange { isVisible in
                if isVisible {
                    player?.play()
                } else {
                    player?.pause()
                }
            }
            .onGeometryChange(for: Bool.self) { proxy in
                let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
                let height = proxy.size.height * 0.97
                
                return  -minY > height || minY > height
            } action: { newValue in
                if newValue {
                    player?.seek(to: .zero)
                }
            }
        
    }
}
