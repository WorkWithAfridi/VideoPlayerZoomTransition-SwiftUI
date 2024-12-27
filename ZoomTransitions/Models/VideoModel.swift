//
//  VideoModel.swift
//  ZoomTransitions
//
//  Created by Khondakar Afridi on 27/12/24.
//

import SwiftUI

struct VideoModel: Identifiable, Hashable {
    var id: UUID = .init()
    var fileUrl: URL
    var thumbnailUrl: UIImage?
}


let files = [
    URL(filePath: Bundle.main.path(forResource: "video-1", ofType: "mp4") ?? ""),
    URL(filePath: Bundle.main.path(forResource: "video-2", ofType: "mp4") ?? ""),
    URL(filePath: Bundle.main.path(forResource: "video-3", ofType: "mp4") ?? ""),
    URL(filePath: Bundle.main.path(forResource: "video-4", ofType: "mp4") ?? ""),
    URL(filePath: Bundle.main.path(forResource: "video-5", ofType: "mp4") ?? ""),
].compactMap({ VideoModel(fileUrl: $0) })
