//
//  SearchViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

final class SearchView: UIViewController {
    private let searchController = UISearchController()
    private let recentLabel = UILabel()
    private let resetButton = UIButton()
    private let tableView = UITableView()
    private let emptyView = EmptyView(type: .search)
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.search)
        configureHierarchy()
        configureLayout()
        configureUI()
        configureSearch()
        configureTableView()
        configureEmptyView()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav(.search)
        
        searchController.searchBar.searchTextField.text = ""
        searchController.isActive = false
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteButtonClicked),
                                               name: ShopNotification.delete,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension SearchView {
    private func bindData(){
        viewModel.outputSearchText.bind { _ in
            self.tableView.reloadData()
            let resultVC = ResultViewController()
            if let keyword = self.viewModel.inputSearchText.value {
                resultVC.keyword = keyword
            }
            self.transition(resultVC, .push)
        }
        
        viewModel.outputDeleteUserList.bind { _ in
            self.configureEmptyView()
            self.tableView.reloadData()
        }
    }
    
    private func configureEmptyView(){
        if UserManager.savedList.isEmpty {
            self.emptyView.isHidden = false
            self.searchController.searchBar.searchTextField.text = ""
            self.searchController.isActive = false
        }else{
            self.emptyView.isHidden = true
        }
    }
    
    private func configureSearch(){
        navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.placeholder = Display.Placeholder.search.rawValue
        searchController.searchBar.tintColor = Design.ColorType.black
        searchController.searchBar.delegate = self
    }
    
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 46
    }
    
    @objc 
    private func resetButtonClicked(){
        viewModel.inputResetButtonClick.value = ()
    }
    
    @objc 
    private func deleteButtonClicked(notification: Notification){
        guard let indexPath = notification.userInfo?[ShopNotificationKey.indexPath] as? IndexPath else { return }
        
        viewModel.inputDeleteButtonClick.value = indexPath.row

    }
    
}

extension SearchView: BaseProtocol {
    func configureHierarchy() {
        view.addSubview(recentLabel)
        view.addSubview(resetButton)
        view.addSubview(tableView)
        view.addSubview(emptyView)
    }
    
    func configureLayout() {
        recentLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        resetButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerY.equalTo(recentLabel)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(recentLabel.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        searchController.searchBar.searchTextField.backgroundColor = Design.ColorType.tertiary.withAlphaComponent(0.1)
        
        recentLabel.text = "최근 검색"
        recentLabel.font = .systemFont(ofSize: 16, weight: .black)
        
        resetButton.setTitle("전체 삭제", for: .normal)
        resetButton.setTitleColor(Design.ColorType.theme, for: .normal)
        resetButton.titleLabel?.font = Design.FontType.tertiary
        
        resetButton.addTarget(
            self,
            action: #selector(resetButtonClicked),
            for: .touchUpInside
        )
        
    }
}

extension SearchView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchText.value = searchBar.text?.trimmingCharacters(in: .whitespaces)
    }
}

extension SearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserManager.savedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        cell.configureData(UserManager.savedList[indexPath.row])
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ResultViewController()
        vc.keyword = UserManager.savedList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

