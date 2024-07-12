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

    let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let title = viewModel.inputShopResult.value?.titleDescription ?? ""
        configureNav(.detail(title))
        configureHierarchy()
        configureLayout()
        configureUI()
        configureWebView()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewDidLoadTrigger.value = ()
    }
}

extension DetailViewController {
    private func configureWebView(){
        guard let link = viewModel.inputShopResult.value?.link,
        let url = URL(string: link) else {
            emptyView.isHidden = false
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func bindData(){
        viewModel.outputLikeisClicked.bind { value in
            var image: UIImage
            
            if value {
                image = ImageType.like_selected ?? UIImage()
            }else{
                image = ImageType.like_unselected ?? UIImage()
            }
            
            self.navigationItem.rightBarButtonItem?.image = image
        }
        
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    @objc
    private func likeButtonClicked(){
        viewModel.inputLikeButtonClicked.value = ()
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
        indicator.color = ColorType.secondary
        indicator.hidesWhenStopped = true
        emptyView.isHidden = true
        let like = UIBarButtonItem(
            image: UIImage(),
            style: .plain,
            target: self,
            action: #selector(self.likeButtonClicked)
        )
        like.tintColor = ColorType.theme
        navigationItem.rightBarButtonItem = like
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
