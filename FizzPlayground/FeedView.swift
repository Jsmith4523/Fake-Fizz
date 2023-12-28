//
//  ContentView.swift
//  FizzPlayground
//

import SwiftUI

/**
TODO: Your goal is to create a Fizz playground app.
 1) The first view you are going to create is FeedView, which loads data from FeedStore, show FeedItems in a vertical scrollable view
 
 2) For each of the FeedItem, create a FeedItemView
 
 3) Navigate from each FeedItemView to FeedDetailView
 
 Please submit your code github, and send the github link back to Fizz Team for review
 */
struct FeedView: View {
    
    @State private var searchText = ""
    
    @StateObject private var feedStore = FeedStore()
    
    //Sorting feed items based upon either the username and/or content
    var feedItems: [FeedItem] {
        guard !(searchText.isEmpty) else {
            return feedStore.feedItems
        }
        
        var items = [FeedItem]()
        
        for item in feedStore.feedItems {
            if (item.contentText.lowercased().contains(searchText.lowercased()) || item.displayName.lowercased().contains(searchText.lowercased())) {
                items.append(item)
            }
        }
        
        return items
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(feedItems.sorted(by: >)) { item in
                        NavigationLink {
                            FeedDetailView(item: item)
                                .environmentObject(feedStore)
                        } label: {
                            FeedItemView(item: item)
                                .environmentObject(feedStore)
                        }
                        Divider()
                    }
                }
            }
            .navigationTitle("Feed")
            .searchable(text: $searchText)
        }
        .tint(.orange)
    }
}

#Preview {
  FeedView()
}
