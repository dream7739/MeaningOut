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
    
    func addLikeBarButton(){
        
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
