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
        
        guard let link, let url = URL(string: link) else {
            emptyView.isHidden = false
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension DetailViewController {
    func addLikeBarButton(){
        guard let productId else { return }
        let image: UIImage
        
        if let _ = UserManager.likeDict[productId], !UserManager.likeDict.isEmpty {
            isClicked = true
            image = Design.ImageType.like_selected ?? UIImage()
        }else{
            isClicked = false
            image = Design.ImageType.like_unselected ?? UIImage()
        }
        let likeButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(likeButtonClicked))
        navigationItem.rightBarButtonItem = likeButton
    }
    
    @objc func likeButtonClicked(){
        guard let productId else { return }
        
        isClicked.toggle()
        
        if isClicked {
            UserManager.addLikeList(productId)
            navigationItem.rightBarButtonItem?.image = Design.ImageType.like_selected ?? UIImage()
        }else{
            UserManager.removeLikeList(productId)
            navigationItem.rightBarButtonItem?.image = Design.ImageType.like_unselected ?? UIImage()
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
        indicator.color = Design.ColorType.secondary
        indicator.hidesWhenStopped = true
        emptyView.isHidden = true
    }
}

extension DetailViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = webView.url?.absoluteString else {
            configureFailLoad(with: .invalidURL)
            decisionHandler(.cancel)
            return
        }
        
        if url.lowercased().starts(with: "https://") ||
            url.lowercased().starts(with: "http://"){
            decisionHandler(.allow)
            return
        }else{
            configureFailLoad(with: .invalidURL)
            decisionHandler(.cancel)
            return
        }
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        print(error.localizedDescription)
        configureFailLoad(with: .failLoad)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        print(error.localizedDescription)
        configureFailLoad(with: .failNavigation)
    }
    
    func configureFailLoad(with error: Validation.Web){
        indicator.stopAnimating()
        emptyView.isHidden = false
        emptyView.descriptionLabel.text = ""
        showToast(error.rawValue)
    }
    
}
