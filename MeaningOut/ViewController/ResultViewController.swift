//
//  ResultViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import SnapKit

class ResultViewController: UIViewController {
    
    let resultLabel = UILabel()
    
    let emptyView = EmptyView(type: .result)
    
    let networkView = NetworkView()
    
    lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tagLayout())
    
    lazy var resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ResultViewController.resultLayout())
    
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
    
    var selectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    var keyword: String?
    
    var start = 1
    
    var display = 30
    
    var sort: String = Display.SortOption.sim.sortParam
    
    var shopResult = ShopResult(total: 0, start: 0, display: 0, items: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.result)
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
        
        navigationItem.title = keyword
        callNaverShop()
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

extension ResultViewController {
    func callNaverShop(){
        guard let keyword else { return }

        if NetworkMonitor.shared.isConnected {
            let request = ShopRequest(query: keyword, start: start, display: display, sort: sort)
            
            APIManager.shared.request(model: ShopResult.self, request: .shop(request: request)) { result in
                switch result {
                case .success(let value):
                    if value.total == 0 {
                        self.emptyView.isHidden = false
                        return
                    }
                    
                    if self.start == 1 {
                        self.shopResult = value
                        self.resultLabel.text = self.shopResult.totalDescription
                    }else{
                        self.shopResult.items.append(contentsOf: value.items)
                    }
                    
                    self.resultCollectionView.reloadData()
                    
                    if self.start == 1 {
                        self.resultCollectionView.scrollToItem(
                            at: IndexPath(item: 0, section: 0),
                            at: .top,
                            animated: false
                        )
                    }
                case .failure(let error):
                    print(error)
                    self.emptyView.isHidden = false
                    self.showToast("결과를 가져오는데 실패하였습니다.")
                }
            }
        }else{
            networkView.isHidden = false
        }
    }
    
    func configureCollectionView(){
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.prefetchDataSource = self
        resultCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        
    }
    
    @objc func likeButtonClicked(notification: Notification){
        guard let item = notification.userInfo?[ShopNotificationKey.indexPath] as? (IndexPath, Bool) else { return }
        
        let indexPath = item.0
        let isClicked = item.1
        
        let productId = shopResult.items[indexPath.row].productId
        
        if isClicked {
            UserManager.addLikeList(productId)
        }else{
            UserManager.removeLikeList(productId)
        }
    }
    
    @objc func retryButtonClicked(notification: Notification){
        callNaverShop()
    }
}

extension ResultViewController: BaseProtocol {
    
    func configureHierarchy() {
        view.addSubview(resultLabel)
        view.addSubview(tagCollectionView)
        view.addSubview(resultCollectionView)
        view.addSubview(emptyView)
        view.addSubview(networkView)
    }
    
    func configureLayout() {
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(23)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        networkView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
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
        resultLabel.textColor = Design.ColorType.theme
        emptyView.isHidden = true
        networkView.isHidden = true
    }
}

extension ResultViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return Display.SortOption.allCases.count
        }else{
            return shopResult.items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let data = Display.SortOption.allCases[indexPath.row]
            cell.configureData(data)
            
            if indexPath == selectedIndexPath {
                cell.isClicked = true
            }else {
                cell.isClicked = false
            }
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as? ResultCollectionViewCell else {
                return UICollectionViewCell()
            }
            let data = shopResult.items[indexPath.row]
            cell.indexPath = indexPath
            cell.configureData(data)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagCollectionView {
            let label = PaddingLabel()
            label.text = Display.SortOption.allCases[indexPath.row].title
            label.font = Design.FontType.secondary
            
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
                
                sort = Display.SortOption.allCases[indexPath.row].sortParam
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
            
            if idx.item == shopResult.items.count - 4 {
                start += display
                
                if start <= 1000 && start <= shopResult.total {
                    callNaverShop()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for idx in indexPaths {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: idx) as? ResultCollectionViewCell else {
                return
            }
            cell.cancelDownload()
        }
    }
    
    
}
