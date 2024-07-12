//
//  DetailViewModel.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/11/24.
//

import Foundation

final class DetailViewModel {
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputShopResult: Observable<Shop?> = Observable(nil)
    var outputLikeisClicked: Observable<Bool> = Observable(false)
    var inputLikeButtonClicked: Observable<Void?> = Observable(nil)
    private let repository = RealmRepository()
    
    init(){
        transform()
    }
    
    func transform(){
        inputViewDidLoadTrigger.bind { value in
            guard let data = self.inputShopResult.value,
                  let id = Int(data.productId) else { return }
            
            self.outputLikeisClicked.value = self.isExistRealmItem(id)
        }
        
        inputLikeButtonClicked.bind { value in
            self.outputLikeisClicked.value.toggle()
            
            guard let data = self.inputShopResult.value,
                  let id = Int(data.productId) else { return }
            
            if self.outputLikeisClicked.value {
                self.addItemToRealm(data)
            }else{
                self.deleteItemFromRealm(id)
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
