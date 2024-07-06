//
//  LikeViewControlller.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/6/24.
//

import UIKit
import SnapKit

final class LikeViewControlller: UIViewController {
    
    private let resultLabel = UILabel()
    
    private let emptyView = EmptyView(type: .result)
    
    private let resultCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomLayout.resultCollection()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.like)
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(likeButtonClicked),
                                               name: ShopNotification.like,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(retryButtonClicked),
                                               name: ShopNotification.network,
                                               object: nil)
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
//        resultCollectionView.prefetchDataSource = self
        resultCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        
    }
    
    @objc
    private func likeButtonClicked(notification: Notification){
        //        guard let item = notification.userInfo?[ShopNotificationKey.indexPath] as? (IndexPath, Bool) else { return }
        //
        //        let indexPath = item.0
        //        let isClicked = item.1
        //
        //        let productId = shopResult.items[indexPath.row].productId
        //
        //        if isClicked {
        //            UserManager.addLikeList(productId)
        //        }else{
        //            UserManager.removeLikeList(productId)
        //        }
    }
    
    @objc
    private func retryButtonClicked(notification: Notification){
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
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(23)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.edges.bottom.equalTo(view.safeAreaLayoutGuide)
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as? ResultCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .red
//        let data = shopResult.items[indexPath.row]
//        cell.indexPath = indexPath
//        cell.keyword = keyword
//        cell.configureData(data)
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
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//            let data = shopResult.items[indexPath.row]
//            
//            let vc = DetailViewController()
//            vc.productId = data.productId
//            vc.link = data.link
//            vc.name = data.titleDescription
//            navigationController?.pushViewController(vc, animated: true)
//    }
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
