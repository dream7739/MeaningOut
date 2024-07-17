//
//  DetailViewModel.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/11/24.
//

import Foundation

final class DetailViewModel {
    var inputViewWillAppearTrigger: Observable<Void?> = Observable(nil)
    var inputShopResult: Observable<Shop?> = Observable(nil)
    var outputLikeisClicked: Observable<Bool> = Observable(false)
    var inputLikeButtonClicked: Observable<Void?> = Observable(nil)
   
    private let repository = RealmRepository()
    
    init(){
        print("Detail ViewModel init")
        transform()
    }
    
    deinit {
        print("Detail ViewModel Deinit")
    }
    
    func transform(){
        inputViewWillAppearTrigger.bind { [weak self] value in
            guard let data = self?.inputShopResult.value,
                  let id = Int(data.productId) else { return }
            
            self?.outputLikeisClicked.value = self?.isExistRealmItem(id) ?? false
        }
        
        inputLikeButtonClicked.bind { [weak self] value in
            self?.outputLikeisClicked.value.toggle()
            
            guard let data = self?.inputShopResult.value,
                  let id = Int(data.productId) else { return }
            
            if self?.outputLikeisClicked.value ?? false {
                self?.addItemToRealm(data)
            }else{
                self?.deleteItemFromRealm(id)
            }
        }
    }
}

extension DetailViewModel {
    private func isExistRealmItem(_ id: Int) -> Bool{
        return repository.isExistLike(id: id)
    }
    
    private func addItemToRealm(_ data: Shop){
        repository.addLike(data.managedObject())

    }
    
    private func deleteItemFromRealm(_ id: Int) {
        repository.deleteLike(id)
    }
}
