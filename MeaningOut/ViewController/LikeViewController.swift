//
//  LikeViewControlller.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/6/24.
//

import UIKit
import RealmSwift
import SnapKit

final class LikeViewController: UIViewController {
    private let resultLabel = UILabel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let emptyView = EmptyView(type: .like)
    lazy private var resultCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: productLayout()
    )
    
    let viewModel = LikeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.like)
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
        configureSearchController()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(likeButtonClicked),
            name: ShopNotification.like,
            object: nil
        )
        resultCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension LikeViewController {
    private func bindData(){
        print(#function)
        viewModel.ouputLikeResult.bind { value in
            self.resultCollectionView.reloadData()
        }
        
        viewModel.outputLikeResultCount.bind { value in
            if value == 0 {
                self.emptyView.isHidden = false
            }else{
                self.emptyView.isHidden = true
            }
            
            self.resultLabel.text = value.formatted() + "개의 좋아요한 상품"
        }
        
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    private func configureCollectionView(){
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        resultCollectionView.keyboardDismissMode = .onDrag
        
    }
    
    private func configureSearchController(){
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.configureDesign()
    }
    
    @objc
    private func likeButtonClicked(notification: Notification){
        guard let item = notification.userInfo?[ShopNotificationKey.indexPath] as? (IndexPath, Bool) else { return }
        
        viewModel.inputLikeIndexPath.value = item.0
        viewModel.inputLikeIsClicked.value = item.1
        
        viewModel.inputLikeButtonClicked.value = ()
    }
}

extension LikeViewController: BaseProtocol {
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
        resultLabel.textColor = ColorType.theme
    }
}

extension LikeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.inputSearchText.value = searchController.searchBar.text!.trimmingCharacters(in: .whitespaces)
    }
}


extension LikeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.ouputLikeResult.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as? ResultCollectionViewCell, let data = viewModel.ouputLikeResult.value else {
            return UICollectionViewCell()
        }
        
        cell.indexPath = indexPath
        cell.isClicked = true
        cell.keyword = viewModel.inputSearchText.value
        
        let item = Shop.init(managedObject: data[indexPath.item])
        cell.configureData(item)
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let list = viewModel.ouputLikeResult.value else { return }
        let detailVC = DetailViewController()
        detailVC.viewModel.inputShopResult.value = Shop.init(managedObject: list[indexPath.item])
        transition(detailVC, .push)
    }
}
