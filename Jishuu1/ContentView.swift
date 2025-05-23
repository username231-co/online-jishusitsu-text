//
//  ContentView.swift
//  Jishuu1
//
//  Created by 松佳 on 2025/05/01.
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ContentView: View {
    @State private var timeElapsed = 0
    @State private var isInRoom = false
    @StateObject var viewModel = CommentViewModel()
    @State private var userName = ""
    @State private var isLoading = true
    @State private var timer: Timer? = nil
    let gradient = LinearGradient(gradient: Gradient(colors: [.blue, .red]), startPoint: .topLeading, endPoint: .bottomTrailing) //本日の時間かこう色の設定   //@Binding var timeElapsed: Int//値の受け渡し
    var body: some View {


            TabView {
                ZStack {
                    // ← TabView の各タブにも背景を明示的に
                    Color(red: 250 / 255, green: 235 / 255, blue: 215 / 255)
                        .ignoresSafeArea()
                    
                    
                    if isLoading {
                        ProgressView("読み込み中...")
                            .onAppear {
                                fetchUserName()
                            }
                    } else {
                        if isInRoom {
                            StudyRoomView(isInRoom: $isInRoom, timeElapsed: $timeElapsed,timer: $timer)
                                .onAppear {
                                    viewModel.addComment(user: userName, text: "入室しました")
                                }
                        } else {
                            VStack {
                                Text("オンライン自習室")
                                    .font(.largeTitle)
                                    .padding(.bottom, 100)//隙間表現
                                    .foregroundColor(Color(red: 101/255, green: 67/255, blue: 33/255))
                                ZStack{
                                    Rectangle()
                                                   .stroke(lineWidth: 10)
                                                   .fill(gradient)
                                                   .frame(width: 300, height: 200)
                                                   
                                    VStack{
                                        Text("本日の勉強時間")
                                            .font(.largeTitle)
                                            
                                            .padding()
                                        Text(formattedTime)
                                            .font(.largeTitle)
                                            .monospacedDigit()
                                    }
                                }
                                Button("入室する") {
                                    isInRoom = true
                                }
                                .padding()
                                .font(.title2)
                                .buttonStyle(BorderedButtonStyle())
                                .foregroundColor(Color(red: 101/255, green: 67/255, blue: 33/255))
                            }
                                
                            }
                        }
                    }.tabItem {Image(systemName: "circle.fill")
                        Text("ホーム")
                }
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "circle.fill")
                            Text("プロフィール")
                        }
                
            }
        
    }
    private func fetchUserName() {
        guard let uid = Auth.auth().currentUser?.uid else {
            userName = "匿名\(Int.random(in: 100...999))" // 念のため fallback
            isLoading = false
            return
        }

        let docRef = Firestore.firestore().collection("users").document(uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                userName = document.data()?["name"] as? String ?? "名前なし"
            } else {
                userName = "名前未登録"
            }
            isLoading = false
        }
    }
    var formattedTime: String {//タイマーの設定、関数まとめ
        let hours = timeElapsed / 3600//時間に戻す
        let minutes = (timeElapsed % 3600) / 60//上で時間にできたものの残りを分に直す
        let seconds = timeElapsed % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
}


#Preview {
    ContentView()//本番ではだめ、練習よう
}
