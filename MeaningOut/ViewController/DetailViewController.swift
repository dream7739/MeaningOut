//
//  DetailViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/16/24.
//

import UIKit
import WebKit
import SnapKit

final class DetailViewController: UIViewController {
    private let webView = WKWebView()
    private let indicator = UIActivityIndicatorView(style: .large)
    private let emptyView = EmptyView(type: .link)
    
    private let repository = RealmRepository()
    private var isClicked: Bool = false
    var data: Shop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.detail)
        configureHierarchy()
        configureLayout()
        configureUI()
        
        guard let data else { return }
        
        navigationItem.title = data.titleDescription
        addLikeBarButton()
        
        guard let url = URL(string: data.link) else {
            emptyView.isHidden = false
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension DetailViewController {
    private func addLikeBarButton(){
        guard let data else { return }
  
        let image: UIImage
        
        if repository.isExistLike(id: Int(data.productId)!){
            isClicked = true
            image = Design.ImageType.like_selected ?? UIImage()
        }else{
            isClicked = false
            image = Design.ImageType.like_unselected ?? UIImage()
        }
       
        let likeButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(likeButtonClicked))
        likeButton.tintColor = Design.ColorType.theme
        navigationItem.rightBarButtonItem = likeButton
    }
    
    @objc
    private func likeButtonClicked(){
        guard let data else { return }
        
        isClicked.toggle()
        
        if isClicked {
            repository.addLike(data.managedObject())
            navigationItem.rightBarButtonItem?.image = Design.ImageType.like_selected ?? UIImage()
        }else{
            repository.deleteLike(Int(data.productId)!)
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
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        print(#function, error.localizedDescription)
        configureFailLoad(with: .failLoad)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        print(#function, error.localizedDescription)
        configureFailLoad(with: .failNavigation)
    }
    
    func configureFailLoad(with error: Validation.Web){
        indicator.stopAnimating()
        emptyView.isHidden = false
        emptyView.descriptionLabel.text = ""
        showToast(error.rawValue)
    }
    
}
