//
//  NicknameViewModel.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/9/24.
//

import Foundation

final class NicknameViewModel{
    
    var inputViewDidLoadTrigger: Observable<Void?> = Observable(nil)
    var inputNickname: Observable<String> = Observable("")
    var outputNicknameText: Observable<String> = Observable("")
    var outputNicknameValid: Observable<Bool> = Observable(false)
    var inputSaveButton: Observable<Void?> = Observable(nil)
    var outputSaveButton: Observable<Void?> = Observable(nil)
    
    var viewType: ViewType = .nickname(.add)
    var profileImage: String?
    
    init(){
       transform()
    }
    
    private func transform(){
        inputViewDidLoadTrigger.bind { value in
            if UserManager.profileImage.isEmpty {
                self.profileImage = ProfileType.randomTitle
            }else{
                self.profileImage = UserManager.profileImage
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
            if self.outputNicknameValid.value {
                self.saveUserDefaultsData(self.viewType)
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
    
    private func saveUserDefaultsData(_ type: ViewType){
        switch type.detail {
        case .add:
            UserManager.isUser = true
            UserManager.nickname = inputNickname.value
            UserManager.joinDate = Date().toString()
            if let image = profileImage {
                UserManager.profileImage = image
            }
        case .edit:
            UserManager.nickname = inputNickname.value
            if let image = profileImage {
                UserManager.profileImage = image
            }
        }
    }
    
}
