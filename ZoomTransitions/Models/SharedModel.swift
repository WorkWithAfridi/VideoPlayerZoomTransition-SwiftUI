//
//  SharedModel.swift
//  ZoomTransitions
//
//  Created by Khondakar Afridi on 27/12/24.
//

import AVKit
import SwiftUI

@Observable
class SharedModel {
    var videos: [VideoModel] = files
    
    func generateThumbnail(for video: Binding<VideoModel>, size: CGSize) async {
        do {
            let asset = AVURLAsset(url: video.wrappedValue.fileUrl)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.maximumSize = size
            generator.appliesPreferredTrackTransform = true
            let cgImage = try await generator.image(at: .zero).image
            guard
                let deviceColorBasedImage = cgImage.copy(
                    colorSpace: CGColorSpaceCreateDeviceRGB()
                )
            else { return }
            
            let thumbnail = UIImage(cgImage: deviceColorBasedImage)
            await MainActor.run {
                video.wrappedValue.thumbnailUrl = thumbnail
            }
        } catch {
            print(error)
        }
    }
}
