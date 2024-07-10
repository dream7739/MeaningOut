//
//  ProfileViewModel.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/10/24.
//

import Foundation

final class ProfileViewModel {
    typealias ViewDetailType = ViewType.ViewDetailType

    let input = Input()
    let output = Output()
    
    init(){
        transform()
    }
    
    private func transform(){
        input.viewDidLoadTrigger.bind { _ in
            self.output.profileImage.closure?(
                self.output.profileImage.value
            )
        }
    }
}


extension ProfileViewModel {
    struct Input{
        var viewDidLoadTrigger: Observable<Void?> = Observable(nil)
        var viewType: Observable<ViewType?> = Observable(nil)
        var profileImageSender: Observable<((String?) -> Void)?> = Observable(nil)
    }
    
    struct Output {
        var profileImage: Observable<String?> = Observable(nil)
        var selectedIndexPath: Observable<IndexPath?> = Observable(nil)
    }
    
}
