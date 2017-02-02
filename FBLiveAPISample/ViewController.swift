//
//  ViewController.swift
//  FBLiveAPI
//
//  Created by LeeSunhyoup on 2016. 9. 17..
//  Copyright © 2016년 Lee Sun-Hyoup. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate, VCSessionDelegate {
    @IBOutlet var contentView: UIView!
    @IBOutlet var liveButton: UIButton!
    @IBOutlet var livePrivacyControl: UISegmentedControl!
    
    var session: VCSimpleSession!
    var livePrivacy: FBLivePrivacy = .closed
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liveButton.layer.cornerRadius = 15
        
        session = VCSimpleSession(videoSize: CGSize(width: 1280, height: 720), frameRate: 30, bitrate: 4000000, useInterfaceOrientation: false)
        contentView.addSubview(session.previewView)
        session.previewView.frame = contentView.bounds
        session.delegate = self
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            //start polling locations
            //locationManager.startUpdatingLocation()
        }
        else
        {
            #if debug
                println("Location services are not enabled");
            #endif           
        }
    }
 
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let userLocation:CLLocation = locations[0]
        
        let latitude:CLLocationDegrees = userLocation.coordinate.latitude
        
        let longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        //let latDelta:CLLocationDegrees = 0.05
        
        //let lonDelta:CLLocationDegrees = 0.05
        
        print(latitude)
        
        print(longitude)
        
        /*
         let pin = MKPointAnnotation()
         pin.coordinate.latitude = userLocation.coordinate.latitude
         pin.coordinate.longitude = userLocation.coordinate.longitude
         pin.title = "Your movement line"
         map.addAnnotation(pin)
         */
    }

    
  
    @IBAction func live() {
        switch session.rtmpSessionState {
        case .none, .previewStarted, .ended, .error:
            print("startlive")
            startFBLive()
        default:
            print("endlive")
            endFBLive()
            break
        }
    }
    
    func startFBLive() {
        if FBSDKAccessToken.current() != nil {
            print(FBSDKAccessToken.current())
            FBLiveAPI.shared.startLive(privacy: livePrivacy) { result in
                print(result)
                guard let streamUrlString = (result as? NSDictionary)?.value(forKey: "stream_url") as? String else {
                    return
                }
                let streamUrl = URL(string: streamUrlString)
                
                guard let lastPathComponent = streamUrl?.lastPathComponent,
                    let query = streamUrl?.query else {
                        return
                }
                print(streamUrl as Any)
                self.session.startRtmpSession(
                    withURL: "rtmp://rtmp-api.facebook.com:80/rtmp/",
                    andStreamKey: "\(lastPathComponent)?\(query)"
                )
                
                self.livePrivacyControl.isUserInteractionEnabled = false
            }
        } else {
            fbLogin()
        }
    }
    
    func endFBLive() {
        if FBSDKAccessToken.current() != nil {
            FBLiveAPI.shared.endLive { _ in
                self.session.endRtmpSession()
                self.livePrivacyControl.isUserInteractionEnabled = true
            }
        } else {
            fbLogin()
        }
    }
    
    func fbLogin() {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withPublishPermissions: ["publish_actions"], from: self) {
            (result, error) in
            if error != nil {
                print("Error")
            } else if result?.isCancelled == true {
                print("Cancelled")
            } else {
           
                print("Logged in!")
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name,last_name, picture.type(large),email,updated_time"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        
                        if let userDict = result as? NSDictionary {
                            let first_Name = userDict["first_name"] as! String
                            let last_Name = userDict["last_name"] as! String
                            let id = userDict["id"] as! String
                            //let email = userDict["email"] as! String
                            print(first_Name)
                            print(last_Name)
                            print(id)
                            //print(email)
                            print(userDict)
                            //self.lbShow.text = "Hi " + first_Name
                            //se/lf.show(active : true,name:first_Name)
                        }
                    }
                })
            }

        }
    }
    
    @IBAction func changeLivePrivacy(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            livePrivacy = .closed
        case 1:
            livePrivacy = .everyone
        case 2:
            livePrivacy = .allFriends
        case 3:
            livePrivacy = .friendsOfFriends
        default:
            break
        }
    }
    
    // MARK: VCSessionDelegate
    
    func connectionStatusChanged(_ sessionState: VCSessionState) {
        switch session.rtmpSessionState {
        case .starting:
            liveButton.setTitle("Conneting", for: .normal)
            liveButton.backgroundColor = UIColor.orange
        case .started:
            liveButton.setTitle("Disconnect", for: .normal)
            liveButton.backgroundColor = UIColor.red
        default:
            liveButton.setTitle("Live", for: .normal)
            liveButton.backgroundColor = UIColor.green
        }
    }
}

