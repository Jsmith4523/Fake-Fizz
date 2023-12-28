//
//  FeedStore.swift
//  FizzPlayground
//

/**
 TODO: implement class FeedStore
 1)  use FeedStore as the central source of data
 2)  use some sorting mechanism to sort all feed items
 */
import Foundation
import SwiftUI

class FeedStore: ObservableObject {
    
    @Published private(set) var feedItems: [FeedItem] = [
    FeedItem(handleName: "user1", createdTimestamp: 1702407894, contentText: "Test content", numOfVotes: 50),
    FeedItem(handleName: "user2", createdTimestamp: 1699844694, contentText: "Test content", numOfVotes: 40),
    FeedItem(handleName: "user3", createdTimestamp: 1702350294, contentText: "Test content", numOfVotes: 32),
    FeedItem(handleName: "user4", createdTimestamp: 1702353894, contentText: "Test content", numOfVotes: 55),
    FeedItem(handleName: nil, createdTimestamp: 1702357494, contentText: "Test content", numOfVotes: 60),
    FeedItem(handleName: "user6", createdTimestamp: 1702364694, contentText: "Test content", numOfVotes: 90),
    FeedItem(handleName: "user7", createdTimestamp: 1702451094, contentText: "Test content", numOfVotes: 10000),
    FeedItem(handleName: "user8", createdTimestamp: 1702105494, contentText: "Test content", numOfVotes: 1),
    FeedItem(handleName: nil, createdTimestamp: 1702105494, contentText: "Test content", numOfVotes: 5),
    FeedItem(handleName: "user10", createdTimestamp: 1701932694, contentText: """
             Test content, long long long long long long long long long long long long long
             
             
             long long long long long long long long long long long long long
             
             
             
             long long long long long long long long long long long long long
             
             long long long long long long long long long long long long long
                       
                       
                       
             long long long long long long long long long long long long long
             """, numOfVotes: 3),
  ]
    
    func changeVote(for item: FeedItem, voteType: FeedItem.VoteType) {
        if let item = feedItems.first(where: {$0.id == item.id}){
            
            if (item.voteType == voteType) {
                //When a user already has voted on a post
                switch item.voteType {
                case .up:
                    deIncrementVote(item, voteType: .none)
                case .down:
                    incrementVote(item, voteType: .none)
                case .none:
                    removeVote(item)
                }
            } else {
                //When a user has not voted on a post or if the item vote type is opposing
                switch voteType {
                case .up:
                    incrementVote(item, by: item.voteType == .down ? 2 : 1)
                case .down:
                    deIncrementVote(item, by: item.voteType == .up ? 2 : 1)
                case .none:
                    removeVote(item)
                }
            }
        }
    }
    
    private func removeVote(_ item: FeedItem) {
        if var item = feedItems.first(where: {$0.id == item.id}),
           let index = feedItems.firstIndex(where: {$0.id == item.id}) {
            item.voteType = .none
            feedItems[index] = item
        }
    }
    
    private func incrementVote(_ item: FeedItem, by value: Int = 1, voteType: FeedItem.VoteType = .up) {
        if var item = feedItems.first(where: {$0.id == item.id}),
           let index = feedItems.firstIndex(where: {$0.id == item.id}) {
            item.voteType = voteType
            item.numOfVotes += value
            feedItems[index] = item
        }
    }
    
    private func deIncrementVote(_ item: FeedItem, by value: Int = 1, voteType: FeedItem.VoteType = .down) {
        if var item = feedItems.first(where: {$0.id == item.id}),
           let index = feedItems.firstIndex(where: {$0.id == item.id}) {
            item.voteType = voteType
            item.numOfVotes -= value
            feedItems[index] = item
        }
    }
}

struct FeedItem: Identifiable, Comparable, Hashable {
    
    init(handleName: String? = nil, createdTimestamp: Double, contentText: String, numOfVotes: Int) {
        self.handleName = handleName
        self.createdTimestamp = createdTimestamp
        self.contentText = contentText
        self.numOfVotes = numOfVotes
    }
    
    //For "Anonymous" pseudonym
    var id = UUID()
    private var handleName: String?
    var createdTimestamp: Double
    var contentText: String
    var numOfVotes: Int
    var voteType: VoteType = .none
    
    static func < (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.createdTimestamp < rhs.createdTimestamp
    }
    
    static func > (lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.createdTimestamp > rhs.createdTimestamp
    }
}

extension FeedItem {
     
    enum VoteType {
        case up, down, none
    }
    
    static let defaultProfilePic = "person.crop.circle"
    
    mutating func incrementVote() {
        self.numOfVotes += 1
    }
    
    //The display name of the user for either the handle name or "Anonymous"
    var displayName: String {
        guard let handleName else {
            return "\"Anonymous\""
        }
        return handleName
    }
    
    static var dummyItem: FeedItem {
        return .init(handleName: "user1", createdTimestamp: Date.now.timeIntervalSince1970, contentText: "This should be a description of a Fizz post with somewhere of at least 200 characters. Maybe it is. Maybe it isn't. I'm not sure, but gonna type until I think I'm there. Okay bye", numOfVotes: 10000)
    }
    
    var creationDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy:MM:dd"
        let date = Date(timeIntervalSince1970: self.createdTimestamp)
        return formatter.string(from: date)
    }
}
