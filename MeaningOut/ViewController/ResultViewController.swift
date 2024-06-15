//
//  ResultViewController.swift
//  MeaningOut
//
//  Created by 홍정민 on 6/15/24.
//

import UIKit
import SnapKit

class ResultViewController: UIViewController {
    
    let resultLabel = UILabel()
    
    lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: tagLayout())
    
    lazy var resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: resultLayout())
    
    func tagLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let horizontalInset: CGFloat = 20
        let verticalInset: CGFloat = 10
        
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        return layout
    }
    
    func resultLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let horizontalInset: CGFloat = 20
        let verticalInset: CGFloat = 10
        let width: CGFloat = (view.bounds.width - spacing - horizontalInset * 2) / 2
        let height: CGFloat = (view.bounds.height - spacing - verticalInset * 2) / 2.9
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        
        
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }
    
    var keyword: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNav(.result)
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
        
        navigationItem.title = keyword
    }
    
    func configureCollectionView(){
//        tagCollectionView.delegate = self
//        tagCollectionView.dataSource = self
        
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.identifier)
        
    }
    
}

extension ResultViewController: BaseProtocol {
    
    func configureHierarchy() {
        view.addSubview(resultLabel)
        view.addSubview(tagCollectionView)
        view.addSubview(resultCollectionView)
    }
    
    func configureLayout() {
        resultLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagCollectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }

    }
    
    func configureUI() {
        resultLabel.text = "235499개의 검색결과"
        resultLabel.font = Constant.FontType.tertiary
        resultLabel.textColor = Constant.ColorType.theme
        
        tagCollectionView.backgroundColor = .red
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.identifier, for: indexPath) as! ResultCollectionViewCell
        return cell
    }
    
    
}
