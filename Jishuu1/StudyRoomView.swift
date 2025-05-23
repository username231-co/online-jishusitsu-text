//
//  StudyRoomView.swift
//  Jishuu1
//
//  Created by 松佳 on 2025/05/04.
//


import SwiftUI

func formatDate(_ date: Date) -> String {//本当はCommentViewModelに入れたいがそうすると動作しない→あとで直す
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd/hh:mm:ss" // ← 好きな形式でOK！
    return formatter.string(from: date)
}

struct StudyRoomView: View {
    @Binding var isInRoom: Bool
      @Binding var timeElapsed: Int
    @StateObject var viewModel = CommentViewModel()//@StateObjectはviewが自分でインスタンスを生成して管理、viewが再生成されてもviewModelは再生成されない
    @State private var inputText = ""
    @State private var userName = "匿名\(Int.random(in: 100...999))"//使ってない
      //時間表示になる前の秒（例:4000秒）
      @Binding var timer: Timer?//Contentviewでの受け渡しがあるためBinding。子viewのため値の設定はない

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("退出") {
                    isInRoom = false
                }
                .foregroundColor(Color(red: 101/255, green: 67/255, blue: 33/255))
                .buttonStyle(BorderedButtonStyle())
                Spacer()
                Text("自習部屋").font(.title).padding()
                Spacer()

            }
            ScrollView {
                  
                        ForEach(viewModel.comments) { comment in
                              VStack(alignment: .leading, spacing: 2) {
                                    HStack{Text(comment.user).font(.caption).foregroundColor(.gray)
                                          Text(formatDate(comment.timestamp)).foregroundStyle(.gray)}//日付はintなのでformatedateでstrにする
                                    Text(comment.text)
                                          .padding(2)
                                    
                              }
                              .frame(maxWidth: .infinity, alignment: .leading)
                              .padding(.horizontal)
                        }
                        
                  
            }
              VStack(spacing: 20) {//タイマーヴュー
                  Text(formattedTime)
                      .font(.largeTitle)
                      .monospacedDigit()
                  
                  HStack {
                      Button("Start") {
                          startTimer()
                      }
                      .padding()
                      .buttonStyle(BorderedButtonStyle())
                      .foregroundColor(Color(red: 101/255, green: 67/255, blue: 33/255))
                      Button("Stop") {
                          stopTimer()
                      }
                      .padding()
                      .buttonStyle(BorderedButtonStyle())
                      .foregroundColor(Color(red: 101/255, green: 67/255, blue: 33/255))
                      Button("Reset") {
                          resetTimer()
                      }
                      .padding()
                      .buttonStyle(BorderedButtonStyle())
                      .foregroundColor(Color(red: 101/255, green: 67/255, blue: 33/255))
                  }
              }
              .padding()
            HStack {
                TextField("コメントを入力", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("送信") {
                    guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    viewModel.addComment(user: userName, text: inputText)
                    inputText = ""
                }
                .foregroundColor(Color(red: 101/255, green: 67/255, blue: 33/255))
            }
            .padding()
        }.background(Color(hex: "#faebd7"))
    }
      var formattedTime: String {//タイマーの設定、関数まとめ
          let hours = timeElapsed / 3600//時間に戻す
            let minutes = (timeElapsed % 3600) / 60//上で時間にできたものの残りを分に直す
          let seconds = timeElapsed % 60
          return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
      }
      func startTimer() {
          guard timer == nil else{return}//タイマーが動いている場合else実行で何も起きないようにする
          timer=Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in//withTimeInterval: 1は1秒ごとに処理を繰り返す。repeatsはtrueだと繰り返す。falseだと一回
              timeElapsed += 1//1秒ごとクロージャを実行
              
          }
      }
      func stopTimer() {
          timer?.invalidate()//インプルに止める
          timer=nil
      }
      func resetTimer() {
          stopTimer()
          timeElapsed = 0
      }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // 「#」を読み飛ばす
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
