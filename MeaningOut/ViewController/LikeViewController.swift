//
//  LikeViewControlller.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/6/24.
//

import UIKit
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
        configureNav(NavigationTitle.like)
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
        configureSearchController()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputViewWillAppearTrigger.value = ()
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        print("LikeVC init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("LikeVC Deinit")
    }
    
}

extension LikeViewController {
    private func bindData(){
        viewModel.ouputLikeResult.bind { [weak self] value in
            self?.resultCollectionView.reloadData()
        }
        
        viewModel.outputLikeResultCount.bind { [weak self] value in
            if value == 0 {
                self?.emptyView.isHidden = false
            }else{
                self?.emptyView.isHidden = true
            }
            
            self?.resultLabel.text = value.formatted() + "개의 좋아요한 상품"
        }
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
    
}

extension LikeViewController: ResultLikeDelegate {
    func likeButtonClicked(_ indexPath: IndexPath, _ isClicked: Bool) {
        viewModel.inputLikeIndexPath.value = indexPath
        viewModel.inputLikeIsClicked.value = isClicked
        
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
        
        cell.delegate = self
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
