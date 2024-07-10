//
//  NicknameViewModel.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/9/24.
//

import Foundation

final class NicknameViewModel{
    typealias ViewDetailType = ViewType.ViewDetailType
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputViewType: Observable<ViewDetailType?> = Observable(nil)
    var outputProfileImage: Observable<String?> = Observable("")
    var inputNickname: Observable<String> = Observable("")
    var outputNicknameText: Observable<String> = Observable("")
    var outputNicknameValid: Observable<Bool> = Observable(false)
    var inputSaveButton: Observable<Void?> = Observable(nil)
    var outputSaveButton: Observable<Void?> = Observable(nil)
    
    init(){
       print(self, #function)
       transform()
    }
    
    private func transform(){
        inputViewDidLoadTrigger.bind { value in
            
            if UserManager.profileImage.isEmpty {
                self.outputProfileImage.value = Design.ProfileType.randomTitle
            }else{
                self.outputProfileImage.value = UserManager.profileImage
            }
        } 
        
        inputViewType.bind { value in
            if value == .edit {
                self.inputNickname.value = UserManager.nickname
            }
        }
        
        inputNickname.bind { value in
            do {
                self.outputNicknameValid.value = try self.validateUserInput(value)
                self.outputNicknameText.value = "사용 가능한 닉네임입니다 :)"
            }catch Validation.Nickname.isEmpty {
                self.outputNicknameValid.value = false
                self.outputNicknameText.value =  Validation.Nickname.isEmpty.description
            }catch Validation.Nickname.countLimit {
                self.outputNicknameValid.value = false
                self.outputNicknameText.value =  Validation.Nickname.countLimit.description
            }catch Validation.Nickname.isNumber{
                self.outputNicknameValid.value = false
                self.outputNicknameText.value = Validation.Nickname.isNumber.description
            }catch Validation.Nickname.isSpecialChar {
                self.outputNicknameValid.value = false
                self.outputNicknameText.value = Validation.Nickname.isSpecialChar.description
            }catch {
                print(#function, "error occured")
            }
        }
        
        inputSaveButton.bind { value in
            guard let viewType = self.inputViewType.value else { return }
            if self.outputNicknameValid.value {
                self.saveUserDefaultsData(viewType)
                self.outputSaveButton.value = ()
            }
        }
    }
    
}

extension NicknameViewModel {
    @discardableResult
    private func validateUserInput(_ input: String) throws -> Bool {
        guard !input.isEmpty else{
            throw Validation.Nickname.isEmpty
        }
        
        guard input.count >= 2 && input.count <= 10 else {
            throw Validation.Nickname.countLimit
        }
        
        guard (input.range(of:  #"[@#$%]"#, options: .regularExpression) == nil) else {
            throw Validation.Nickname.isSpecialChar
        }
        
        guard (input.range(of: #"[0-9]"#, options: .regularExpression) == nil) else {
            throw Validation.Nickname.isNumber
        }
        
        return true
    }
    
    private func saveUserDefaultsData(_ type: ViewDetailType){
        switch type {
        case .add:
            UserManager.isUser = true
            if let image = outputProfileImage.value {
                UserManager.profileImage = image
            }
            UserManager.nickname = inputNickname.value
            UserManager.joinDate = Date().toString()
        case .edit:
            UserManager.nickname = inputNickname.value
            if let image = outputProfileImage.value {
                UserManager.profileImage = image
            }
        }
    }
    
}
