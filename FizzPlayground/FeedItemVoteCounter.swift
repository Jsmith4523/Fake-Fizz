//
//  FeedItemVoteCounter.swift
//  FizzPlayground
//
//  Created by Jaylen Smith on 12/27/23.
//

import SwiftUI

struct FeedItemVoteCounter: View {
    
    var item: FeedItem
    
    @EnvironmentObject var feedStore: FeedStore
    
    var body: some View {
        HStack {
            Text(item.numOfVotes, format: .number)
                .font(.system(size: 18).bold())
                .foregroundColor(.orange)
            Spacer()
            HStack(spacing: 10) {
                Image(systemName: "chevron.up")
                    .foregroundColor(item.voteType == .up ? .orange : Color(uiColor: .label))
                    .font(.system(size: 22).weight(.heavy))
                    .onTapGesture {
                        feedStore.changeVote(for: item, voteType: .up)
                    }
                Image(systemName: "chevron.down")
                    .foregroundColor(item.voteType == .down ? .orange : Color(uiColor: .label))
                    .font(.system(size: 22).weight(.heavy))
                    .onTapGesture {
                        feedStore.changeVote(for: item, voteType: .down)
                    }
            }
        }
    }
}

#Preview {
    FeedItemVoteCounter(item: .dummyItem)
        .environmentObject(FeedStore())
}
