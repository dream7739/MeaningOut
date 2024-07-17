//
//  SettingViewModel.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/11/24.
//

import Foundation

final class SettingViewModel {
    
    private let repository = RealmRepository()
    
    var inputLeaveClicked: Observable<Void?> = Observable(nil)

    init(){
        print("Setting ViewModel init")
        transform()
    }
    
    deinit {
        print("Setting ViewModel Deinit")
    }
    
    func transform(){
        inputLeaveClicked.bind { [weak self] _ in
            self?.resetAllUserData()
        }
    }
}

extension SettingViewModel {
    private func resetAllUserData(){
        repository.deleteAll()
        UserManager.resetAll()
    }
}
