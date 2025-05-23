//
//  MainEntryView.swift
//  Jishuu1
//
//  Created by 松佳 on 2025/05/06.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct MainEntryView: View {
    var body: some View {
        if Auth.auth().currentUser != nil {
            ContentView()
        } else {
            NavigationView {
                LoginView()
            }
        }
    }
}
#Preview {
    MainEntryView()
}
