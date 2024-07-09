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
        collectionViewLayout: layout()
    )
    
    var selectedIndexPath: IndexPath?
    var selectedProfile: String?
    var profileDataSender: ((_ data: String?) -> Void)?
    
    var viewType: ViewType!
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.collectionView?.isScrollEnabled = false
        
        let spacing: CGFloat = 10
        let verticalInset: CGFloat = 20
        let horizontalInset: CGFloat = 30
        let width = (view.bounds.width - (spacing * 2) - (horizontalInset * 2)) / 3
        
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        
        return layout
    }
    
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
        profileDataSender?(selectedProfile)
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
    
    func configureUI(){
        if let selectedProfile {
            profileView.profileImage.image = UIImage(named: selectedProfile)
        }
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Design.ProfileType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell()
        }
        
        let data = Design.ProfileType.allCases[indexPath.row]
        
        cell.configureData(data: data)
        
        guard let selectedIndexPath else {
            if let selectedProfile, selectedProfile == data.rawValue {
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
        selectedIndexPath = indexPath
        collectionView.reloadData()
        guard let selectedPath =  selectedIndexPath else { return }
        let image = Design.ProfileType.allCases[selectedPath.row].rawValue
        selectedProfile = image
        profileView.profileImage.image = UIImage(named: image)
    }
}

