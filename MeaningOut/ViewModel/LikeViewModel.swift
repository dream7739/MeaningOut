//
//  LikeViewModel.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/12/24.
//

import Foundation
import RealmSwift

final class LikeViewModel {
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    var ouputLikeResult: Observable<Results<Like>?> = Observable(nil)
    var outputLikeResultCount: Observable<Int> = Observable(0)
    var inputLikeButtonClicked: Observable<Void?> = Observable(nil)
    var inputLikeIndexPath: Observable<IndexPath> = Observable(IndexPath(item: 0, section: 0))
    var inputLikeIsClicked: Observable<Bool> = Observable(false)
    var inputSearchText: Observable<String> = Observable("")
    
    private let repository = RealmRepository()
 
    init(){
        print("Like ViewModel init")
        transform()
    }
    
    deinit {
        print("Like ViewModel Deinit")
    }
    
    func transform(){
        inputViewWillAppearTrigger.bind { [weak self] _ in
            self?.ouputLikeResult.value = self?.fetchLikeListRealm()
            self?.outputLikeResultCount.value = self?.ouputLikeResult.value?.count ?? 0
        }
        
        inputLikeButtonClicked.bind { [weak self] value in
            if !(self?.inputLikeIsClicked.value ?? false) {
                guard let item = self?.ouputLikeResult.value else { return }
                self?.deleteLikeRealm(item[self?.inputLikeIndexPath.value.item ?? 0])
                self?.ouputLikeResult.value = self?.fetchLikeListRealm()
                self?.outputLikeResultCount.value = self?.ouputLikeResult.value?.count ?? 0

            }
        }
        
        inputSearchText.bind { [weak self] value in
            if value.isEmpty {
             self?.ouputLikeResult.value = self?.fetchLikeListRealm()
            }else{
                self?.ouputLikeResult.value = self?.fetchLikeListRealm(value)
            }
            
            self?.outputLikeResultCount.value = self?.ouputLikeResult.value?.count ?? 0
        }
    }
}

extension LikeViewModel {
    private func fetchLikeListRealm() -> Results<Like> {
        repository.fetchAll()
    }
    
    private func deleteLikeRealm(_ item: Like){
        repository.deleteLike(item)
    }
    
    private func fetchLikeListRealm(_ keyword: String) -> Results<Like> {
        repository.fetchAll(keyword)
    }
}
