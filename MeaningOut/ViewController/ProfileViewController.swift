//
//  ProfileViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/14/24.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    
    let profileImage = RoundImageView(imageType: .highlight)
    let cameraImage = UIImageView()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
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
        configureUI()
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
        view.addSubview(profileImage)
        view.addSubview(cameraImage)
        view.addSubview(collectionView)
    }
    
    func configureLayout() {
        profileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.size.equalTo(130)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        cameraImage.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.bottom.equalTo(profileImage).inset(5)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        profileImage.image = UIImage(named: "profile_0")
        
        cameraImage.image = Constant.ImageType.photo
        cameraImage.contentMode = .center
        cameraImage.tintColor = .white
        cameraImage.backgroundColor = Constant.ColorType.theme
        cameraImage.layer.cornerRadius = 13
        cameraImage.clipsToBounds = true
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.ImageType.ProfileType.profileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as! ProfileCollectionViewCell
        cell.profileImage.image = Constant.ImageType.ProfileType.profileList[indexPath.row]
        return cell
    }
}
