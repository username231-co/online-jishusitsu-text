//
//  RegesterView.swift
//  Jishuu1
//
//  Created by 松佳 on 2025/05/06.
//
import SwiftUI

struct RegisterView: View {
    @StateObject var authVM = AuthViewModel()
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var isRegistered = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("新規アカウント作成")
                    .font(.title2)
                    .bold()

                TextField("名前", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("メールアドレス", text: $email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("パスワード（6文字以上）", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button("登録する") {
                    authVM.register(name: name, email: email, password: password) { error in
                        DispatchQueue.main.async {
                            if let error = error {
                                errorMessage = error.localizedDescription
                            } else {
                                isRegistered = true
                            }
                        }
                    }
                }
                .padding()

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                // ここで NavigationLink を表示（ただし空ビューにしない）
                NavigationLink(destination: MainEntryView(), isActive: $isRegistered) {
                    Text("") // ここを EmptyView にするとうまく遷移しない場合がある
                }
            }
            .padding()
        }
    }
}


#Preview {
    NavigationStack {
        RegisterView()
    }
}
