//
//  WeatherManager.swift
//  AapoonCodeTest
//
//  Created by Apple on 16/12/21.
//  Copyright © 2021 Volive Solurions . All rights reserved.
//

import UIKit
import CoreLocation

enum Section: Int {
    case todayWeatherReport
    case bookMarkCitys
    
    init?(indexPath: NSIndexPath) {
        self.init(rawValue: indexPath.section)
    }
    
    static var numberOfSections: Int { return 3 }
}
class HomeVC: UIViewController {
    
    @IBOutlet weak var weatherReportTableView: UITableView!
    let locationManager = CLLocationManager()
    var weatherManager = WeatherManager()
    var weatherDataModel:WeatherModel!
    var addressCheck:String!
    var bookHistoryArray:[CityModel] = [CityModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

       
    }
    
    //MARK:- SEARCH BTN ACTION
    @IBAction func searchBtnAction(_ sender: Any) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let mapVC = story.instantiateViewController(identifier: "MapsVC") as! MapsVC
        mapVC.delegate = self
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    
}
extension HomeVC:LocationUpdate{
    
    func locationPassing(address: String,lat:Double,long:Double) {
        addressCheck = address
        
        bookHistoryArray.append(CityModel(lat: lat, long: long, name: address))
        if address != ""{
            weatherManager.fetchWeather(latitude: lat, longitude: long)
        }
        
    }
    
    
}


//MARK: - WeatherManagerDelegate
extension HomeVC: WeatherManagerDelegate
{
    func networkError(error: String) {
        showToast(controller: self, message: error, seconds: 1.0)
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        
        
        self.weatherDataModel = weather
        DispatchQueue.main.async {
            self.weatherReportTableView.reloadData()
            
        }
    }
    func didFailWithError(error: Error) {
        print(error)
        showToast(controller: self, message: error.localizedDescription, seconds: 1.0)

    }
    
}

//MARK: - CLLocationManagerDelegate
extension HomeVC: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            if addressCheck != ""{
                weatherManager.fetchWeather(latitude: lat, longitude: lon)
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .todayWeatherReport?:    return 1
        case .bookMarkCitys?: return bookHistoryArray.count
            
        case .none:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .todayWeatherReport?:
            let cell = self.weatherReportTableView.dequeueReusableCell(withIdentifier: "TodayWeatherCell", for: indexPath) as! TodayWeatherCell
           // print("city name",weatherDataModel.cityName)
            
            if weatherDataModel != nil{
                
                cell.temp_lbl.text = weatherDataModel.tempratureInString
                cell.sunImageView.image = UIImage(systemName: weatherDataModel.conditionName)
                cell.cityName_lbl.text = weatherDataModel.cityName
                cell.humidity_lbl.text = "Humidity:" + " " + String(weatherDataModel.humidity) + "%"
                cell.wind_lbl.text = "Wind:" + " " + weatherDataModel.speedInString + " " + "km/h S"
            }
 
            return cell
        case .bookMarkCitys?:
            let cell = self.weatherReportTableView.dequeueReusableCell(withIdentifier: "CitysTableViewCell", for: indexPath) as! CitysTableViewCell
            cell.cityName_lbl.text = bookHistoryArray[indexPath.row].name
            cell.removeBtn.addTarget(self, action: #selector(removeCityFromBookMark), for: UIControl.Event.touchUpInside)
            cell.removeBtn.tag = indexPath.row
            return cell
            
        case .none:
            let cell = self.weatherReportTableView.dequeueReusableCell(withIdentifier: "TodayWeatherCell", for: indexPath) as! TodayWeatherCell
            return cell
        }
    }
    
    //MARK:- REMOVE CITY BOOK MARK
    @objc func removeCityFromBookMark(sender:UIButton){
        bookHistoryArray.remove(at: sender.tag)
        self.weatherReportTableView.reloadData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section) {
        case .todayWeatherReport?:
            return 350
        case .bookMarkCitys:
            return UITableView.automaticDimension
        case.none:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let cityVC = story.instantiateViewController(identifier: "CityVC") as! CityVC
            cityVC.cityData = self.bookHistoryArray[indexPath.row]
            self.navigationController?.pushViewController(cityVC, animated: true)
        }
    }
}


extension UIViewController{
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
