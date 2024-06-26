//
//  SearchViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    private let searchController = UISearchController()
    
    private let recentLabel = UILabel()
    
    private let resetButton = UIButton()
    
    private let tableView = UITableView()
    
    private let emptyView = EmptyView(type: .search)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.search)
        configureSearch()
        configureTableView()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        resetButton.addTarget(
            self,
            action: #selector(resetButtonClicked),
            for: .touchUpInside
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav(.search)
        
        searchController.searchBar.searchTextField.text = ""
        
        searchController.isActive = false
        
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

extension SearchViewController {
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
    
    private func setContentEmpty(){
        emptyView.isHidden = false
        searchController.searchBar.searchTextField.text = ""
        searchController.isActive = false
    }
    
    @objc 
    private func resetButtonClicked(){
        UserManager.savedList.removeAll()
        setContentEmpty()
    }
    
    @objc 
    private func deleteButtonClicked(notification: Notification){
        guard let indexPath = notification.userInfo?[ShopNotificationKey.indexPath] as? IndexPath else { return }
        UserManager.savedList.remove(at: indexPath.row)
        tableView.reloadData()
        
        if UserManager.savedList.isEmpty {
            setContentEmpty()
        }
    }
    
}

extension SearchViewController: BaseProtocol {
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
        
        if UserManager.savedList.isEmpty {
            emptyView.isHidden = false
        }else{
            UserManager.savedList = UserManager.savedList
            emptyView.isHidden = true
        }
        
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let input = searchBar.text!.trimmingCharacters(in: .whitespaces)
        
        if !input.isEmpty {
            let savedInput = input.lowercased()
            
            if !UserManager.savedList.contains(savedInput){
                UserManager.savedList.insert(savedInput, at: 0)
            }
            
            if !emptyView.isHidden {
                emptyView.isHidden.toggle()
            }
            
            tableView.reloadData()
            
            let vc = ResultViewController()
            vc.keyword = input
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
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

