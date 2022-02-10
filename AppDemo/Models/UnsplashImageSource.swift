//
//  UnsplashImageSource.swift
//  AppDemo
//
//  Created by Daniel Bonates on 09/12/21.
//

import Foundation

struct UnsplashImageSource: Codable {
    var id: String
    let regularURL: URL?
    let fullURL: URL?
    let smallURL: URL?
    let thumbURL: URL?

    enum ImageCodingKeys: String, CodingKey {
        case id
        case urls
    }

    // esse enum interno é apenas para descer um nível
    enum URLsKeys: String, CodingKey {
        case regular
        case full
        case small
        case thumb
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: ImageCodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)

        // deep one level
        let urlsSources = try container.nestedContainer(keyedBy: URLsKeys.self, forKey: .urls)

        let regularURL = try urlsSources.decode(String.self, forKey: .regular)
        self.regularURL = URL(string: regularURL)

        let fullURL = try urlsSources.decode(String.self, forKey: .full)
        self.fullURL = URL(string: fullURL)

        let smallURL = try urlsSources.decode(String.self, forKey: .small)
        self.smallURL = URL(string: smallURL)

        let thumbURL = try urlsSources.decode(String.self, forKey: .thumb)
        self.thumbURL = URL(string: thumbURL)
    }

}
