//
//  SearchViewModel.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/11/24.
//

import Foundation

final class SearchViewModel {
    var inputSearchText: Observable<String?> = Observable(nil)
    var outputSearchText: Observable<Void?> = Observable(nil)
    var inputResetButtonClick: Observable<Void?> = Observable(nil)
    var inputDeleteButtonClick: Observable<Int> = Observable(0)
    var outputDeleteUserList: Observable<Void?> = Observable(nil)
    
    init(){
        transform()
    }
    
    private func transform(){
        inputSearchText.bind { value in
            self.saveUserSearchList(value)
            self.outputSearchText.value = ()
        }
        
        inputResetButtonClick.bind { _ in
            self.removeAllUserSearchList()
            self.outputDeleteUserList.value = ()
        }
        
        inputDeleteButtonClick.bind{ value in
            self.deleteUserSearchList(value)
            self.outputDeleteUserList.value = ()
        }
    }
}

extension SearchViewModel {
    private func saveUserSearchList(_ input: String?){
        if let savedInput = input?.lowercased(), !savedInput.isEmpty {
            if !UserManager.savedList.contains(savedInput){
                UserManager.savedList.insert(savedInput, at: 0)
            }
        }
    }
    
    private func removeAllUserSearchList(){
        UserManager.savedList.removeAll()
    }
    
    private func deleteUserSearchList(_ index: Int){
        UserManager.savedList.remove(at: index)
    }
}
