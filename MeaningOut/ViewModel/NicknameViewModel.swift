//
//  NicknameViewModel.swift
//  MeaningOut
//
//  Created by 홍정민 on 7/9/24.
//

import Foundation

class NicknameViewModel{
    var inputNickname: Observable<String> = Observable("")
    
    var outputNicknameText: Observable<String> = Observable("")
    
    var outputNicknameValid: Observable<Bool> = Observable(false)
    
    
    init(){
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
    }
    
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
    
}
