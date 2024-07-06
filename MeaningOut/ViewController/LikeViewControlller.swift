//
//  LikeViewControlller.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/6/24.
//

import UIKit
import RealmSwift
import SnapKit

final class LikeViewControlller: UIViewController {
    private let resultLabel = UILabel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let emptyView = EmptyView(type: .result)
    private let resultCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomLayout.resultCollection()
    )
    
    let repository = RealmRepository()
    var list: Results<Like>!
    var count: Int = 0 {
        didSet {
            resultLabel.text = count.formatted() + "개의 좋아요한 상품"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.like)
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
    
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "찾으실 상품을 검색하세요"
        
        list = repository.fetchAll()
        count = repository.fetchAllCount()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(likeButtonClicked),
                                               name: ShopNotification.like,
                                               object: nil)
        
        count = repository.fetchAllCount()
        resultCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension LikeViewControlller {
    
    private func configureCollectionView(){
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        
    }
    
    @objc
    private func likeButtonClicked(notification: Notification){
        guard let item = notification.userInfo?[ShopNotificationKey.indexPath] as? (IndexPath, Bool) else { return }
        
        let indexPath = item.0
        let isClicked = item.1
        
        let data = list[indexPath.row]
        
        if isClicked {
            repository.addLike(data)
            resultCollectionView.reloadData()
        }else{
            repository.deleteLike(data)
            resultCollectionView.reloadData()
        }
    }
}

extension LikeViewControlller: BaseProtocol {
    func configureHierarchy() {
        view.addSubview(resultLabel)
        view.addSubview(resultCollectionView)
        view.addSubview(emptyView)
    }
    
    func configureLayout() {
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(23)
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func configureUI() {
        resultLabel.font = .boldSystemFont(ofSize: 15)
        resultLabel.textColor = Design.ColorType.theme
        emptyView.isHidden = true
    }
}

extension LikeViewControlller: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as? ResultCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let data = list[indexPath.item]
        
        let convertData = Shop(
            title: data.title,
            link: data.link ?? "",
            image: data.image ?? "",
            lprice: data.lprice ?? "",
            mallName: data.mallName ?? "",
            productId: "\(data.productId)"
        )
        
        cell.configureData(convertData)
        cell.indexPath = indexPath
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 20
        let horizontalInset: CGFloat = 20
        let verticalInset: CGFloat = 10
        let width: CGFloat = (view.bounds.width - spacing - horizontalInset * 2) / 2
        let height: CGFloat = (view.bounds.height - spacing - verticalInset * 2) / 2.9
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let data = list[indexPath.item]
        let convertData = Shop(
            title: data.title,
            link: data.link ?? "",
            image: data.image ?? "",
            lprice: data.lprice ?? "",
            mallName: data.mallName ?? "",
            productId: "\(data.productId)"
        )
        vc.data = convertData
        navigationController?.pushViewController(vc, animated: true)
    }
}

//extension LikeViewControlller: UICollectionViewDataSourcePrefetching {
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        for idx in indexPaths {
//
//            if idx.item == shopResult.items.count - 4 {
//                start += display
//
//                if start <= 1000 && start <= shopResult.total {
//                    callNaverShop()
//                }
//            }
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//        for idx in indexPaths {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: idx) as? ResultCollectionViewCell else {
//                return
//            }
//            cell.cancelDownload()
//        }
//    }
//
//
//}
