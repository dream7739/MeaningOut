//
//  ProfileViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    private let profileView = RoundProfileView()
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomLayout.profile(view).get()
    )
    
    var viewType: ViewType = .profile(.add)
    var profileImage: String?
    var profileImageSender: ((String?) -> Void)?
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(viewType)
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        profileImageSender?(profileImage)
    }
    
}

extension ProfileViewController {
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
    }
}

extension ProfileViewController: BaseProtocol {
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
    
    func configureUI() {
        if let profileImage {
            profileView.profileImage.image = UIImage(named: profileImage)
        }
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell()
        }
        
        let data = ProfileType.allCases[indexPath.row]
        
        cell.configureData(data: data)
        
        guard let selectedIndexPath = selectedIndexPath else{
            if profileImage == data.rawValue {
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
        profileImage = ProfileType.allCases[indexPath.item].rawValue
        profileView.profileImage.image = UIImage(named: profileImage ?? "")
        selectedIndexPath = indexPath
        collectionView.reloadData()
    }
}

