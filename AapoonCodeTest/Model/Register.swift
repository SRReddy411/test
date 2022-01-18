//
//  Register.swift
//  AapoonCodeTest
//
//  Created by RamiReddy on 18/01/22.
//  Copyright © 2022 Volive Solurions . All rights reserved.
//

import Foundation


class Register {
    var firstName:String?
    var lastName:String?
    
    init(param:[String:Any]) {
        self.firstName = param["firstName"] as? String
        self.firstName = param["lastName"] as? String
    }
}
