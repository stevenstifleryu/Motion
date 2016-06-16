//
//  ViewController.swift
//  Stumble
//
//  Created by Andrew Genualdi on 11/22/15.
//  Copyright © 2015 Andrew Genualdi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController{
    
    //Instance Variables
    
    var currentMaxAccelX: Double = 0.0
    var currentMaxAccelY: Double = 0.0
    var currentMaxAccelZ: Double = 0.0
    
    var currentMaxRotX: Double = 0.0
    var currentMaxRotY: Double = 0.0
    var currentMaxRotZ: Double = 0.0
    
    var movementManager = CMMotionManager()
    
    var motionManager = CMMotionManager()
    
    var deviceMotion = CMDeviceMotion()
    
    var ax = 0.0    //
    var ay = 0.0    //
    var az = 0.0    //
    
    
    
    //Outlets
    
    @IBOutlet var accX: UILabel!
    
    @IBOutlet var accY: UILabel!
    @IBOutlet var accZ: UILabel!
    
    @IBOutlet var maxAccX: UILabel!
    
    @IBOutlet var maxAccY: UILabel!
    
    @IBOutlet var maxAccZ: UILabel!
    
    @IBOutlet var rotX: UILabel!
    
    
    @IBOutlet var rotY: UILabel!
    @IBOutlet var rotZ: UILabel!
    
    @IBOutlet var maxRotX: UILabel!
    @IBOutlet var maxRotY: UILabel!
    @IBOutlet var maxRotZ: UILabel!
    
    
    @IBOutlet var X: UILabel!
    @IBOutlet var Y: UILabel!
    @IBOutlet var Z: UILabel!
    
    
    @IBAction func resetMaxValues(sender: AnyObject) {
        
        
        currentMaxAccelX = 0
        currentMaxAccelY = 0
        currentMaxAccelZ = 0
        
        currentMaxRotX = 0
        currentMaxRotY = 0
        currentMaxRotZ = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentMaxAccelX = 0
        currentMaxAccelY = 0
        currentMaxAccelZ = 0
        
        currentMaxRotX = 0
        currentMaxRotY = 0
        currentMaxRotZ = 0
        
        movementManager.gyroUpdateInterval = 0.2
        movementManager.accelerometerUpdateInterval = 0.2
        movementManager.magnetometerUpdateInterval = 0.2
        
        motionManager.gyroUpdateInterval = 0.2
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.magnetometerUpdateInterval = 0.2
        motionManager.deviceMotionUpdateInterval = 0.2   //
        
        
        
        
        //Start Recording Data
        
        
        movementManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            
            self.outputAccData(accelerometerData!.acceleration)
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
        
        movementManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (gyroData: CMGyroData?, NSError) -> Void in
            self.outputRotData(gyroData!.rotationRate)
            if (NSError != nil){
                print("\(NSError)")
            }
            
            
        })
        
        
        motionManager.startDeviceMotionUpdatesUsingReferenceFrame(CMAttitudeReferenceFrame.XTrueNorthZVertical, toQueue: NSOperationQueue.currentQueue()!, withHandler: { motion,  error in
            let acc: CMAcceleration = motion!.userAcceleration
            let rot = motion!.attitude.rotationMatrix
            self.ax = (acc.x*rot.m11 + acc.y*rot.m21 + acc.z*rot.m31)*9.81
            self.ay = (acc.x*rot.m12 + acc.y*rot.m22 + acc.z*rot.m32)*9.81
            self.az = (acc.x*rot.m13 + acc.y*rot.m23 + acc.z*rot.m33)*9.81
            
            self.outputRefData()
        })
        
    }
    
    
    func outputRefData(){//acceleration: CMAttitudeReferenceFrame) {
        
        X.text = "x\(ax).2fg"
        Y.text = "y\(ay).2fg"
        Z.text = "z\(az).2fg"
        
    }
    
    
    
    func outputAccData(acceleration: CMAcceleration){
        
        accX?.text = "\(acceleration.x).2fg"
        if fabs(acceleration.x) > fabs(currentMaxAccelX)
        {
            currentMaxAccelX = acceleration.x
        }
        
        accY?.text = "\(acceleration.y).2fg"
        if fabs(acceleration.y) > fabs(currentMaxAccelY)
        {
            currentMaxAccelY = acceleration.y
        }
        
        accZ?.text = "\(acceleration.z).2fg"
        if fabs(acceleration.z) > fabs(currentMaxAccelZ)
        {
            currentMaxAccelZ = acceleration.z
        }
        
        
        maxAccX?.text = "\(currentMaxAccelX).2f"
        maxAccY?.text = "\(currentMaxAccelY).2f"
        maxAccZ?.text = "\(currentMaxAccelZ).2f"
        
        
    }
    
    func outputRotData(rotation: CMRotationRate){
        
        
        rotX?.text = "\(rotation.x).2fr/s"
        if fabs(rotation.x) > fabs(currentMaxRotX)
        {
            currentMaxRotX = rotation.x
        }
        
        rotY?.text = "\(rotation.y).2fr/s"
        if fabs(rotation.y) > fabs(currentMaxRotY)
        {
            currentMaxRotY = rotation.y
        }
        
        rotZ?.text = "\(rotation.z).2fr/s"
        if fabs(rotation.z) > fabs(currentMaxRotZ)
        {
            currentMaxRotZ = rotation.z
        }
        
        
        
        
        maxRotX?.text = "\(currentMaxRotX).2f"
        maxRotY?.text = "\(currentMaxRotY).2f"
        maxRotZ?.text = "\(currentMaxRotZ).2f"
        
        
        
    }
    
}