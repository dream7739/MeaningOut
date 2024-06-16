//
//  SearchViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    let recentLabel = UILabel()
    
    let resetButton = UIButton()
    
    let tableView = UITableView()
    
    let emptyView = EmptyView()
    
    override func viewWillAppear(_ animated: Bool) {
        configureNav(.search)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.search)
        configureSearch()
        configureTableView()
        configureHierarchy()
        configureLayout()
        configureUI()
        
        resetButton.addTarget(self, action: #selector(resetButtonClicked), for: .touchUpInside)
    }
    
    func configureSearch(){
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchBar.searchTextField.placeholder = Constant.PlaceholderType.search.rawValue
        searchController.searchBar.delegate = self
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 46
    }
    
    @objc func resetButtonClicked(){
        UserManager.recentList.removeAll()
        UserManager.savedList = UserManager.recentList
        
        emptyView.isHidden = false
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
        recentLabel.text = "최근 검색"
        recentLabel.font = .systemFont(ofSize: 16, weight: .black)
        
        resetButton.setTitle("전체 삭제", for: .normal)
        resetButton.setTitleColor(Constant.ColorType.theme, for: .normal)
        resetButton.titleLabel?.font = Constant.FontType.tertiary
        
        if UserManager.savedList.isEmpty {
            emptyView.isHidden = false
        }else{
            UserManager.recentList = UserManager.savedList
            emptyView.isHidden = true
        }
        
    }
}

extension SearchViewController: UISearchBarDelegate {
    //검색 키를 누르면 검색 상세 화면으로 이동
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let input = searchBar.text!.trimmingCharacters(in: .whitespaces)
        
        if !input.isEmpty {
            UserManager.recentList.insert(input, at: 0)
            UserManager.savedList = UserManager.recentList
            
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
        return UserManager.recentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        cell.configureData(UserManager.recentList[indexPath.row])
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ResultViewController()
        vc.keyword = UserManager.recentList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension SearchViewController: CellProtocol {
    func cellItemClicked(indexPath: IndexPath) {
        UserManager.recentList.remove(at: indexPath.row)
        UserManager.savedList = UserManager.recentList
        tableView.reloadData()
        
        if UserManager.recentList.isEmpty {
            emptyView.isHidden = false
        }
    }
    
}
