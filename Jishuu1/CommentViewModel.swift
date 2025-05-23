//
//  CommentViewModel.swift
//  Jishuu1
//
//  Created by 松佳 on 2025/05/04.
//


import Foundation
import FirebaseFirestore


struct Comment: Identifiable {
    var id: String
    var user: String
    var text: String
    var timestamp: Date
}


class CommentViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    private var db = Firestore.firestore()

    init() {
        fetchComments()
    }

    func fetchComments() {
        db.collection("study_room_comments")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.comments = documents.compactMap { doc in
                    let data = doc.data()
                    let id = doc.documentID
                    let user = data["user"] as? String ?? "匿名"
                    let text = data["text"] as? String ?? ""
                    let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    return Comment(id: id, user: user, text: text, timestamp: timestamp)
                }
            }
    }

    func addComment(user: String, text: String) {
        let data: [String: Any] = [
            "user": user,
            "text": text,
            "timestamp": Timestamp(date: Date())
        ]
        db.collection("study_room_comments").addDocument(data: data)
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd" // ← 好きな形式でOK！
        return formatter.string(from: date)
    }
}
