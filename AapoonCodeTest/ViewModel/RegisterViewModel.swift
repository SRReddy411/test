//
//  RegisterViewModel.swift
//  AapoonCodeTest
//
//  Created by RamiReddy on 18/01/22.
//  Copyright © 2022 Volive Solurions . All rights reserved.
//

import Foundation


class RegisterViewModel{
    static let shared = RegisterViewModel()
    
    func txtHandler(model:Register) -> (Bool,String){
        var status = true
        var error = ""
        
        if model.firstName?.isEmpty ?? false {
            status = false
            error = "Please ente firstName"
        }
        return (status,error)
    }
}
