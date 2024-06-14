//
//  ProfileViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    let profileView = RoundProfileView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    var selectedIndexPath: IndexPath?
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.collectionView?.isScrollEnabled = false

        let spacing: CGFloat = 10
        let sectionInset: CGFloat = 20
        let width = (view.bounds.width - (spacing * 3) - (sectionInset * 2)) / 4
        
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        
        return layout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.profile)
        configureHierarchy()
        configureLayout()
        configureCollectionView()
    }
    
    func configureCollectionView(){
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
    
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.ImageType.ProfileType.profileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as! ProfileCollectionViewCell
        
        cell.delegate = self
        
        cell.profileImage.image = Constant.ImageType.ProfileType.profileList[indexPath.row]
        
        if indexPath == selectedIndexPath {
            cell.isClicked = true
        }else{
            cell.isClicked = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProfileCollectionViewCell
        profileView.profileImage.image = Constant.ImageType.ProfileType.profileList[indexPath.row]
        cell.delegate?.profileClicked(indexPath: indexPath)
    }
    
}

extension ProfileViewController: ProfileProtocol {
    func profileClicked(indexPath: IndexPath) {
        selectedIndexPath = indexPath
        collectionView.reloadData()
    }
}
