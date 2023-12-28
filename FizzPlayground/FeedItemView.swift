//
//  FeedItemView.swift
//  FizzPlayground
//
//

import SwiftUI

/**
1) Implement FeedItemView here, each view looks like below
 -----------------------------------------
 | handlerName         createdDate(yyyy:mm:dd)                  |
 | content text goes here.... (up to 200 chars)                   |
 | numOfVotes                       [Up Vote] [Down Vote]      |
 -----------------------------------------
2) implement up vote button and down vote which increases/decreases the number of votes
3) only show up to 200 chars of content text 
4) click on FeedItemView to navigate to FeedDetailView
 */
struct FeedItemView: View {
    
    var hasCharacterLimit: Bool = true
    let item: FeedItem
    
    @EnvironmentObject var feedStore: FeedStore
    
    private var prefixText: String {
        //If there isn't a character limit, then we can return the
        //text without prefix.
        guard hasCharacterLimit else {
            return item.contentText
        }
        
        if item.contentText.count <= 200 {
            return item.contentText
        }
        return item.contentText.prefix(75)+"..."
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            header
            textContent
            FeedItemVoteCounter(item: item)
                .padding(.top, 5)
        }
        .padding()
        .foregroundColor(Color(uiColor: .label))
        .environmentObject(feedStore)
    }
    
    private var header: some View {
        HStack {
            Image(systemName: FeedItem.defaultProfilePic)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
            HStack {
                HStack {
                    Text(item.displayName)
                    Text(item.creationDate)
                }
                .font(.system(size: 15.6).weight(.medium))
                Spacer()
            }
            .foregroundColor(.gray)
        }
    }
    
    private var textContent: some View {
        Text(self.prefixText)
            .font(.system(size: 17).weight(.medium))
            .multilineTextAlignment(.leading)
    }
}

#Preview {
    FeedItemView(item: .dummyItem)
        .environmentObject(FeedStore())
        .preferredColorScheme(.dark)
}
