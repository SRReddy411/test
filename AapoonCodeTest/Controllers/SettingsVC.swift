//
//  WeatherManager.swift
//  AapoonCodeTest
//
//  Created by Apple on 16/12/21.
//  Copyright © 2021 Volive Solurions . All rights reserved.
//

import UIKit
import MOLH
import GoogleMaps
import CoreLocation
import Alamofire
import SDWebImage
import QCropper
import BSImagePicker
import Photos


//Rami
struct categoryStruct {
    var categoryID:String!
    var categoryName:String!
    var categorySelectState:String!
    var categoryImage:String!
}



class SettingsVC: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate,GMSMapViewDelegate,UITextViewDelegate,UIScrollViewDelegate {
    
    //Rami
    var categoryArrayData = [categoryStruct]()
    
    
    
    
    @IBOutlet weak var confirmAccountNoTF: UITextField!
    @IBOutlet weak var confirmAccountNoView: UIView!
    @IBOutlet weak var accountNoTF: UITextField!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var routingView: UIView!
    @IBOutlet weak var routingNumberTF: UITextField!
    @IBOutlet weak var uploadChefImage: UIImageView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var basicDetailsView: UIView!
    @IBOutlet weak var chefDetailsView: UIView!
    @IBOutlet weak var changePwdView: UIView!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var expTF: UITextField!
    
    
    @IBOutlet weak var addressLbl : UILabel!
    
    @IBOutlet weak var emailIDTF: UITextField!
    @IBOutlet weak var currentPwdTf: UITextField!
    @IBOutlet weak var newPwdTF: UITextField!
    @IBOutlet weak var confirmPwdTF: UITextField!
    @IBOutlet weak var descTV: UITextView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var expView: UIView!
    @IBOutlet weak var currentPwdView: UIView!
    @IBOutlet weak var confirmPwdView: UIView!
    @IBOutlet weak var newPwdView: UIView!
    @IBOutlet weak var certificateCollectionView: UICollectionView!
    @IBOutlet weak var servicesCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    var params = [String:Any]()
    
    var routing_number = ""
    var account_number = ""
    var lastName = ""
    var name = ""
    var email = ""
    var phone = ""
    var userImage = ""
    var locationstr = ""
    var expStr = ""
    var descStr = ""
    var background_image = ""
    //    var langSpoke = ""
    //    var bio = ""
    //    var splogo = ""
    //    var dietCenterName = ""
    var latitudeString : String!
    var longitudeString : String!
    var cityStr : String! = ""
    var checkmapStr : String?
    var certificateArray = [SPCertificateModel]()
    var picker = UIImagePickerController()
    var pickedImage = UIImage()
    var imgPicker: UIImagePickerController? = UIImagePickerController()
    var seletionImgsArray  = [UIImage]()
    // var seletionImgsArray : [Any] = []
    var carsImage:UIImage!
    var checkUploadImagePinCheck:String!
    var expIdString : String! = ""
    var expString : String! = ""
    //PICKERVIEW PROPERTIES
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    var expArray = [String]()
    var expIDArray = ["1","2","3","4","5","6","7","8","9","10","11","12","13"]
    var itemIdString : String! = ""
    var itemMain_IdString : String! = ""
    
    var selectedSubServiceIDs = [String]()
    var selectedSubServiceNames = [String]()
    
    var selected_MainServiceIDs = [String]()
    var selected_MainServiceNames = [String]()
    
    var serviceNameString : String! = ""
    var service_MainNameString : String! = ""
    var categoriesArray = [CategoryModel]()
    var servicesArray = [ServicesModel]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        servicesCollectionView.dataSource = self
        servicesCollectionView.delegate = self
        
        self.profileView.dropShadow1()
        self.basicDetailsView.dropShadow1()
        self.chefDetailsView.dropShadow1()
        self.changePwdView.dropShadow1()
        self.settingsView.showLoader()
        
        self.nameView.dropShadow2()
        self.phoneView.dropShadow2()
        
        //self.accountView.dropShadow2()
        //self.confirmAccountNoView.dropShadow2()
        // self.routingView.dropShadow2()
        
        self.emailView.dropShadow2()
        self.addressView.dropShadow2()
        
        self.descTV.dropShadow2()
        self.expView.dropShadow2()
        self.currentPwdView.dropShadow2()
        self.confirmPwdView.dropShadow2()
        self.newPwdView.dropShadow2()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getLocation(_:)), name: NSNotification.Name(rawValue: "getLocation"), object: nil)
        
        //        expArray = [languageChangeString(a_str: "1 year"),languageChangeString(a_str: "2 years"),languageChangeString(a_str: "3 years"),languageChangeString(a_str: "4 years"),languageChangeString(a_str: "5 years"),languageChangeString(a_str: "6 years"),languageChangeString(a_str: "7 years"),languageChangeString(a_str: "8 years"),languageChangeString(a_str: "9 years"),languageChangeString(a_str: "10 years"),languageChangeString(a_str: "11 years"),languageChangeString(a_str: "12 years"),languageChangeString(a_str: "13 years")] as! [String]
        expArray = [languageChangeString(a_str: "1-5 years"),
                    languageChangeString(a_str: "6-10 years"),
                    languageChangeString(a_str: "10-20 years"),
                    languageChangeString(a_str: "20+ years")] as! [String]
        if Reachability.isConnectedToNetwork(){
            getProfile()
           
        }else{
            showToastForInternet(message: languageChangeString(a_str: "Please check your internet connection")!)
        }
        // Do any additional setup after loading the view.
    }
    @objc func removeLoader(){
        self.settingsView.hideLoader()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    @objc func getLocation(_ notification: NSNotification){
        print(notification.userInfo ?? "")
        
        if let dict = notification.userInfo as NSDictionary? {
            latitudeString = dict["key"] as? String
            longitudeString = dict["key1"] as? String
            cityStr = dict["key2"] as? String
            checkmapStr = dict["map"] as? String
           
          
            self.addressLbl.text = cityStr
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        nameLabel.text = ""
        emailLabel.text = ""
        addressLabel.text = ""
        
        self.navigationController?.isNavigationBarHidden = true
    }
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool){
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    //MARK:- SAVE CHANGES BTN ACTION
    @IBAction func saveChangesBtnAction(_ sender: Any) {
        
        
        //Rami
        if self.categoryArrayData.isEmpty{
            
        }else{
            let selectedCategoryIDs = self.categoryArrayData.filter{ $0.categorySelectState != "0"  }
            
            print("categorys selected ids",selectedCategoryIDs)
            let formattedArray = (selectedCategoryIDs.map{String($0.categoryID)}).joined(separator: ",")
            
            print("category ids are.....",formattedArray)
            
        }
        
    
    }
    @IBAction func onTapAddressAction(_ sender: Any) {
        let gotoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetLocationVC") as! SetLocationVC
        self.present(gotoVC, animated: true, completion: nil)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == self.phoneNumberTF{
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    //MARK: - Custom PickerView
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.pickerView?.backgroundColor = UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
        textField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = UIColor(red: 78 / 255.0, green: 189 / 255.0, blue: 229 / 255.0, alpha: 1)
        //#colorLiteral(red: 0.6778348684, green: 0.8199465871, blue: 0.9199492335, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title: languageChangeString(a_str: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title: languageChangeString(a_str: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(SignUpVC.cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelButton1, spaceButton, doneButton1]
        textField.inputAccessoryView = toolBar
        
        self.pickerView?.reloadInputViews()
        self.pickerView?.reloadAllComponents()
        
    }
    @objc func donePickerView(){
        
        self.expString = expArray[(pickerView?.selectedRow(inComponent: 0))!]
        self.expTF.text = self.expString
        //brandIdString = brandIDArray[0]
        expIdString = expIDArray[(pickerView?.selectedRow(inComponent: 0))!]
        if expString.count > 0{
            self.expTF.text = self.expString ?? ""
        }else{
            self.expTF.text = expArray[0]
        }
        self.view.endEditing(true)
        expTF.resignFirstResponder()
        
        //           else{
        //                self.servicePaymentMethodString = servicePaymentMethodArray[(pickerView?.selectedRow(inComponent: 0))!]
        //               self.paymentMethodTF.text = self.servicePaymentMethodString
        //               //brandIdString = brandIDArray[0]
        //               servicePaymentMethodIdString = servicePaymentIDArray[(pickerView?.selectedRow(inComponent: 0))!]
        //               if servicePaymentMethodString.count > 0{
        //                   self.paymentMethodTF.text = self.servicePaymentMethodString ?? ""
        //               }else{
        //                   self.paymentMethodTF.text = servicePaymentMethodArray[0]
        //               }
        //
        //               self.view.endEditing(true)
        //               paymentMethodTF.resignFirstResponder()
        //        }
        
    }
    
    @objc func cancelPickerView(){
        
        if (expTF.text?.count)! > 0 {
            self.view.endEditing(true)
            expTF.resignFirstResponder()
        }
        //           else{
        //               self.view.endEditing(true)
        //               serviceTypeTF.text = ""
        //               serviceTypeTF.resignFirstResponder()
        //           }
        expTF.resignFirstResponder()
        
        //          else{
        //            if (paymentMethodTF.text?.count)! > 0 {
        //                self.view.endEditing(true)
        //                paymentMethodTF.resignFirstResponder()
        //            }else{
        //                self.view.endEditing(true)
        //                paymentMethodTF.text = ""
        //                paymentMethodTF.resignFirstResponder()
        //            }
        //            paymentMethodTF.resignFirstResponder()
        //        }
    }
    //MARK:TEXTFIELD DELEGATES
    func textFieldDidBeginEditing(_ textField: UITextField){
        self.pickUp(self.expTF)
    }
    
    
    //BELOW PROFILE BTN
    
    @IBAction func uploadChefImageBtnAction(_ sender: Any) {
        checkUploadImagePinCheck = "3"
        imgPicker?.delegate = self
        if let imagepicker = imgPicker {
            getImage(picker: imagepicker)
        }
    }
    
    
    //PROFILE BTN
    
    @IBAction func editProfileBtnAction(_ sender: Any) {
        checkUploadImagePinCheck = "2"
        imgPicker?.delegate = self
        if let imagepicker = imgPicker {
            getImage(picker: imagepicker)
        }
    }
    
    
    @IBAction func addBtnAction(_ sender: Any) {
        checkUploadImagePinCheck = "1"
        imgPicker?.delegate = self
        if let imagepicker = imgPicker {
            getImage(picker: imagepicker)
        }
    }
    // MARK: - Action Sheet for Image Picking
    
    func getImage(picker: UIImagePickerController) {
        if checkUploadImagePinCheck == "2"{
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            
            let type = [languageChangeString(a_str: "Camera"),
                        languageChangeString(a_str:"Gallery")]
            
            for index in 0..<type.count {
                let button = UIAlertAction(title: type[index], style: .default, handler: { (action) in
                    if index == 0 {
                        
                        self.openCamera(picker: picker)
                    } else {
                        self.openGallary(picker: picker)
                    }
                })
                alert.addAction(button)
            }
            let cancel = UIAlertAction(title: languageChangeString(a_str: "Cancel"), style: .cancel) { (action) in }
            alert.addAction(cancel)
            if let popoverController = alert.popoverPresentationController {
                popoverController.delegate = self as? UIPopoverPresentationControllerDelegate
                popoverController.sourceView = editBtn
                popoverController.sourceRect = editBtn.bounds
            }
            self.present(alert, animated: true, completion: nil)
        }
        else if checkUploadImagePinCheck == "1"{
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            
            // let type = [languageChangeString(a_str: "Camera"),
            //   languageChangeString(a_str:"Gallery")]
            let type = [languageChangeString(a_str:"Gallery")]
            
            for index in 0..<type.count {
                let button = UIAlertAction(title: type[index], style: .default, handler: { (action) in
                    //                if index == 0 {
                    //                    self.openCamera(picker: picker)
                    //                } else {
                    self.openGallary(picker: picker)
                    //   }
                })
                alert.addAction(button)
            }
            let cancel = UIAlertAction(title: languageChangeString(a_str: "Cancel"), style: .cancel) { (action) in }
            alert.addAction(cancel)
            if let popoverController = alert.popoverPresentationController {
                popoverController.delegate = self as? UIPopoverPresentationControllerDelegate
                popoverController.sourceView = addBtn
                popoverController.sourceRect = addBtn.bounds
            }
            self.present(alert, animated: true, completion: nil)
        }else
        if checkUploadImagePinCheck == "3"{
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            
            let type = [languageChangeString(a_str: "Camera"),
                        languageChangeString(a_str:"Gallery")]
            
            for index in 0..<type.count {
                let button = UIAlertAction(title: type[index], style: .default, handler: { (action) in
                    if index == 0 {
                        
                        self.openCamera(picker: picker)
                    } else {
                        self.openGallary(picker: picker)
                    }
                })
                alert.addAction(button)
            }
            let cancel = UIAlertAction(title: languageChangeString(a_str: "Cancel"), style: .cancel) { (action) in }
            alert.addAction(cancel)
            if let popoverController = alert.popoverPresentationController {
                popoverController.delegate = self as? UIPopoverPresentationControllerDelegate
                popoverController.sourceView = editBtn
                popoverController.sourceRect = editBtn.bounds
            }
            self.present(alert, animated: true, completion: nil)
        }
        //        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        //
        //        let type = [languageChangeString(a_str: "Camera"),
        //                    languageChangeString(a_str:"Gallery")]
        //
        //        for index in 0..<type.count {
        //            let button = UIAlertAction(title: type[index], style: .default, handler: { (action) in
        //                if index == 0 {
        //
        //                    self.openCamera(picker: picker)
        //                } else {
        //                    self.openGallary(picker: picker)
        //                }
        //            })
        //            alert.addAction(button)
        //        }
        //        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        //
        //       // let type = [languageChangeString(a_str: "Camera"),
        //                 //   languageChangeString(a_str:"Gallery")]
        //        let type = [languageChangeString(a_str:"Gallery")]
        //
        //        for index in 0..<type.count {
        //            let button = UIAlertAction(title: type[index], style: .default, handler: { (action) in
        ////                if index == 0 {
        ////                    self.openCamera(picker: picker)
        ////                } else {
        //                    self.openGallary(picker: picker)
        //             //   }
        //        })
        //            alert.addAction(button)
        //        }
        //        let cancel = UIAlertAction(title: languageChangeString(a_str: "Cancel"), style: .cancel) { (action) in }
        //        alert.addAction(cancel)
        //        if let popoverController = alert.popoverPresentationController {
        //            popoverController.delegate = self as? UIPopoverPresentationControllerDelegate
        //            popoverController.sourceView = uploadBtn
        //            popoverController.sourceRect = uploadBtn.bounds
        //        }
        //        self.present(alert, animated: true, completion: nil)
    }
    //Open Gallary
    func openGallary(picker: UIImagePickerController?) {
        
        if checkUploadImagePinCheck == "1"{
            
            let vc = BSImagePickerViewController()
            vc.maxNumberOfSelections = 10
            self.bs_presentImagePickerController(vc, animated: true,
                                                 select: { (asset: PHAsset) -> Void in
                                                    DispatchQueue.main.async {
                                                        let photoAsset = asset
                                                        let manager = PHImageManager.default()
                                                        var options: PHImageRequestOptions?
                                                        options = PHImageRequestOptions()
                                                        options?.resizeMode = .exact
                                                        options?.isSynchronous = true
                                                        manager.requestImage(
                                                            for: photoAsset,
                                                            targetSize: PHImageManagerMaximumSize,
                                                            contentMode: .aspectFit,
                                                            options: options
                                                        ) { [weak self] result, _ in
                                                            print("my images are ******* \(result!)")
                                                            self?.seletionImgsArray.append(result!)
                                                            
                                                            print("multileple image file name",result!)
                                                            
                                                            /* self?.carImagesViewHeightConstraint.constant = 100
                                                             self?.carImagesView.isHidden = false
                                                             self?.carImagesCollectionView.reloadData()*/
                                                            
                                                            
                                                        }
                                                    }
                                                    
                                                 }, deselect: { (asset: PHAsset) -> Void in
                                                    print("Deselected: \(asset)")
                                                    
                                                 }, cancel: { (assets: [PHAsset]) -> Void in
                                                    print("Cancel: \(assets)")
                                                    
                                                 }, finish: { (assets: [PHAsset]) -> Void in
                                                    print("Finish: \(assets)")
                                                    
                                                    var fileStringArray = [String]()
                                                    fileStringArray.removeAll()
                                                    
                                                    for asset in assets{
                                                        if let fileName = asset.value(forKey: "filename") as? String{
                                                            print(fileName)
                                                            
                                                            fileStringArray.append(String(format: "%@",fileName))
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                    DispatchQueue.main.async {
                                                        //self.photoandVideo_lbl.text = fileStringArray.joined(separator: ",")
                                                        
                                                        //                    let height = self.heightForView(text: self.photoandVideo_lbl.text!, width: self.photoandVideo_lbl.frame.size.width)
                                                        //
                                                        //                    print("height of photos label",height)
                                                    }
                                                    
                                                    
                                                    let duration: Double = 1
                                                    // self.uploadMultipleCertificateStaticLabel.text = "images are uploaded"
                                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                                                        //self.imagePickDone(message: "Upload Done")
                                                        self.imagePickDone(message:self.languageChangeString(a_str: "Certificates are uploaded") ?? "")
                                                        //"Car Image Upload Done"
                                                    }
                                                    print("Selected: \(assets)")
                                                    
                                                 }, completion: nil)
            
        } else {
            
            if let imgPicker = picker {
                imgPicker.allowsEditing = false //R
                imgPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                
                self.present(imgPicker, animated: true, completion: nil)
            }
        }
    }
    func presentAlertWithTitle(title: String, message: String, options: String..., completion: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, option) in options.enumerated() {
            alertController.addAction(UIAlertAction.init(title: option, style: .default, handler: { (action) in
                completion(index)
            }))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    // Open Camera
    func openCamera(picker: UIImagePickerController?) {
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            if let imgpicker = picker {
                imgpicker.allowsEditing = false //R
                imgpicker.sourceType = UIImagePickerController.SourceType.camera
                imgpicker.cameraCaptureMode = .photo
                self.present(imgpicker, animated: true, completion: nil)
            }
            
        } else {
            
            self.presentAlertWithTitle(title:self.languageChangeString(a_str:"Alert") ?? "", message: self.languageChangeString(a_str:"You don't have camera") ?? "", options:self.languageChangeString(a_str:"Ok") ?? "", completion: { (option) in
                
            })
            
        }
    }
    func imagePickDone(message:String ) {
        print("image pick status",message)
        showToast(message: message)
    }
    
    
}

extension SettingsVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            
            self.present(picker, animated: true, completion: nil)
        } else {
            showToast(message: languageChangeString(a_str:"You don't have camera")!)
        }
    }
    func openGallery(){
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let chosenImage = info[.originalImage] as? UIImage {
            
            print("chooice image file name",chosenImage)
            
            if checkUploadImagePinCheck ==  "1"{
                carsImage = chosenImage
                let duration: Double = 1
                self.seletionImgsArray.append(carsImage)
                /*self.carImagesView.isHidden = false
                 self.carImagesViewHeightConstraint.constant = 100
                 self.carImagesCollectionView.reloadData()*/
                // self.uploadMultipleCertificateStaticLabel.text = "Images are uploaded"
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                    self.imagePickDone(message: self.languageChangeString(a_str: "Image uploaded")!)
                }
                
            }else if checkUploadImagePinCheck == "2"{
                
                let cropper = CropperViewController(originalImage: chosenImage)
                cropper.delegate = self
                picker.dismiss(animated: true) {
                    self.present(cropper, animated: true, completion: nil)
                }
                
                //self.profileImage.image = chosenImage  //R
                
                // drivingLincseImage = chosenImage
                
                let duration: Double = 1
                //       self.uploadSingleStaticLabel.text = "image uploaded"
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                    //   self.imagePickDone(message: self.languageChangeString(a_str:"certificate uploaded")!)
                }
                
            }else if checkUploadImagePinCheck == "3"{
                
                let cropper = CropperViewController(originalImage: chosenImage)
                cropper.delegate = self
                picker.dismiss(animated: true) {
                    self.present(cropper, animated: true, completion: nil)
                }
                
                //self.uploadChefImage.image = chosenImage //R
                
                // drivingLincseImage = chosenImage
                
                let duration: Double = 1
                //       self.uploadSingleStaticLabel.text = "image uploaded"
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                    //   self.imagePickDone(message: self.languageChangeString(a_str:"certificate uploaded")!)
                }
                
            }
            //            else if checkUploadImagePinCheck == "3"{
            //                   self.profileImageView.image = chosenImage
            //                  // drivingLincseImage = chosenImage
            //
            //                   let duration: Double = 1
            //            //       self.uploadSingleStaticLabel.text = "image uploaded"
            //                   DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            //                      // self.imagePickDone(message: self.languageChangeString(a_str:"certificate uploaded")!)
            //                   }
            //
            //               }
            
        }else{
            
        }
        //dismiss(animated: false, completion: nil)  //R
    }
    /* func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
     picker.dismiss(animated: true, completion: nil)
     guard let image = info[.originalImage] as? UIImage else {
     fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
     }
     self.profileImageView.image = image
     pickedImage = image
     //   self.profileImageView.layer.borderWidth = 1
     // self.profileImageView.layer.masksToBounds = false
     //self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
     //self.profileImageView.clipsToBounds = true
     picker.dismiss(animated: true, completion: nil)
     }*/
    /* func imagePickerController(_ picker: UIImagePickerController,
     didFinishPickingMediaWithInfo info: [String : Any]) {
     picker.dismiss(animated: true, completion: nil)
     guard let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage else {
     return
     }
     self.profileImageView.image = image
     pickedImage = image
     print("picked   image \(self.pickedImage)")
     //   self.profileImageView.layer.borderWidth = 1
     // self.profileImageView.layer.masksToBounds = false
     //self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
     //self.profileImageView.clipsToBounds = true
     picker.dismiss(animated: true, completion: nil)
     }*/
    //    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //
    //        picker.dismiss(animated: true, completion: nil)
    //        guard let image = info[UIImagePickerController.InfoKey.originalImage] //info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)]else {
    //            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    //        }
    //        self.providerImg.image = image
    //        pickedImage = image
    //        self.providerImg.layer.borderWidth = 1
    //        self.providerImg.layer.masksToBounds = false
    //        self.providerImg.layer.borderColor = UIColor.white.cgColor
    //        self.providerImg.layer.cornerRadius = self.providerImg.frame.height/2
    //        self.providerImg.clipsToBounds = true
    //
    //    }
    
    // func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //  private
    //    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        picker.dismiss(animated: true, completion: nil)
    //        guard let image = info[UIImagePickerControllerOriginalImage as UIImagePickerController.InfoKey] as? UIImage else{
    //            //info[UIImagePickerControllerOriginalImage] as? UIImage else {
    //            //info[.originalImage] as? UIImage else {
    //            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
    //        }
    //        self.profileImageView.image = image
    //        pickedImage = image
    //        print("imageee\(self.pickedImage)")
    //     //   self.profileImageView.layer.borderWidth = 1
    //       // self.profileImageView.layer.masksToBounds = false
    //        //self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height/2
    //        //self.profileImageView.clipsToBounds = true
    //        picker.dismiss(animated: true, completion: nil)
    //    }
    func alertController (title: String,msg: String) {
        let alert = UIAlertController.init(title:title , message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: languageChangeString(a_str:"OK"), style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK:- EDIT PROFILE SERVICE CALL
    func editProfileServiceCall(){
        if Reachability.isConnectedToNetwork(){
            ChefServices.sharedInstance.loader(view: self.view)
            
            /* first_name = pankaj
             last_name = kumar
             email = pankaj@yopmail.com
             mobile_no = 8340642584
             password = 123456
             confirm_password = 123456
             address = bangalore
             experience = 13
             user_document = images/PDF
             description = Write something
             device_type = ios/android
             device_token = token
             role = for admin it should be "app_admin" and for users it should be "users"
             account_number,routing_number,confirm_account_number
             */
            let languageString = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            let userID = UserDefaults.standard.object(forKey: "userId") as? String ?? ""
            // service_id =service ids  category_id = cussinids
            if self.newPwdTF.text == ""{
                params = ["lang" : languageString,
                          "email":self.emailIDTF.text!,
                          "mobile_no":self.phoneNumberTF.text ?? "",
                          "first_name": self.nameTF.text!,
                          "current_password":"",
                          "confirm_password":"",
                          "password":"",
                          "address":self.addressLbl.text!,
                          "experience":self.expIdString,
                          "description":self.descTV.text!,
                          "category_id":self.itemIdString,
                          "service_id": self.itemMain_IdString,
                          "user_id":userID] as [String:AnyObject]
            }else{
                params = ["lang" : languageString,
                          "email":self.emailIDTF.text!,
                          "mobile_no":self.phoneNumberTF.text ?? "",
                          "first_name": self.nameTF.text!,
                          "current_password":self.currentPwdTf.text!,
                          "confirm_password":self.confirmPwdTF.text!,
                          "password":self.newPwdTF.text!,
                          "address":self.addressLbl.text!,
                          "experience":self.expIdString,
                          "description":self.descTV.text!,
                          "service_id": self.itemMain_IdString,
                          "category_id":self.itemIdString
                          ,"user_id":userID] as [String:AnyObject]
            }
            
            //            let parameters: Dictionary<String, Any> = ["lang" : languageString,"email":self.emailIDTF.text!,"mobile_no":self.phoneNumberTF.text ?? "","first_name": self.nameTF.text!,"current_password":self.currentPwdTf.text!,"confirm_password":self.confirmPwdTF.text!,"password":self.newPwdTF.text!,"address":self.addressLbl.text!,"experience":self.expIdString,"description":self.descTV.text!,"category_id":self.itemIdString,"user_id":userID]
            //"lattitude":self.latitudeString,"longitude":self.longitudeString,"address":self.addressStr ?? "","city":self.cityStr ?? ""
            let  url = editProfileAPI
            //"\(BASE_URL)reg"
            print(url)
            // var imageData1 = Data()
            var imageData2 = Data()
            //            if let imgData = self.profileImageView.image!.jpegData(compressionQuality: 0.1){
            //                //UIImageJPEGRepresentation(pickedImage, 0.1){
            //            //image?.UIImageJPEGRepresentation(compressionQuality: 0.1){
            //                imageData1 = imgData
            //            }
            if let imgData2 = self.profileImage.image!.jpegData(compressionQuality: 0.1){
                //UIImageJPEGRepresentation(pickedImage, 0.1){
                //image?.UIImageJPEGRepresentation(compressionQuality: 0.1){
                imageData2 = imgData2
            }
            //   print(imageData1)
            print(imageData2)
            var imageChefData3 = Data()
            if let imageData3 = self.uploadChefImage.image!.jpegData(compressionQuality: 0.1){
                //UIImageJPEGRepresentation(pickedImage, 0.1){
                //image?.UIImageJPEGRepresentation(compressionQuality: 0.1){
                imageChefData3 = imageData3
            }
            print(imageChefData3)
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                // import image to request
                //                multipartFormData.append(imageData1, withName: "user_image", fileName: "file.jpg", mimeType: "image/jpeg")
                multipartFormData.append(imageData2, withName: "user_image", fileName: "image.jpg", mimeType: "image/jpeg")
                multipartFormData.append(imageChefData3, withName: "background_image", fileName: "image.jpg", mimeType: "image/jpeg")
                if self.seletionImgsArray.count > 0{
                    
                    for i in 0..<self.seletionImgsArray.count {
                        
                        let imageData  = self.seletionImgsArray[i].jpegData(compressionQuality: 0.50)
                        print("image data",imageData!)
                        multipartFormData.append(imageData!, withName: "user_document[]", fileName:"image.jpg", mimeType: "image/jpeg")
                        print("multiform data",multipartFormData)
                    }
                }else{
                    
                }
                for (key, value) in self.params {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to: url,method:.post,
            encodingCompletion:
                { (result) in
                    print(result)
                    switch result {
                    case .success(let upload, _, _):
                        
                        upload.responseJSON{ response in
                            
                            print("response data is :\(response)")
                            
                            if let responseData = response.result.value as? Dictionary <String,Any>{
                                
                                let status = responseData["status"] as! Int
                                let message = responseData ["message"] as! String
                                
                                if status == 1{
                                    // UserDefaults.standard.removeObject(forKey: "itemIdString")
                                    ChefServices.sharedInstance.dissMissLoader()
                                    UserDefaults.standard.set(self.confirmPwdTF.text, forKey: "password")
                                    if self.newPwdTF.text == ""{
                                        UserDefaults.standard.set(self.newPwdTF.text, forKey: "password")
                                        UserDefaults.standard.set(self.currentPwdTf.text, forKey: "password")
                                    }else{
                                        UserDefaults.standard.set(self.confirmPwdTF.text, forKey: "password")
                                        //                                    if self.newPwdTF.text == ""{
                                        //                                        self.currentPwdTf.text = UserDefaults.standard.string(forKey: "password")
                                        //                                    }else{
                                        //                                        UserDefaults.standard.set(self.currentPwdTf.text, forKey: "password")
                                        //                                    }
                                        UserDefaults.standard.set(self.currentPwdTf.text, forKey: "password")
                                        UserDefaults.standard.set(self.newPwdTF.text, forKey: "password")
                                        
                                    }
                                    
                                    // UserDefaults.standard.set(self.currentPwdTf.text, forKey: "password")
                                    // UserDefaults.standard.set(self.newPwdTF.text, forKey: "password")
                                    if let userDetailsData = responseData["user details"] as? Dictionary<String, AnyObject> {
                                        print(userDetailsData)
                                        let userID = userDetailsData["user_id"] as? String
                                        if let first_name = userDetailsData["first_name"] as? String
                                        {
                                            self.name = first_name
                                        }
                                        if let email = userDetailsData["email"] as? String
                                        {
                                            self.email = email
                                        }
                                        if let phoneNo = userDetailsData["mobile_no"] as? String
                                        {
                                            self.phone = phoneNo
                                        }
                                        if let display_pic = userDetailsData["user_image"] as? String
                                        {
                                            self.userImage = BASE_PATH+display_pic
                                        }
                                        
                                        if let address = userDetailsData["address"] as? String
                                        {
                                            self.locationstr = address
                                        }
                                        if let experience = userDetailsData["experience"] as? String
                                        {
                                            self.expStr = experience
                                        }
                                        
                                        if let description = userDetailsData["description"] as? String
                                        {
                                            self.descStr = description
                                        }
                                        if let routing_number = userDetailsData["routing_number"] as? String
                                        {
                                            self.routing_number = routing_number
                                        }
                                        if let account_number = userDetailsData["account_number"] as? String
                                        {
                                            self.account_number = account_number
                                        }
                                        UserDefaults.standard.setValue(self.descStr, forKey: "desc")
                                        UserDefaults.standard.set(userID, forKey: "userId")
                                        UserDefaults.standard.set(self.name, forKey: "userName")
                                        
                                        UserDefaults.standard.set(self.phone, forKey: "phone")
                                        UserDefaults.standard.set(self.email, forKey: "email")
                                        UserDefaults.standard.set(self.expStr, forKey: "experience")
                                        UserDefaults.standard.set(self.locationstr, forKey: "address")
                                        UserDefaults.standard.set(self.userImage, forKey: "userImage")
                                        
                                        UserDefaults.standard.set(self.locationstr, forKey: "address")
                                        
                                        UserDefaults.standard.set(self.routing_number, forKey: "routing_number")
                                        UserDefaults.standard.set(self.account_number, forKey: "account_number")
                                        
                                        //     UserDefaults.standard.set(otpStatusStr, forKey: "otpStatus")
                                        
                                        /*  if let userName = userDetailsData["user_name"] as? String
                                         {
                                         self.name = userName
                                         }
                                         if let email = userDetailsData["email"] as? String
                                         {
                                         self.email = email
                                         }
                                         if let phoneNo = userDetailsData["mobile_no"] as? String
                                         {
                                         self.phone = phoneNo
                                         }
                                         if let display_pic = userDetailsData["user_image"] as? String
                                         {
                                         self.userImage = BASE_PATH+display_pic
                                         }
                                         if let splo = userDetailsData["sp_logo"] as? String
                                         {
                                         self.splogo = BASE_PATH+splo
                                         }
                                         if let languages_spoke = userDetailsData["languages"] as? String
                                         {
                                         self.langSpoke = languages_spoke
                                         }
                                         if let bio = userDetailsData["bio"] as? String
                                         {
                                         self.bio = bio
                                         }
                                         if let city = userDetailsData["city"] as? String
                                         {
                                         self.locationstr = city
                                         }
                                         if let center_name = userDetailsData["center_name"] as? String
                                         {
                                         self.dietCenterName = center_name
                                         }
                                         if let gender = userDetailsData["gender"] as? String
                                         {
                                         self.gender = gender
                                         }
                                         if let description = userDetailsData["description"] as? String
                                         {
                                         self.descStr = description
                                         }*/
                                    }
                                    DispatchQueue.main.async {
                                        
                                        ChefServices.sharedInstance.dissMissLoader()
                                        self.showToast(message: message)
                                        self.nameTF.text = self.name
                                        self.phoneNumberTF.text = self.phone
                                        self.emailIDTF.text = self.email
                                        self.addressLbl.text = self.locationstr
                                        self.expTF.text = self.expStr
                                        
                                        self.nameLabel.text = self.name
                                        self.emailLabel.text = self.email
                                        self.addressLabel.text = self.locationstr
                                        
                                        //self.accountNoTF.text = self.account_number
                                        //  self.routingNumberTF.text = self.routing_number
                                        //  self.confirmAccountNoTF.text = self.account_number
                                        
                                        
                                        //c
                                        self.profileImage.layer.borderWidth = 1
                                        //c self.profileImageView.clipsToBounds = true
                                        //
                                        self.profileImage.layer.borderColor = UIColor.white.cgColor
                                        
                                        self.descTV.text = self.descStr
                                        //c self.profileImageView.clipsToBounds = true
                                        //
                                        
                                        //   self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
                                        // self.profileImageView.layer.masksToBounds = true
                                        self.profileImage.sd_setImage(with: URL (string: self.userImage), placeholderImage:
                                                                        UIImage(named: ""))
                                        
                                        if self.newPwdTF.text == ""{
                                            self.currentPwdTf.text =  UserDefaults.standard.string(forKey:"password")
                                        }
                                        
                                        self.currentPwdTf.text =  UserDefaults.standard.string(forKey:"password")
                                        self.newPwdTF.text = ""
                                        self.confirmPwdTF.text = ""
                                    }
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileData"), object: nil)
                                    //                                    DispatchQueue.main.async {
                                    //                                        self.showToast(message: message)
                                    //                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
                                    //                                            self.SPProfile()
                                    //                                        }
                                    //                                        }
                                    
                                }else{
                                    ChefServices.sharedInstance.dissMissLoader()
                                    self.showToast(message: message)
                                }
                            }
                            
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        ChefServices.sharedInstance.dissMissLoader()
                    }
                })
        }
        else{
            ChefServices.sharedInstance.dissMissLoader()
            showToast(message: languageChangeString(a_str:"Please check your internet connection")!)
        }
    }
    
    
    //MARK:- GET PROFILE SERVICE CALL
    func getProfile(){
        if Reachability.isConnectedToNetwork(){
            ChefServices.sharedInstance.loader(view: self.view)
            let languageString = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            let userID = UserDefaults.standard.object(forKey: "userId") as? String ?? ""
            // let profileData = "\(BASE_URL)getSpProfile?"
            let parameters: Dictionary<String, Any> = ["lang" : languageString,"sp_id":userID]
            print(parameters)
            //https://demomaplebrains.net/chef/api/services/getChefProfile?sp_id=192
            Alamofire.request(getChefProfileAPI, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    //print(responseData)
                    let status = responseData["status"] as! Int
                    self.categoriesArray = [CategoryModel]()
                    self.categoryArrayData.removeAll()
                    
                    if status == 1{
                        ChefServices.sharedInstance.dissMissLoader()
                        
                        self.currentPwdTf.text =  UserDefaults.standard.string(forKey:"password")
                        
                        if let userDetailsData = responseData["get_sp_profile"] as? Dictionary<String, AnyObject> {
                            print(userDetailsData)
                            self.certificateArray = [SPCertificateModel]()
                            
//                            if UserDefaults.standard.object(forKey: "itemIdString") != nil{
//                                self.selectedSubServiceIDs = UserDefaults.standard.object(forKey: "itemIdString") as! [String]
//                                UserDefaults.standard.set(self.selectedSubServiceIDs, forKey: "itemIdString")
//                                self.itemIdString = self.selectedSubServiceIDs.joined(separator: ",")
//                            }else{
//                                self.selectedSubServiceIDs.removeAll()
//                                UserDefaults.standard.removeObject(forKey: "itemIdString")
//                                self.itemIdString = ""
//                            }
//
//                            if UserDefaults.standard.object(forKey: "subServiceNames") != nil{
//                                self.selectedSubServiceNames = UserDefaults.standard.object(forKey: "subServiceNames") as! [String]
//                                UserDefaults.standard.set(self.selectedSubServiceNames, forKey: "subServiceNames")
//                                self.serviceNameString = self.selectedSubServiceNames.joined(separator: ",")
//                            }else{
//                                self.selectedSubServiceNames.removeAll()
//                                UserDefaults.standard.removeObject(forKey: "subServiceNames")
//                                self.serviceNameString = ""
//                            }
                            
                            
                            
                            if let userDocs = userDetailsData["chef_document"] as? [[String:Any]]{
                                
                                
                                for list in userDocs {
                                    let object = SPCertificateModel(cerificateData: list as NSDictionary)
                                    self.certificateArray.append(object)
                                    print("certic array\(self.certificateArray)")
                                    
                                    //let new = object.image_id
                                    let myInt2 = (object.id as NSString).integerValue
                                    let myString = String(myInt2)
                                     
                                }
                                
                               
                            }
                            DispatchQueue.main.async {
                                self.certificateCollectionView.reloadData()
                                
                            }
                            if let first_name = userDetailsData["first_name"] as? String
                            {
                                self.name = first_name
                            }
                            if let last_name = userDetailsData["last_name"] as? String
                            {
                                self.lastName = last_name
                            }
                            if let email = userDetailsData["email"] as? String
                            {
                                self.email = email
                            }
                            if let phoneNo = userDetailsData["mobile_no"] as? String
                            {
                                self.phone = phoneNo
                            }
                            if let display_pic = userDetailsData["user_image"] as? String
                            {
                                self.userImage = BASE_PATH+display_pic
                            }
                            if let backgroundImage = userDetailsData["background_image"] as? String
                            {
                                self.background_image = BASE_PATH+backgroundImage
                            }
                            if let address = userDetailsData["address"] as? String
                            {
                                self.locationstr = address
                            }
                            if let experience = userDetailsData["experience"] as? String
                            {
                                self.expStr = experience
                            }
                            
                            if let description = userDetailsData["description"] as? String
                            {
                                self.descStr = description
                            }
                            if let routing_number = userDetailsData["routing_number"] as? String
                            {
                                self.routing_number = routing_number
                            }
                            if let account_number = userDetailsData["account_number"] as? String
                            {
                                self.account_number = account_number
                            }
                            
                            if let userDocss = userDetailsData["categories"] as? [[String:Any]]{
                                
                                
                                for list in userDocss {
                                    let object = CategoryModel(CategoryData: list as NSDictionary)
                                    
                                    
                                    self.categoryArrayData.append(categoryStruct(categoryID: object.category_id, categoryName: object.category_name, categorySelectState: object.selected, categoryImage: object.category_image))
                                    
                                    
                                    
//                                    self.categoriesArray.append(object)
//                                    print("category array\(self.categ)")
//
                                   
                                }
                                print("category struct count array\(self.categoryArrayData.count)")
                                DispatchQueue.main.async {
                                    self.categoryCollectionView.reloadData()
                                   
                                }
                                
                               
                            }
                            
                            
                            if let userDocss1 = userDetailsData["services"] as? [[String:Any]]{
                                
                                for list in userDocss1 {
                                    let object = ServicesModel(serviceData: list as NSDictionary)
                                    self.servicesArray.append(object)
                                    print("servicesArray array\(self.servicesArray)")
                                    
                                   
                                }
                                DispatchQueue.main.async {
                                    self.servicesCollectionView.reloadData()
                                   
                                }
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            ChefServices.sharedInstance.dissMissLoader()
                            self.nameTF.text = String(format:"%@ %@",self.name,self.lastName)
                            self.phoneNumberTF.text = self.phone
                            self.emailIDTF.text = self.email
                            self.addressLbl.text = self.locationstr
                            self.expTF.text = self.expStr
                            
                            self.nameLabel.text = String(format:"%@ %@",self.name,self.lastName)
                            self.emailLabel.text = self.email
                            self.addressLabel.text = self.locationstr
                            
                            //self.accountNoTF.text = self.account_number
                            //self.routingNumberTF.text = self.routing_number
                            //self.confirmAccountNoTF.text = self.account_number
                            
                            //c
                            self.profileImage.layer.borderWidth = 1
                            //c self.profileImageView.clipsToBounds = true
                            //
                            self.profileImage.layer.borderColor = UIColor.white.cgColor
                            
                            self.descTV.text = self.descStr
                            //c self.profileImageView.clipsToBounds = true
                            //
                            
                            //   self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
                            // self.profileImageView.layer.masksToBounds = true
                            self.profileImage.sd_setImage(with: URL (string: self.userImage), placeholderImage:
                                                            UIImage(named: ""))
                            self.newPwdTF.text = ""
                            self.confirmPwdTF.text = ""
                            
                            self.uploadChefImage.sd_setImage(with: URL (string: self.background_image), placeholderImage:
                                                                UIImage(named: ""))
                            
                        }
                        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(SettingsVC.removeLoader), userInfo: nil, repeats: false)
                    }
                    else{
                        ChefServices.sharedInstance.dissMissLoader()
                        //                        let message = responseData["message"] as! String
                        //                           self.showToast(message: message)
                        //                           print(message)
                    }
                }
            }
        }
        else{
            ChefServices.sharedInstance.dissMissLoader()
            self.showToast(message:languageChangeString(a_str:"Please check your internet connection")!)
        }
    }
}


extension SettingsVC:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int {
        return expArray.count
    }
    func pickerView(_ pickerView: UIPickerView,titleForRow row: Int,forComponent component: Int) -> String? {
        return expArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.expTF.text =  expArray[row]
        self.expString = expArray[row]
        expIdString = expIDArray[row]
    }
}

/*
 
 func getCategoriesServiceCall(){
 // DealServices.sharedInstance.loader(view: self.view)
 //https://demomaplebrains.net/chef/api/services/categoy
 
 let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
 let userid = UserDefaults.standard.object(forKey: "newUserID") as? String ?? ""
 //        if self.typeStr == "MyBagVC"{
 //            params = ["lang":language,"API-KEY":API_KEY,"cat_id":self.serviceIdString,"user_id":userid,"type":checkTypeServiceStr]
 //        }else{
 //            params = ["lang":language,"API-KEY":API_KEY,"cat_id":self.catid,"sub_cat_id":self.subcatid,"cabinet_id":self.cabinetid,"user_id":userid,"type":"1"]
 //        }
 
 let params = ["lang":language]
 
 ChefServices.sharedInstance.getDataServiceCall(url: categoryAPI, postDict: params as [String : AnyObject]) { (response, error) in
 // if response != nil{
 let status : Int = response["status"] as! Int
 self.categoriesArray = [CategoryModel]()
 if status == 1{
 ChefServices.sharedInstance.dissMissLoader()
 
 if UserDefaults.standard.object(forKey: "itemIdString") != nil{
 self.selectedSubServiceIDs = UserDefaults.standard.object(forKey: "itemIdString") as! [String]
 UserDefaults.standard.set(self.selectedSubServiceIDs, forKey: "itemIdString")
 self.itemIdString = self.selectedSubServiceIDs.joined(separator: ",")
 }else{
 self.selectedSubServiceIDs.removeAll()
 UserDefaults.standard.removeObject(forKey: "itemIdString")
 self.itemIdString = ""
 }
 
 if UserDefaults.standard.object(forKey: "subServiceNames") != nil{
 self.selectedSubServiceNames = UserDefaults.standard.object(forKey: "subServiceNames") as! [String]
 UserDefaults.standard.set(self.selectedSubServiceNames, forKey: "subServiceNames")
 self.serviceNameString = self.selectedSubServiceNames.joined(separator: ",")
 }else{
 self.selectedSubServiceNames.removeAll()
 UserDefaults.standard.removeObject(forKey: "subServiceNames")
 self.serviceNameString = ""
 }
 if (response["categories"] as? [[String:Any]]) != nil{
 if let categoriesArray = response["categories"] as? [[String:Any]]{
 for list in categoriesArray{
 let object = CategoryModel(CategoryData: list as NSDictionary)
 self.categoriesArray.append(object)
 }
 }
 DispatchQueue.main.async {
 self.categoryCollectionView.reloadData()
 }
 }
 else{
 print("categories nil")
 }
 
 // Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CabinetFeatureDetailsVC.removeLoader), userInfo: nil, repeats: false)
 }
 else{
 ChefServices.sharedInstance.dissMissLoader()
 let message = response["message"] as! String
 self.showToast(message: message)
 DispatchQueue.main.async {
 self.categoryCollectionView.reloadData()
 }
 }
 }
 }
 */

extension SettingsVC: CropperViewControllerDelegate {
    
    func cropperDidConfirm(_ cropper: CropperViewController, state: CropperState?) {
        cropper.dismiss(animated: true, completion: nil)
        
        if let state = state,
           let image = cropper.originalImage.cropped(withCropperState: state) {
            
            
            if checkUploadImagePinCheck == "2"{
                
                self.profileImage.image = image
            }
            
            
            if checkUploadImagePinCheck == "3"{
                
                self.uploadChefImage.image = image
                
            }
            
            // self.cropImageView.image = image
        } else {
            print("Something went wrong")
        }
        // self.dismiss(animated: true, completion: nil)
    }
}

extension SettingsVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.categoryCollectionView{
            return categoryArrayData.count
        }
        if collectionView == self.servicesCollectionView{
            return servicesArray.count
        }
        else if collectionView == self.certificateCollectionView{
            return certificateArray.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        //Rami
        if collectionView == self.categoryCollectionView{
            let cell = self.categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCVCell", for: indexPath) as! CategoriesCVCell
            let dataOfCategory:categoryStruct = categoryArrayData[indexPath.row]
            cell.categoryNameLabel.text = dataOfCategory.categoryName
            
            
            
            if  dataOfCategory.categorySelectState == "1"{
                cell.checkImage.image = UIImage.init(named: "Group 8291")
            }else{
                cell.checkImage.image = UIImage.init(named: "Group 8290")
            }
            
 

            return cell
        }
        
        else if collectionView == self.servicesCollectionView{
            
            let cell = self.servicesCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCVCell", for: indexPath) as! CategoriesCVCell
            cell.categoryNameLabel.text = servicesArray[indexPath.row].service_name
            // let selected = categoriesArray[indexPath.row].selected
            //Group 8290 uncehck Icon ionic-ios-checkbox-outline-1
            //Group 8291 check  Icon ionic-ios-checkbox-outline
            
            
            let selected = servicesArray[indexPath.row].selected
                        if selected == "0"{
                            cell.checkImage.image = UIImage.init(named: "Group 8290")
                        }else if selected == "1"{
                            cell.checkImage.image = UIImage.init(named: "Group 8291")
                        }
            
            if self.selected_MainServiceIDs.contains(servicesArray[indexPath.row].service_id){
                //cell.checkImageView.isHidden = false
                cell.checkImage.image = UIImage.init(named: "Group 8291")
            }else{
                cell.checkImage.image = UIImage.init(named: "Group 8290")
            }

            return cell
        }
        
        
        else if collectionView == self.certificateCollectionView{
            let cell = self.certificateCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCVCell", for: indexPath) as! CategoriesCVCell
            cell.backCertiView.layer.borderWidth = 1.0
            //cell.backCertiView.layer.borderColor = #colorLiteral(red: 0.4804852605, green: 0.4347507954, blue: 0.3575093448, alpha: 1)
            cell.backCertiView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.backCertiView.layer.borderWidth = 0.5
            cell.backCertiView.clipsToBounds = true
            cell.backCertiView.layer.cornerRadius = 6
            let bannerImage = BASE_PATH + certificateArray[indexPath.item].user_document
            cell.certificateImageView.sd_setImage(with: URL(string: bannerImage), placeholderImage: UIImage.init(named: ""))
            return cell
        }
        return UICollectionViewCell()
    }
}
extension SettingsVC : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did selected")
        if collectionView == self.categoryCollectionView{
            let cell = self.categoryCollectionView.cellForItem(at: indexPath) as! CategoriesCVCell

            
            let categeoryStructData:categoryStruct = self.categoryArrayData[indexPath.row]
            
            
            if categeoryStructData.categorySelectState == "0"{
                self.categoryArrayData.remove(at: indexPath.row)
                self.categoryArrayData.insert(categoryStruct(categoryID: categeoryStructData.categoryID, categoryName: categeoryStructData.categoryName, categorySelectState: "1", categoryImage: categeoryStructData.categoryImage), at: indexPath.row)
            }else{
                self.categoryArrayData.remove(at: indexPath.row)
                self.categoryArrayData.insert(categoryStruct(categoryID: categeoryStructData.categoryID, categoryName: categeoryStructData.categoryName, categorySelectState: "0", categoryImage: categeoryStructData.categoryImage), at: indexPath.row)
            }
            
            self.categoryCollectionView.reloadData()
            
//            let selected = categoriesArray[indexPath.row].selected
//            if self.selectedSubServiceIDs.contains(categoriesArray[indexPath.row].category_id){
//                //cell.checkImageView.isHidden = false
//
//                if selected == "0"{
//                    cell.checkImage.image = UIImage.init(named: "Group 8291")
//                    //                    selected = "1"
//                }else if selected == "1"{
//                    cell.checkImage.image = UIImage.init(named: "Group 8290")
//                    //                    selected = "0"
//                }
//
//
//                let subCatId = self.selectedSubServiceIDs.index(of: categoriesArray[indexPath.row].category_id)
//                if subCatId != nil {
//                    self.selectedSubServiceIDs.remove(at: subCatId!)
//                }
//
//                let subCatName = self.selectedSubServiceNames.index(of: categoriesArray[indexPath.row].category_name)
//                if subCatName != nil {
//                    self.selectedSubServiceNames.remove(at: subCatName!)
//                }
//            }else{
//                //cell.checkImageView.isHidden = false
//                if selected == "0"{
//                    cell.checkImage.image = UIImage.init(named: "Group 8291")
//                }else if selected == "1"{
//                    cell.checkImage.image = UIImage.init(named: "Group 8290")
//                }
//                // cell.checkImage.image = UIImage.init(named: "Group 8291")
//                self.selectedSubServiceIDs.append(categoriesArray[indexPath.row].category_id)
//                self.selectedSubServiceNames.append(categoriesArray[indexPath.row].category_name)
//            }
//            collectionView.deselectItem(at: indexPath, animated: true)
        }
        
        else if collectionView == self.certificateCollectionView{
            let cell = self.certificateCollectionView.cellForItem(at: indexPath) as! CategoriesCVCell
            // cell.certificateImageView
//              return cell
        }
        
        else if collectionView == self.servicesCollectionView{
            
            let cell = self.servicesCollectionView.cellForItem(at: indexPath) as! CategoriesCVCell
            
            
            if self.selected_MainServiceIDs.contains(servicesArray[indexPath.row].service_id){
                
                cell.checkImage.image = UIImage.init(named: "Group 8290")
                let subCatId = self.selected_MainServiceIDs.index(of: servicesArray[indexPath.row].service_id)
                if subCatId != nil {
                    self.selected_MainServiceIDs.remove(at: subCatId!)
                }
                let subCatName = self.selected_MainServiceNames.index(of: servicesArray[indexPath.row].service_name)
                if subCatName != nil {
                    self.selected_MainServiceNames.remove(at: subCatName!)
                }
            }else{
                cell.checkImage.image = UIImage.init(named: "Group 8291")
                self.selected_MainServiceIDs.append(servicesArray[indexPath.row].service_id)
                self.selected_MainServiceNames.append(servicesArray[indexPath.row].service_name)
            }
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == self.categoryCollectionView{
            collectionView.deselectItem(at: indexPath, animated: true)
        } else if collectionView == self.servicesCollectionView{
            collectionView.deselectItem(at: indexPath, animated: true)
        }else if collectionView == self.certificateCollectionView{
            
        }
    }
}
extension SettingsVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.categoryCollectionView{
            // let cell1:CGSize = CGSize(width: (self.categoryCollectionView.frame.size.width)/3 , height: 55)
            let cell1:CGSize = CGSize(width: (self.categoryCollectionView.frame.size.width - 10) / 3 , height: 30)
            return cell1
            // return cell1
        }
        else if collectionView == self.certificateCollectionView{
            let cell1:CGSize = CGSize(width: 122, height: 102)
            //138 118
            //CGSize(width: Int((self.certificateCollectionView.frame.size.width))/certificateArray.count , height: 55)
            return cell1
        }
        else if collectionView == self.servicesCollectionView{
            // let cell1:CGSize = CGSize(width: (self.categoryCollectionView.frame.size.width)/3 , height: 55)
            let cell1:CGSize = CGSize(width: Int((self.servicesCollectionView.frame.size.width))/servicesArray.count , height: 55)
            return cell1
        }
        else{
            let cell1:CGSize = CGSize(width: 122, height: 102)
            //CGSize(width: (self.certificateCollectionView.frame.size.width)/3 , height: 55)
            return cell1
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
}
