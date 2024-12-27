//
//  ContentView.swift
//  ZoomTransitions
//
//  Created by Khondakar Afridi on 27/12/24.
//

import SwiftUI

struct ContentView: View {
    var sharedModel = SharedModel()
    @Namespace private var animation
    
    var body: some View {
        @Bindable var bindings = sharedModel
        GeometryReader {
            let screenSize: CGSize = $0.size
            NavigationStack{
                VStack(spacing: 0){
                    // Header View
                    HeaderView()
                    ScrollView(.vertical){
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 12), count: 2), spacing: 10){
                            ForEach($bindings.videos){ $video in
                                NavigationLink (value: video) {
                                    CardView(screenSize: screenSize, video: $video)
                                        .environment(sharedModel)
                                        .frame(height: screenSize.height * 0.4)
                                        .matchedTransitionSource(id: video.id, in: animation) {
                                            $0
                                                .background(.clear)
                                                .clipShape(.rect(cornerRadius: 15))
                                        }
                                }
                                .buttonStyle(CustomButtonStyle())
                            }
                        }
                        .padding(15)
                    }
                }
                .navigationDestination(for: VideoModel.self) { video in
                    VideoDetailView(video: video, animation: animation)
                        .environment(sharedModel)
                        .toolbarVisibility(.hidden, for: .navigationBar)
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack{
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
            }
            Spacer(minLength: 0)
            Button {
                
            } label: {
                Image(systemName: "person.fill")
                    .font(.title3)
            }
        }
        .overlay {
            Text("Stories")
                .font(.title3.bold())
        }
        .foregroundStyle(Color.primary)
        .padding(15)
        .background(.ultraThinMaterial)
    }
}

struct CardView: View {
    var screenSize: CGSize
    @Binding var video: VideoModel
    @Environment(SharedModel.self) private var sharedModel
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            if let thumbnailUrl = video.thumbnailUrl {
                Image(uiImage: thumbnailUrl)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 15))
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.fill)
                    .task(priority: .high){
                        await sharedModel.generateThumbnail(for: $video, size: screenSize)
                    }
            }
        }
    }
}

/// Custom Button Style
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
    
}

#Preview {
    ContentView()
}
