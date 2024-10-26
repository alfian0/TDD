//
//  HomeView.swift
//  TextValidator
//
//  Created by Alfian on 26/10/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Button {
            Task {
                try FirebaseAuthService().signOut()
            }
        } label: {
            Text("Logout")
        }
    }
}
