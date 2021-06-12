//
//  PodcastData.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/30/21.
//

import FeedKit
import Foundation
import SwiftDate

struct PodcastEpisode: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var date: DateInRegion
    var imageURL: URL?
    var audioURL: URL?
    
    var dateString: String {
        self.date.toFormat(DATE_FORMAT)
    }
    
    static func ==(lhs: PodcastEpisode, rhs: PodcastEpisode?) -> Bool {
        guard let rhs = rhs else { return false }
        return lhs.id == rhs.id
    }
    
    static func !=(lhs: PodcastEpisode, rhs: PodcastEpisode?) -> Bool {
        return !(lhs == rhs)
    }
    
    static var `default`: PodcastEpisode {
        let imageURL = URL(string: "https://d3t3ozftmdmh3i.cloudfront.net/production/podcast_uploaded_nologo/2481705/2481705-1618286836680-cc0bfe519a5a9.jpg")
        let audioURL = URL(string: "https://anchor.fm/s/f635e84/podcast/play/32773030/https%3A%2F%2Fd3ctxlq1ktw2nl.cloudfront.net%2Fproduction%2F2021-4-4%2F182526282-44100-2-80c111c8f86be.m4a")
        return PodcastEpisode(title: "S3E3 - April vacation recap, 4 days a week in person, spring sports, and tik tok drama.", description: "On this weeks episode Freshman Neil Giesser joins the show to talk about his first year at South. Senior Jaden Friedman gives some nfl draft predictions. And the show is wrapped up with our take on tik tok and YouTube news.", date: "Tue, 04 May 2021 01:04:27 GMT".toDate()!, imageURL: imageURL, audioURL: audioURL)
    }
    
    static func fromRSSItem(_ item: RSSFeedItem, defaultImage: URL) -> PodcastEpisode? {
        let imageURL = try? item.iTunes?.iTunesImage?.attributes?.href?.asURL() ?? defaultImage
        guard let imageURL = imageURL else { return nil }
        guard let title = item.title else { return nil }
        guard let desciption = item.description else { return nil }
        guard let date = (item.pubDate.flatMap { DateInRegion($0, region: .UTC) }) else { return nil }
        guard let audioURLString = item.enclosure?.attributes?.url else { return nil }
        guard let audioURL = URL(string: audioURLString) else { return nil }
        return PodcastEpisode(title: title, description: desciption, date: date, imageURL: imageURL, audioURL: audioURL)
    }
}
