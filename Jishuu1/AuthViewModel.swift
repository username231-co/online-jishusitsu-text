//
//  AuthViewModel.swift
//  Jishuu1
//
//  Created by 松佳 on 2025/05/06.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var user: UserModel?

    func register(name: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            }

            guard let uid = result?.user.uid else {
                completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "UIDが取得できませんでした"]))
                return
            }

            let data: [String: Any] = [
                "uid": uid,
                "name": name,
                "email": email
            ]

            Firestore.firestore().collection("users").document(uid).setData(data) { err in
                if let err = err {
                    completion(err)
                } else {
                    self.user = UserModel(uid: uid, name: name, email: email)
                    completion(nil)
                }
            }
        }
    }
}
