//
//  NoticeViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/18.
//

import UIKit

class NoticeViewController: UIViewController {
    @IBOutlet weak var noticeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noticeTextView.text = """
                           안녕하세요. <모닥이> 입니다.
                           1인 개발이라 혼자서 메일 답장과 글귀 업로드 및 개발을 하고 있습니다.
                           시간이 걸리는 점 양해 부탁드립니다 :)
                           
                           -----<문의 및 의견>-----
                           문의사항이나 오타 발견 및 기타 의견은 [설정 - 문의 및 의견]을 통해 메일을 보내주시면 최대한 빠른 시일 내에 답장 드리겠습니다.
                           
                           -----<1.0.1 버전 업데이트>-----
                           로그아웃 시 발생하는 오류를 수정했습니다.
                           """
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
