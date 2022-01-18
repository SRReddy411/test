//
//  ArrayDataModel.swift
//  AapoonCodeTest
//
//  Created by RamiReddy on 18/01/22.
//  Copyright © 2022 Volive Solurions . All rights reserved.
//

 
import Foundation
 
class ComapaniesViewModel {
    
    var errorMessage = {(message : String) -> () in }
    var successMessage = {(message:String)->()in}
    var reloadList = {() -> () in }

    
//    var companiesListDataArray : [CompaniesModel] = []{
//
//        didSet{
//            reloadList()
//        }
//    }
//
//    var cityListArray : [CitiesModel] = []{
//
//        didSet{
//            reloadList()
//        }
//    }
    
//    func  getListOfComapniesService(serviceID:String,cityID:String){
//        
//        //http://volive.in/tawasal/api/services/listofcompanies?api_key=2308699&lang=en&service_category_id=2
//        if ReachabilityFile .isConnectedToNetwork() {
//             let language = Localize.currentLang()
//            let params = [ "api_key":API_KEY,"lang":language.selectLanguage,"service_category_id":serviceID,"city":cityID] as [String:AnyObject]
//            
//            ServiceCallHelper.sharedInstance.featchDataServiceCall(url:  LIST_COMANIES_API , postDict: params) { (responseData, error) in
//                 print("response of services list ",responseData)
//                
//                let status:Int =   Int(responseData["status"] as! Int)
//                self.companiesListDataArray.removeAll()
//                if status == 1{
// 
//                    if let listArrya = responseData["data"] as? [[String: Any]] {
//                        
//                        for list in listArrya {
//                            let object = CompaniesModel(data: list as NSDictionary)
//                            self.companiesListDataArray.append(object)
//                        }
//                        print("features list",self.companiesListDataArray.count)
//                    }
//                    
//                }else{
//                    
//                     self.errorMessage(responseData["message"] as! String)
//                }
//            }
//            
//        }else{
//             self.errorMessage("Please check your internet connection".localizedString)
//            
//        }
//    }
//    
//    func getListOfCitiesService( ){
//        
//        //http://volive.in/tawasal/api/services/cities?api_key=2308699&lang=en
//        if ReachabilityFile .isConnectedToNetwork() {
//             let language = Localize.currentLang()
//            let params = [ "api_key":API_KEY,"lang":language.selectLanguage] as [String:AnyObject]
//            
//            ServiceCallHelper.sharedInstance.featchDataServiceCall(url:  CITY_API , postDict: params) { (responseData, error) in
//                 print("response of services list ",responseData)
//                
//                let status:Int =   Int(responseData["status"] as! Int)
//                self.cityListArray.removeAll()
//                if status == 1{
// 
//                    if let listArrya = responseData["data"] as? [[String: Any]] {
//                        
//                        for list in listArrya {
//                            let object = CitiesModel(data: list as NSDictionary)
//                            self.cityListArray.append(object)
//                        }
//                        print("cities list",self.cityListArray.count)
//                    }
//                    
//                }else{
//                    
//                     self.errorMessage(responseData["message"] as! String)
//                }
//            }
//            
//        }else{
//             self.errorMessage("Please check your internet connection".localizedString)
//            
//        }
//    }
    
}
