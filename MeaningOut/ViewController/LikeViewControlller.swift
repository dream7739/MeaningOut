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
    private let emptyView = EmptyView(type: .like)
    lazy var resultCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomLayout.product(view).get()
    )
    
    private let repository = RealmRepository()
    private var list: Results<Like>!
    private var keyword: String?
    private var count: Int = 0 {
        didSet {
            if count == 0 {
                emptyView.isHidden = false
            }else{
                emptyView.isHidden = true
            }
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
        configureSearchController()
        
        list = repository.fetchAll()
        count = list.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(likeButtonClicked),
                                               name: ShopNotification.like,
                                               object: nil)
        count = list.count
        resultCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func configureUI() {
        resultLabel.font = .boldSystemFont(ofSize: 15)
        resultLabel.textColor = Design.ColorType.theme
    }
}

extension LikeViewControlller: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let keyword = searchController.searchBar.text, !keyword.trimmingCharacters(in: .whitespaces).isEmpty {
            list = repository.fetchAll(keyword)
            self.keyword = keyword
        }else{
            list = repository.fetchAll()
            self.keyword = nil
        }
        count = list.count
        resultCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        keyword = nil
    }
}

extension LikeViewControlller {
    private func configureCollectionView(){
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        resultCollectionView.keyboardDismissMode = .onDrag
        
    }
    
    private func configureSearchController(){
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = Design.ColorType.black
        searchController.searchBar.searchTextField.placeholder = Display.Placeholder.search.rawValue
    }
    
    @objc
    private func likeButtonClicked(notification: Notification){
        guard let item = notification.userInfo?[ShopNotificationKey.indexPath] as? (IndexPath, Bool) else { return }
        
        let indexPath = item.0
        let isClicked = item.1
        
        let data = list[indexPath.row]
        
        if !isClicked{
            repository.deleteLike(data)
            count = list.count
            resultCollectionView.reloadData()
        }
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
        cell.keyword = keyword
        cell.configureData(Shop.init(managedObject: data))
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
        vc.data = Shop.init(managedObject: data)
        navigationController?.pushViewController(vc, animated: true)
    }
}
