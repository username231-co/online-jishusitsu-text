//
//  LoginView.swift
//  Jishuu1
//
//  Created by 松佳 on 2025/05/06.
//
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isLoggedIn = false
    @State private var showRegister = false  // 🔑 登録画面へ遷移するフラグ
    @State private var timeElapsed = 0
    @State private var timer: Timer? = nil
    
    
    var body: some View {
        ZStack{
            Color(red: 250 / 255, green: 235 / 255, blue: 215 / 255)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                TextField("メールアドレス", text: $email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("パスワード", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("ログイン") {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if let error = error {
                            errorMessage = error.localizedDescription
                        } else {
                            isLoggedIn = true
                        }
                    }
                }
                .padding()
                
                // 🔽 新規登録ボタン追加
                Button("新規アカウントを作成") {
                    showRegister = true
                }
                .padding()
                .foregroundColor(Color(red: 101/255, green: 67/255, blue: 33/255))
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Text("ゲストログインをご希望の方はこちらを入力ください")
                Text("Email: Gest@zisyu.com")
                Text("パスワード:12341234")
                    
                
                // 🔄 ログイン成功時に遷移（以前の処理）
                NavigationLink(destination: ContentView(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                
                // 🔄 新規登録画面に遷移
                NavigationLink(destination: RegisterView(), isActive: $showRegister) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}
