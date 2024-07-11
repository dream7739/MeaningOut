//
//  ResultViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import RealmSwift
import SnapKit

final class ResultView: UIViewController {
    
    private let resultLabel = UILabel()
    private let emptyView = EmptyView(type: .result)
    private let networkView = NetworkView()
    
    private lazy var tagCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomLayout.sort(view).get()
    )
    private lazy var resultCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomLayout.product(view).get()
    )
    
    let viewModel = ResultViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.result(viewModel.inputSearchText.value ?? ""))
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(retryButtonClicked),
                                               name: ShopNotification.network,
                                               object: nil)
        
        //TODO: - 좋아요 개선: DetailVC에서 좋아요가 변경된 것을 어떻게 알 수 있을까?
        resultCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension ResultView {
    private func configureCollectionView(){
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        
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
        
        viewModel.inputSortOptionIndex.closure?(IndexPath(item: 0, section: 0))
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
    private func retryButtonClicked(notification: Notification){
        viewModel.inputRetryButtonClick.value = ()
    }
}

extension ResultView: BaseProtocol {
    
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
        resultLabel.font = .boldSystemFont(ofSize: 15)
        resultLabel.textColor = Design.ColorType.theme
        emptyView.isHidden = true
        networkView.isHidden = true
    }
}

extension ResultView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return Display.SortOption.allCases.count
        }else{
            return viewModel.outputSearchResult.value?.items.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let data = Display.SortOption.allCases[indexPath.item]
            cell.configureData(data)
            
            if indexPath == viewModel.inputSortOptionIndex.value {
                cell.isClicked = true
            }else {
                cell.isClicked = false
            }
            
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as? ResultCollectionViewCell,
                  let data = viewModel.outputSearchResult.value?.items else {
                return UICollectionViewCell()
            }
            
            cell.indexPath = indexPath
            cell.keyword = viewModel.inputSearchText.value
            cell.configureData(data[indexPath.item])
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tagCollectionView {
            let label = PaddingLabel()
            label.text = Display.SortOption.allCases[indexPath.item].title
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
            if viewModel.inputSortOptionIndex.value != indexPath {
                viewModel.inputSortOptionIndex.value = indexPath
                tagCollectionView.reloadData()
            }
        }else if collectionView == resultCollectionView {
            guard let data = viewModel.outputSearchResult.value?.items[indexPath.item] else { return }
            let detailVC = DetailViewController()
            detailVC.data = data
            transition(detailVC, .push)
        }
    }
}

extension ResultView: UICollectionViewDataSourcePrefetching {
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
