//
//  ProfileViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

final class ProfileView: UIViewController {
    private let profileView = RoundProfileView()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomLayout.profile(view).get()
    )
    
    let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(viewModel.inputViewType.value!)
        configureHierarchy()
        configureLayout()
        configureCollectionView()
        bindData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.profileImageSender.value?(viewModel.outputProfileImage.value)
    }
    
}

extension ProfileView {
    private func bindData(){
        viewModel.outputProfileImage.bind { value in
            if let value {
                self.profileView.profileImage.image = UIImage(named: value)
            }
        }
        
        viewModel.outputSelectedIndexPath.bind { _ in
            self.collectionView.reloadData()
        }
        
        viewModel.inputViewDidLoadTrigger.value = ()
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
    }
}

extension ProfileView: BaseProtocol {
    func configureHierarchy() {
        view.addSubview(profileView)
        view.addSubview(collectionView)
    }
    
    func configureLayout() {
        profileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.size.equalTo(130)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension ProfileView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Design.ProfileType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell()
        }
        
        let data = Design.ProfileType.allCases[indexPath.row]
        
        cell.configureData(data: data)
        
        guard let selectedIndexPath = viewModel.outputSelectedIndexPath.value else{
            if viewModel.outputProfileImage.value == data.rawValue {
                cell.isClicked = true
            }else{
                cell.isClicked = false
            }
            return cell
        }
            
        if selectedIndexPath == indexPath {
            cell.isClicked = true
        }else{
            cell.isClicked = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.outputProfileImage.value = Design.ProfileType.allCases[indexPath.item].rawValue
        viewModel.outputSelectedIndexPath.value = indexPath
    }
}

