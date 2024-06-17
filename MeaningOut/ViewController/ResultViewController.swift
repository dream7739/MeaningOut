//
//  ResultViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

class ResultViewController: UIViewController {
    
    let resultLabel = UILabel()
    
    lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tagLayout())
    
    lazy var resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: resultLayout())
    
    func tagLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let horizontalInset: CGFloat = 20
        let verticalInset: CGFloat = 5
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        return layout
    }
    
    func resultLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let horizontalInset: CGFloat = 20
        let verticalInset: CGFloat = 20
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        
        return layout
    }
    
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    var keyword: String?
    
    var start = 1
    
    var display = 30
    
    var sim: String = Constant.SortType.sim.sortParam
    
    var shopResult = ShopResult(total: 0, start: 0, display: 0, items: [])
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(likeButtonClicked),
                                               name: ShopNotification.like,
                                               object: nil)
        resultCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callNaverShop()
        configureView()
        configureNav(.result)
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
        
        navigationItem.title = keyword
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ResultViewController {
    func configureCollectionView(){
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.prefetchDataSource = self
        resultCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        
    }
    
    func callNaverShop(){
        guard let keyword else { return }
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret]
        
        let param: Parameters = [
            "query" : keyword,
            "start": start,
            "display": display,
            "sort": sim
        ]
        
        AF.request(
            APIURL.naverURL,
            method: .get,
            parameters: param,
            encoding: URLEncoding.queryString,
            headers: header
        ).responseDecodable(of: ShopResult.self, completionHandler: {
            response in
            switch response.result {
            case .success(let value):
                if self.start == 1 {
                    self.shopResult = value
                    self.resultLabel.text = self.shopResult.totalDescription
                }else{
                    self.shopResult.items.append(contentsOf: value.items)
                }
                
                self.resultCollectionView.reloadData()
                
                if self.start == 1 && self.shopResult.items.count > 0 {
                    self.resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    @objc func likeButtonClicked(notification: Notification){
        guard let indexPath = notification.userInfo?[ShopNotificationKey.indexPath] as? IndexPath,
              let click = notification.userInfo?[ShopNotificationKey.click] as? Bool else { return }

        let productId = shopResult.items[indexPath.row].productId
        
        if click {
            UserManager.addLikeList(productId)
        }else{
            UserManager.removeLikeList(productId)
        }
    }
    
}

extension ResultViewController: BaseProtocol {
    
    func configureHierarchy() {
        view.addSubview(resultLabel)
        view.addSubview(tagCollectionView)
        view.addSubview(resultCollectionView)
    }
    
    func configureLayout() {
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(23)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func configureUI() {
        resultLabel.font = .boldSystemFont(ofSize: 14)
        resultLabel.textColor = Constant.ColorType.theme
        
    }
}



extension ResultViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return Constant.SortType.allCases.count
        }else{
            return shopResult.items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as! TagCollectionViewCell
            
            let data = Constant.SortType.allCases[indexPath.row]
            cell.configureData(data)
            
            if indexPath == selectedIndexPath {
                cell.isClicked = true
            }else {
                cell.isClicked = false
            }
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
            let data = shopResult.items[indexPath.row]
            cell.indexPath = indexPath
            cell.configureData(data)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagCollectionView {
            let label = PaddingLabel()
            label.text = Constant.SortType.allCases[indexPath.row].title
            label.font = Constant.FontType.secondary
            
            let size = label.intrinsicContentSize
            return CGSize(width: size.width, height: size.height)
        }else{
            let spacing: CGFloat = 20
            let horizontalInset: CGFloat = 20
            let verticalInset: CGFloat = 10
            let width: CGFloat = (view.bounds.width - spacing - horizontalInset * 2) / 2
            let height: CGFloat = (view.bounds.height - spacing - verticalInset * 2) / 2.9
            
            return CGSize(width: width, height: height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagCollectionView {
            if selectedIndexPath != indexPath {
                selectedIndexPath = indexPath
                collectionView.reloadData()
                
                let sortParam = Constant.SortType.allCases[indexPath.row].sortParam
                sim = sortParam
                start = 1
                callNaverShop()
            }
        }else if collectionView == resultCollectionView {
            let data = shopResult.items[indexPath.row]
            
            let vc = DetailViewController()
            vc.productId = data.productId
            vc.link = data.link
            vc.name = data.titleDescription
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for idx in indexPaths {
            if idx.row == shopResult.items.count - 4 {
                start += display
                
                if start <= 1000 {
                    callNaverShop()
                }
            }
        }
    }
    
    
}
