//
//  TodayViewController.swift
//  TheWidget
//
//  Created by Mikael Jonsson on 4/11/2015.
//  Copyright © 2015 mikjonsson. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var tzName1: UILabel!
    @IBOutlet weak var tzName2: UILabel!
    @IBOutlet weak var tzName3: UILabel!
    @IBOutlet weak var tzName4: UILabel!
    
    @IBOutlet weak var tz1: UILabel!
    @IBOutlet weak var tz2: UILabel!
    @IBOutlet weak var tz3: UILabel!
    @IBOutlet weak var tz4: UILabel!
    
    var tz1Selection: String!
    var tz2Selection: String!
    var tz3Selection: String!
    var tz4Selection: String!
    
    let defaults = NSUserDefaults(suiteName: "group.com.mikjonsson.TZWidget")
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateClocks()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        updateClocks()
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func updateClocks() {
        var clockFormat = "HH:mm"
        var dateFormat = "EEE"
        
        if (defaults!.objectForKey("clockSwitchState") != nil) {
            if (defaults!.boolForKey("clockSwitchState")) {
               clockFormat = "HH:mm"
            } else {
                clockFormat = "h:mm a"
            }
        }
        if (defaults!.objectForKey("daySwitchState") != nil) {
            if (defaults!.boolForKey("daySwitchState")) {
                dateFormat = "dd"
            } else {
                dateFormat = "EEE"
            }
        }
        
        
        if (defaults!.objectForKey("tz1") != nil) {
            tz1Selection = defaults!.objectForKey("tz1") as! String
        } else {
            tz1Selection = "Asia/Bangkok"
            defaults!.setValue(tz1Selection, forKey: "tz1")
        }
        if (defaults!.objectForKey("tz2") != nil) {
            tz2Selection = defaults!.objectForKey("tz2") as! String
        } else {
            tz2Selection = "Australia/Perth"
            defaults!.setValue(tz2Selection, forKey: "tz2")
        }
        if (defaults!.objectForKey("tz3") != nil) {
            tz3Selection = defaults!.objectForKey("tz3") as! String
        } else {
            tz3Selection = "Europe/London"
            defaults!.setValue(tz3Selection, forKey: "tz3")
        }
        if (defaults!.objectForKey("tz4") != nil) {
            tz4Selection = defaults!.objectForKey("tz4") as! String
        } else {
            tz4Selection = "America/Detriot"
            defaults!.setValue(tz4Selection, forKey: "tz4")
        }
        
        tzName1.text = tz1Selection.location()
        tzName2.text = tz2Selection.location()
        tzName3.text = tz3Selection.location()
        tzName4.text = tz4Selection.location()
        
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "\(dateFormat)\n\(clockFormat)"
        
        formatter.timeZone = NSTimeZone(name: tz1Selection)
        tz1.text = formatter.stringFromDate(NSDate())
        
        formatter.timeZone = NSTimeZone(name: tz2Selection)
        tz2.text = formatter.stringFromDate(NSDate())
        
        formatter.timeZone = NSTimeZone(name: tz3Selection)
        tz3.text = formatter.stringFromDate(NSDate())
        
        formatter.timeZone = NSTimeZone(name: tz4Selection)
        tz4.text = formatter.stringFromDate(NSDate())
        
        // Hide 4th timezone if device width is less than 375 (currently older device than iPhone 6)
        let screenWidth = UIScreen.mainScreen().bounds.width
        if (screenWidth < 375) {
            tzName4.hidden = true
            tz4.hidden = true
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let url: NSURL = NSURL(string: "com.mikjonsson.TimeZoneWidget://")!
        self.extensionContext?.openURL(url, completionHandler: nil)
    }
}

// Fetch area or location of the timezone, and return full timezone name if it fails
extension String
{
    public func area() -> String? {
        if let i = self.characters.indexOf("/") {
            return self.substringToIndex(i)
        }
        return self
    }
    
    public func location() -> String? {
        if let i = self.characters.indexOf("/") {
            return self.substringFromIndex(i.successor())
        }
        return self
    }
}
