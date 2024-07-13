//
//  ResultViewModel.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/11/24.
//

import Foundation

final class ResultViewModel {
    typealias SortOption = ResultViewController.SortOption

    var inputSearchText: Observable<String?> = Observable(nil)
    var inputSortOptionIndex: Observable<Int> = Observable(0)
    var inputSearchRequest: Observable<ShopRequest?> = Observable(nil)
    var outputSearchResult: Observable<ShopResult?> = Observable(nil)
    var inputRetryButtonClick: Observable<Void?> = Observable(nil)
    var inputLikeButtonClicked: Observable<Shop?> = Observable(nil)
    var inputLikeIsClicked: Observable<Bool> = Observable(false)
    var inputLikeSelectedIndex: Observable<IndexPath?> = Observable(nil)
    var outputNetworkConnect: Observable<Bool> = Observable(false)
    var outputEmptyResult: Observable<Bool> = Observable(false)
    var inputPrefetchResult: Observable<Void?> = Observable(nil)

    private let repository = RealmRepository()
    
    init(){
        transform()
    }
    
    func transform(){
        inputSearchText.bind { value in
            guard let value else { return }
            
            let sort = SortOption.allCases[self.inputSortOptionIndex.value].title
            
            self.inputSearchRequest.value = ShopRequest(
                query: value,
                start: 1,
                display: 30,
                sort: sort
            )
        }
        
        inputSortOptionIndex.bind { value in
            self.inputSearchRequest.value?.sort = SortOption.allCases[value].sortParam
            self.inputSearchRequest.value?.start = 1
            self.callNaverShopAPI()
        }
        
        inputRetryButtonClick.bind { value in
            self.callNaverShopAPI()
        }
        
        inputLikeButtonClicked.bind { value in
            guard let value else { return }
            self.saveLikeListToRealm(value)
        }
        
        inputPrefetchResult.bind { value in
            let start = self.inputSearchRequest.value!.start
            let total = self.outputSearchResult.value!.total
            
            self.inputSearchRequest.value!.start += 30
            
            if start <= 1000 && start <= total {
                self.callNaverShopAPI()
            }
        }
        
    }
}

extension ResultViewModel {
    private func callNaverShopAPI(){
        if NetworkMonitor.shared.isConnected {
            outputNetworkConnect.value = true
        }else{
            outputNetworkConnect.value = false
            return
        }
        
        guard let request = inputSearchRequest.value else { return }
        
        APIManager.shared.request(
            model: ShopResult.self,
            request: .shop(request: request)
        ){ result in
            switch result {
            case .success(let value):
                
                if value.total == 0 {
                    self.outputEmptyResult.value = true
                    return
                }
                
                if request.start == 1 {
                    self.outputSearchResult.value = value
                }else{
                    self.outputSearchResult.value?.items.append(contentsOf: value.items)
                }
                
            case .failure(let error):
                print(error)
                self.outputSearchResult.value = nil
            }
        }
    }
    
    private func saveLikeListToRealm(_ data: Shop){
        if inputLikeIsClicked.value {
            repository.addLike(data.managedObject())
        }else{
            guard let productId = Int(data.productId) else { return }
            repository.deleteLike(productId)
        }
    }
    
    func isExistLikeRealm(_ id: Int) -> Bool{
        return repository.isExistLike(id: id)
    }
}
