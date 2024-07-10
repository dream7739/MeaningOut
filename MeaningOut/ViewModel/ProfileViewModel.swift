//
//  ProfileViewModel.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/10/24.
//

import Foundation

final class ProfileViewModel {
    typealias ViewDetailType = ViewType.ViewDetailType
        
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputViewType: Observable<ViewType?> = Observable(nil)
    var outputProfileImage: Observable<String?> = Observable(nil)
    var profileImageSender: Observable<((String?) -> Void)?> = Observable(nil)
    var outputSelectedIndexPath: Observable<IndexPath?> = Observable(nil)
    
    init(){
        transform()
    }
    
    private func transform(){
        inputViewDidLoadTrigger.bind { _ in
            self.outputProfileImage.closure?(self.outputProfileImage.value)
        }
    }
}


