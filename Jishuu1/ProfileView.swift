//
//  ProfileView.swift
//  Jishuu1
//
//  Created by 松佳 on 2025/05/06.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isLoading = true
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack{
            Color(red: 250 / 255, green: 235 / 255, blue: 215 / 255)
                .ignoresSafeArea()
            VStack(spacing: 16) {
                if isLoading {
                    ProgressView("読み込み中…")
                } else {
                    Text("プロフィール")
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Text("名前:")
                        TextField("名前", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                        
                    }
                    
                    HStack() {
                        Text("メール:")
                        Text(email)
                            .foregroundColor(.gray)
                        Spacer()
                        
                    }
                    
                    
                    Button("名前を更新する") {
                        updateName()
                    }
                    .padding()
                    .buttonStyle(BorderedButtonStyle())
                    .foregroundColor(Color(red: 101/255, green: 67/255, blue: 33/255))
                    Button("ログアウト") {
                        try? Auth.auth().signOut()
                    }
                    .foregroundColor(.red)
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage).foregroundColor(.red)
                    }
                }
            }
            .padding()
            .onAppear {
                fetchProfile()
            }
        }
    }

    private func fetchProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "ユーザー情報が取得できません"
            self.isLoading = false
            return
        }

        Firestore.firestore().collection("users").document(uid).getDocument { doc, error in
            if let doc = doc, doc.exists {
                self.name = doc.data()?["name"] as? String ?? ""
                self.email = doc.data()?["email"] as? String ?? ""
            } else {
                self.errorMessage = "ユーザー情報の取得に失敗しました"
            }
            self.isLoading = false
        }
    }

    private func updateName() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(uid).updateData([
            "name": name
        ]) { error in
            if let error = error {
                self.errorMessage = "更新失敗: \(error.localizedDescription)"
            } else {
                self.errorMessage = "名前を更新しました！"
            }
        }
    }
}

#Preview {
    ProfileView()
}
