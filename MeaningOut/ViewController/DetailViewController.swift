//
//  DetailViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/16/24.
//

import UIKit
import WebKit
import SnapKit

class DetailViewController: UIViewController {

    let webView = WKWebView()
    
    var productId: String?
    
    var link: String?
    
    var name: String?
    
    var isClicked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.detail)
        configureHierarchy()
        configureLayout()
        configureUI()
        
        navigationItem.title = name
        addLikeBarButton()
    }
}

extension DetailViewController {
    func addLikeBarButton(){
        guard let productId else { return }
        let image: UIImage
        
        if !UserManager.likeList.isEmpty && UserManager.likeList.contains(productId){
            isClicked = true
            image = Constant.ImageType.like_selected!
        }else{
            isClicked = false
            image = Constant.ImageType.like_unselected!
        }
        
        let likeButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(likeButtonClicked))
        navigationItem.rightBarButtonItem = likeButton
    }
    
    @objc func likeButtonClicked(){
        guard let productId else { return }

        isClicked.toggle()

        if isClicked {
            UserManager.addLikeList(productId)
            navigationItem.rightBarButtonItem?.image = Constant.ImageType.like_selected!
        }else{
            UserManager.removeLikeList(productId)
            navigationItem.rightBarButtonItem?.image = Constant.ImageType.like_unselected!
        }
    }
}

extension DetailViewController: BaseProtocol {
    func configureHierarchy() {
        view.addSubview(webView)
    }
    
    func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        guard let link, let url = URL(string: link) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
