//
//  DetailViewController.swift
//  Modakyi
//
//  Created by 김민지 on 2021/11/01.
//  글귀 상세 ViewController

import UIKit
import GoogleMobileAds

final class DetailViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    let viewModel = DetailViewModel()   // ViewModel

    private var interstitial: GADInterstitialAd?    // 전면 광고 객체

    @IBOutlet weak var textIdLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textView: UIView!

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNoti()
        setupAdMobAds()
        textIdLabel.text = "글귀 \(viewModel.id)"

        viewModel.getText { [weak self] eng, kor, who in
            guard let self = self else { return }

            self.textLabel.text = textOnLabel(eng, kor, who)

            // 아이패드는 글자 크기 크게
            if UIDevice.current.model == "iPad" {
                self.textLabel.font = UIFont(name: "EliceDigitalBaeum", size: 23.0)
            }
        }

        viewModel.getLikeTextIDs {
            self.viewWillAppear(true)
        }

        viewModel.getUsedTextIDs {
            self.viewWillAppear(true)
        }
    }

    /// 화면 보여질 때마다: 다크모드 확인, 버튼 설정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appearanceCheck(self)
        setupButtons()
    }

    /// 화면 사라지려할 때: Noti 보내기(변경된 부분을 바로 반영하기 위해서)
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("DismissDetailView"), object: nil, userInfo: nil)
    }

    /// 뒷배경 클릭: 전면 광고 보여주기
    @IBAction func backgroundViewTapped(_ sender: UITapGestureRecognizer) {
        presentToAd()
    }

    /// x 버튼 클릭: 전면 광고 보여주기
    @IBAction func backButtonTapped(_ sender: UIButton) {
        presentToAd()
    }

    /// 좋아요 버튼 클릭: 좋아하는 글귀 업데이트 & 버튼 다시 보여주기
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            viewModel.updateLikeTextIDs(true, sender)
        } else {
            viewModel.updateLikeTextIDs(false, sender)
        }
        self.viewDidAppear(true)
    }

    /// 체크 버튼 클릭: 사용한 글귀 업데이트 & 버튼 다시 보여주기
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        if sender.isSelected {
            viewModel.updateUsedTextIDs(true, sender)
        } else {
            viewModel.updateUsedTextIDs(false, sender)
        }
        self.viewDidAppear(true)
    }

    /// Notification 설정
    func setupNoti() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.textShareNotification(_:)),
            name: NSNotification.Name("TextShare"),
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.imageShareNotification(_:)),
            name: NSNotification.Name("ImageShare"),
            object: nil
        )
    }

    /// 버튼 설정
    func setupButtons() {
        let id = viewModel.id
        likeButton.tag = Int(id)!
        checkButton.tag = Int(id)!

        if viewModel.likeTextIDs.contains(Int(id)!) {
            likeButton.isSelected = true
            likeButton.tintColor = .systemPink
        } else {
            likeButton.isSelected = false
            likeButton.tintColor = .label
        }

        if viewModel.usedTextIDs.contains(Int(id)!) {
            checkButton.isSelected = true
            checkButton.tintColor = .systemGreen
        } else {
            checkButton.isSelected = false
            checkButton.tintColor = .label
        }
    }

    /// AdMob 광고 설정
    func setupAdMobAds() {

        // 배너 광고
        bannerView.adUnitID = "ca-app-pub-7980627220900140/4042418339"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

        // 전면 광고
        let request = GADRequest()
        let adUnitID = "ca-app-pub-7980627220900140/4153256056"
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { [self] ads, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ads
            interstitial?.fullScreenContentDelegate = self
        }
    }

    /// 전면 광고 띄우기
    func presentToAd() {
        if self.interstitial != nil {   // 광고 있으면 보여주기
            self.interstitial!.present(fromRootViewController: self)
        } else {    // 광고 없으면 화면 닫기
            print("Ad wasn't ready")
            dismiss(animated: true, completion: nil)
        }
    }

    /// 공유하기 화면 띄우기
    func presentToActivityVC(items: [Any]) {
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        activityVC.popoverPresentationController?.sourceRect = self.textView.bounds
        activityVC.popoverPresentationController?.permittedArrowDirections = .left
        DispatchQueue.main.async {
            self.present(activityVC, animated: true, completion: nil)
        }
    }

    // iPhone에서도 팝업(popover)창 보여주기 위한 설정 1
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destination
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }

    // iPhone에서도 팝업(popover)창 보여주기 위한 설정 2
    func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        return .none
    }
}

// MARK: - Admob 전면광고 Delegate
extension DetailViewController: GADFullScreenContentDelegate {

    /// present 실패
    func ad(_ ads: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }

    /// present 성공
    func adDidPresentFullScreenContent(_ ads: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }

    /// 전면 광고 dismiss: 상세화면도 닫기
    func adDidDismissFullScreenContent(_ ads: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - @objc Function
extension DetailViewController {

    /// 텍스트 공유하기 버튼 클릭된 후 Noti
    @objc func textShareNotification(_ notification: Notification) {
        var objectsToShare = [String]()
        if let text = self.textLabel.text {
            objectsToShare.append(text)
        }
        presentToActivityVC(items: objectsToShare)
    }

    /// 이미지 공유하기 버튼 클릭된 후 Noti
    @objc func imageShareNotification(_ notification: Notification) {
        guard let image = self.textView.transfromToImage() else { return }
        presentToActivityVC(items: [image])
    }
}

// MARK: - Extension UIView
extension UIView {

    /// UIView를 이미지로 변환하기
    func transfromToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
}
