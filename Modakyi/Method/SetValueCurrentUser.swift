//
//  SetUserData.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/16.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

func setValueCurrentUser() {
    let ref: DatabaseReference! = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid

    ref.child("User/\(uid!)/displayName").setValue(Auth.auth().currentUser?.displayName ?? "")
    ref.child("User/\(uid!)/email").setValue(Auth.auth().currentUser?.email ?? "")
}
