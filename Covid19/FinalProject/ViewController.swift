//
//  ViewController.swift
//  FinalProject
//
//  Created by Student on 2020-04-17.
//  Copyright © 2020 khushbuSoni. All rights reserved.
//

import UIKit
import CoreLocation
import Charts
import MessageUI

struct Covid: Codable{
    let totalConfirmed: Int
    let totalDeaths: Int
    let totalRecovered: Int
    let areas: [areas]
}

struct areas: Codable {
    let displayName : String    
    let totalConfirmed: Int?
    let totalDeaths: Int?
    let lat: Double
    let long: Double
}

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var totalCase: UILabel!
    @IBOutlet weak var recoveredCase: UILabel!
    @IBOutlet weak var deaths: UILabel!
    @IBOutlet weak var recoverPercentage: UILabel!
    @IBOutlet weak var deathPercentage: UILabel!
    @IBOutlet weak var barChart: BarChartView!
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var lblConfirmedCases: UILabel!
    @IBOutlet weak var lblDeathCases: UILabel!
    
   
    
    
    let locationManager = CLLocationManager()
    var currentLoc: CLLocation?
    var currentLat: Double?
    var currentLong: Double?
    var collectionOfData = [CLLocationDistance]()
    var index : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.getData()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {return}
        self.currentLoc = location
        self.getData()
        
    }
    
    func getData(){
        let jURL = "https://www.bing.com/covid/data"
        
        guard let url = URL(string: jURL) else {return}
        URLSession.shared.dataTask(with: url){( data, response, err) in
            
            //print("hello")
            guard let data = data else{return}
            
            do{
                
                let covid = try JSONDecoder().decode(Covid.self, from: data)
                //                print(covid)
                
                for i in 0..<covid.areas.count
                {
                    let countryLocation = CLLocation(latitude: covid.areas[i].lat, longitude: covid.areas[i].long)
                    print(self.currentLoc!)
                    print(countryLocation)
                    let distance = self.currentLoc!.distance(from: countryLocation)
                    self.collectionOfData.append(distance)
                    let minOfData = self.collectionOfData.min()
                    let firstData = self.collectionOfData.firstIndex(of: minOfData!)
                    print(firstData!)
                    self.index = firstData!
                }
                self.updateUI(covid)
                
            }
            catch let jsonErr{
                print("I cannot decode the data", jsonErr)
            }
            
        }.resume()
    }
    
    func updateUI(_ covid: Covid)
    {
        
        DispatchQueue.main.async{
            
            
           if self.currentLoc != nil{
                CLGeocoder().reverseGeocodeLocation(self.currentLoc!) { (placemark, err) in
                    
                    if err == nil{
                       if let country = placemark?.first?.country{
                            
                           let area = covid.areas.first(where: {$0.displayName == country})
                            
                            DispatchQueue.main.async {
                                self.setCountryData(area)
                            }
                        }
                    }
                }
            }

            let d1 = BarChartDataEntry(x: 1,y: Double(covid.totalRecovered))
            let d2 = BarChartDataEntry(x: 2,y: Double(covid.totalDeaths))
            let dataSet = BarChartDataSet(entries: [d1,d2], label: "Coviddata")
            dataSet.colors = [.systemPink,.systemGreen]
            let chartData = BarChartData(dataSet: dataSet)
            self.barChart.data = chartData
            
            
            self.totalCase.text = "C \(String(covid.totalConfirmed))"
            
            self.recoveredCase.text = "R \(String(covid.totalRecovered))"
            
            self.deaths.text = "D \(String(covid.totalDeaths))"
            
            self.deathPercentage.text = "Deaths \(String(((covid.totalDeaths)*100)/covid.totalConfirmed))%"
            
            self.recoverPercentage.text = "Recovered \(String(((covid.totalRecovered)*100)/covid.totalConfirmed))%"
            self.countryName.text = covid.areas[(self.index)!].displayName
            self.lblConfirmedCases.text = " \(Int(covid.areas[(self.index)!].totalConfirmed!))"
          //  self.testlbl.text = "T \(Int(covid.areas[(self.index)!].totalRecovered!))"
            self.lblDeathCases.text = " \(Int(covid.areas[(self.index)!].totalDeaths!))"
         
        }
    }
    
    func setCountryData(_ area: areas?){
        
      guard let area = area else {
            return
        }
      
    }
    
}


