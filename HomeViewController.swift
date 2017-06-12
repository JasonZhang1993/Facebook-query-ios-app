//
//  HomeViewController.swift
//  FB Search
//
//  Created by Jason Zhang on 4/9/17.
//  Copyright © 2017 Jason Zhang. All rights reserved.
//

import UIKit
import EasyToast
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var keyword: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    let manager = CLLocationManager()
    
    
    @IBAction func clear(_ sender: UIButton) { // clear function to be done
        SearchKeyword.keyword = ""
        SearchKeyword.detailObj = [:]
        keyword.text! = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            manager.startUpdatingLocation()
        }
        else if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .restricted {
            print("Unable to get location")
        }
        
        sideMenu()
        searchButton.addTarget(self, action: #selector(HomeViewController.search), for: .touchUpInside)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        manager.stopUpdatingLocation()
        SearchKeyword.center = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        print(SearchKeyword.center) // testing
    }

    func sideMenu() {
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = UIScreen.main.bounds.size.width * 0.85 // the width of side menu
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.keyword.resignFirstResponder()
    }
    
    func search() {
        if keyword.text!.isEmpty {
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.toastTextColor = UIColor.white
            self.view.toastFont = UIFont.systemFont(ofSize: 19)
            
            self.view.showToast("Enter a valid query!", position: .bottom, popTime: kToastNoPopTime, dismissOnTap: true)
        }
        else { // deal with space case
            SearchKeyword.keyword = (keyword.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!
            let revealViewController:SWRevealViewController = self.revealViewController()
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let desController = mainStoryboard.instantiateViewController(withIdentifier: "SearchTable") as! UITabBarController
            let newFrontViewController = UINavigationController.init(rootViewController:desController)
            revealViewController.pushFrontViewController(newFrontViewController, animated: true)
//            present(desController, animated: false, completion: nil)
        }
    }
    
    

}
