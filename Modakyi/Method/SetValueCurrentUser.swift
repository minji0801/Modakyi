//
//  SetUserData.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/16.
//  현재 사용자 데이터 Firebase에 저장하기

import Foundation
import FirebaseAuth
import FirebaseDatabase

/// 현재 사용자 닉네임과 이메일을 데이터베이스에 저장하기
func setValueCurrentUser() {
    let ref: DatabaseReference! = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid

    ref.child("User/\(uid!)/displayName").setValue(Auth.auth().currentUser?.displayName ?? "")
    ref.child("User/\(uid!)/email").setValue(Auth.auth().currentUser?.email ?? "")
}
