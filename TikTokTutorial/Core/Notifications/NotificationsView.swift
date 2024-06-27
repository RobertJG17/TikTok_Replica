//
//  NotificationsView.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 6/26/24.
//

import SwiftUI

struct NotificationsView: View {
    var body: some View {
        NavigationStack {
            ScrollView() {
                LazyVStack(spacing: 24) {
                    ForEach(0 ..< 10) { notification in
                        NotificationCell()
                    }
                }
                
                .padding(.top)
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NotificationsView()
}
