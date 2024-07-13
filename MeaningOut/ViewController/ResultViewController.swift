//
//  ResultViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import RealmSwift
import SnapKit

final class ResultViewController: UIViewController {
    private let resultLabel = UILabel()
    private let tagStackView = UIStackView()
    private let simSortButton = TagButton(type: .system)
    private let dateSortButton = TagButton(type: .system)
    private let ascSortButton = TagButton(type: .system)
    private let descSortButton = TagButton(type: .system)
    private lazy var sortButtonList = [simSortButton, dateSortButton, ascSortButton, descSortButton]
    private let emptyView = EmptyView(type: .result)
    private let networkView = NetworkView()
    
    private lazy var resultCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: productLayout()
    )
    
    let viewModel = ResultViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(viewModel.inputSearchText.value ?? "")
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(likeButtonClicked),
                                               name: ShopNotification.like,
                                               object: nil)
        resultCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension ResultViewController {
    enum SortOption: Int, CaseIterable {
        case sim = 0
        case date = 1
        case dsc = 2
        case asc = 3
        
        var title: String {
            switch self {
            case .sim:
                return "정확도"
            case .date:
                return "날짜순"
            case .dsc:
                return "가격높은순"
            case .asc:
                return "가격낮은순"
            }
        }
        
        var sortParam: String {
            return String(describing: self)
        }
    }
    
    private func configureCollectionView(){
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.prefetchDataSource = self
        resultCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
    }
    
    private func bindData(){
        viewModel.outputNetworkConnect.bind { value in
            self.networkView.isHidden = value
        }
        
        viewModel.outputEmptyResult.bind { value in
            self.emptyView.isHidden = !value
        }
        
        viewModel.outputSearchResult.bind { value in
            if let value {
                self.resultLabel.text = value.totalDescription
                self.resultCollectionView.reloadData()
                
                if self.viewModel.inputSearchRequest.value?.start == 1{
                    self.resultCollectionView.scrollToItem(
                        at: IndexPath(item: -1, section: 0),
                        at: .top,
                        animated: false
                    )
                }
            }else{
                self.emptyView.isHidden = false
                self.showToast("결과를 가져오는데 실패하였습니다.")
            }
        }
        
        viewModel.inputSortOptionIndex.value = 0
    }
    
    @objc
    private func likeButtonClicked(notification: Notification){
        guard let item = notification.userInfo?[ShopNotificationKey.indexPath] as? (IndexPath, Bool) else { return }
        
        let indexPath = item.0
        let isClicked = item.1
        
        guard let result = viewModel.outputSearchResult.value?.items else { return }
        let data = result[indexPath.item]
        viewModel.inputLikeSelectedIndex.value = indexPath
        viewModel.inputLikeIsClicked.value = isClicked
        viewModel.inputLikeButtonClicked.value = (data)
    }
    
    @objc
    private func retryButtonClicked(){
        viewModel.inputRetryButtonClick.value = ()
    }
}

extension ResultViewController: BaseProtocol {
    
    func configureHierarchy() {
        view.addSubview(resultLabel)
        view.addSubview(tagStackView)
        
        sortButtonList.forEach {
            tagStackView.addArrangedSubview($0)
        }
        
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
        
        tagStackView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(36)
        }
        
        simSortButton.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        
        dateSortButton.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
        
        ascSortButton.snp.makeConstraints { make in
            make.width.equalTo(90)
        }
        
        descSortButton.snp.makeConstraints { make in
            make.width.equalTo(90)
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagStackView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    func configureUI() {
        resultLabel.font = .boldSystemFont(ofSize: 15)
        resultLabel.textColor = ColorType.theme
        tagStackView.axis = .horizontal
        tagStackView.spacing = 4
        
        for idx in 0..<sortButtonList.count {
            let tagButton = sortButtonList[idx]
            
            if idx == 0 {
                tagButton.isClicked = true
            }
            
            tagButton.tag = idx
            tagButton.setTitle(SortOption.allCases[idx].title, for: .normal)
            tagButton.addTarget(self, action: #selector(tagButtonClicked), for: .touchUpInside)
        }
        
        emptyView.isHidden = true
        networkView.isHidden = true
        networkView.retryButton.addTarget(
            self,
            action: #selector(retryButtonClicked),
            for: .touchUpInside
        )
    }
    
    @objc func tagButtonClicked(_ sender: TagButton){
        sortButtonList.forEach { button in
            if button.tag == sender.tag {
                button.isClicked = true
            }else{
                button.isClicked = false
            }
        }
        
        viewModel.inputSortOptionIndex.value = sender.tag
    }
    
}

extension ResultViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputSearchResult.value?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as? ResultCollectionViewCell,
              let data = viewModel.outputSearchResult.value?.items else {
            return UICollectionViewCell()
        }
        
        cell.indexPath = indexPath
        cell.keyword = viewModel.inputSearchText.value
        cell.configureData(data[indexPath.item])
        
        if let id = Int(data[indexPath.item].productId) {
            cell.isClicked = viewModel.isExistLikeRealm(id)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { guard let data = viewModel.outputSearchResult.value?.items[indexPath.item] else { return }
        let detailVC = DetailViewController()
        detailVC.viewModel.inputShopResult.value = data
        transition(detailVC, .push)
    }
}

extension ResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for idx in indexPaths {
            guard let value = viewModel.outputSearchResult.value else { return }
            
            if idx.item == value.items.count - 4 {
                viewModel.inputPrefetchResult.value = ()
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
