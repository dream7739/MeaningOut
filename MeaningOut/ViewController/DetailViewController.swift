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

    let indicator = UIActivityIndicatorView(style: .large)
    
    let emptyView = EmptyView(type: .link)
    
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
        view.addSubview(indicator)
        view.addSubview(emptyView)
    }
    
    func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        indicator.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        webView.navigationDelegate = self
        indicator.color = Constant.ColorType.secondary
        indicator.isHidden = true
        emptyView.isHidden = true
        
        guard let link, let url = URL(string: link) else {
            emptyView.isHidden = false
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension DetailViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.isHidden = true
        indicator.stopAnimating()
    }
    
}
