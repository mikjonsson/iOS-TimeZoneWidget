//
//  ViewController.swift
//  TimeZoneWidget
//
//  Created by Mikael Jonsson on 4/11/2015.
//  Copyright © 2015 mikjonsson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var clockSwitch: UISwitch!
    @IBOutlet weak var daySwitch: UISwitch!
    
    @IBOutlet weak var tzName1: UILabel!
    @IBOutlet weak var tzName2: UILabel!
    @IBOutlet weak var tzName3: UILabel!
    @IBOutlet weak var tzName4: UILabel!
    
    @IBOutlet weak var tz1: UILabel!
    @IBOutlet weak var tz2: UILabel!
    @IBOutlet weak var tz3: UILabel!
    @IBOutlet weak var tz4: UILabel!
    
    var selectedZones: [String?]!
    let zoneCellIdentifier = "TimeZoneCell"
    var timeZones = NSTimeZone.knownTimeZoneNames()
    let defaults = NSUserDefaults(suiteName: "group.com.mikjonsson.TimeZoneWidget")
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    var isFreeApp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetDefaultsIfFree()
        
        timeZones.sortInPlace()
        
        // Hide 4th timezone if device is narrower than 375 (currently older device than iPhone 6)
        if (screenWidth < 375) {
            selectedZones = [String?](count: 3, repeatedValue: nil)
        } else {
            selectedZones = [String?](count: 4, repeatedValue: nil)
        }
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.tableView.registerClass(TimeZonesTableViewCell.self, forCellReuseIdentifier: zoneCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        if (defaults!.objectForKey("clockSwitchState") != nil) {
            clockSwitch.on = defaults!.boolForKey("clockSwitchState")
        } else {
            defaults!.setBool(true, forKey: "clockSwitchState")
            clockSwitch.on = true
        }
        if (defaults!.objectForKey("daySwitchState") != nil) {
            daySwitch.on = defaults!.boolForKey("daySwitchState")
        } else {
            defaults!.setBool(false, forKey: "daySwitchState")
            daySwitch.on = false
        }
        
        if (defaults!.objectForKey("tz1") != nil) {
            selectedZones[0] = defaults!.objectForKey("tz1") as? String
        } else {
            selectedZones[0] = "Asia/Bangkok"
            defaults!.setValue(selectedZones[0], forKey: "tz1")
        }
        if (defaults!.objectForKey("tz2") != nil) {
            selectedZones[1] = defaults!.objectForKey("tz2") as? String
        } else {
            selectedZones[1] = "Australia/Perth"
            defaults!.setValue(selectedZones[1], forKey: "tz2")
        }
        if (defaults!.objectForKey("tz3") != nil) {
            selectedZones[2] = defaults!.objectForKey("tz3") as? String
        } else {
            selectedZones[2] = "Europe/London"
            defaults!.setValue(selectedZones[2], forKey: "tz3")
        }
        
        if (screenWidth >= 375) {
            if (defaults!.objectForKey("tz4") != nil) {
                selectedZones[3] = defaults!.objectForKey("tz4") as? String
            } else {
                selectedZones[3] = "America/Detriot"
                defaults!.setValue(selectedZones[3], forKey: "tz4")
            }
        }
        
        tzName1.text = selectedZones[0]!.location()
        tzName2.text = selectedZones[1]!.location()
        tzName3.text = selectedZones[2]!.location()
        tzName4.text = selectedZones[3]!.location()
        
        updateTime()
    }

    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let select1 = UITableViewRowAction(style: .Normal, title: "1") { action, index in
//            print("1: \(self.timeZones[indexPath.row])")
            self.selectedZones[0] = self.timeZones[indexPath.row]
            self.defaults!.setValue(self.selectedZones[0], forKey: "tz1")
            self.tzName1.text = self.selectedZones[0]!.location()
            tableView.reloadData()
        }
        
        let select2 = UITableViewRowAction(style: .Normal, title: "2") { action, index in
//            print("2: \(self.timeZones[indexPath.row])")
            self.selectedZones[1] = self.timeZones[indexPath.row]
            self.defaults!.setValue(self.selectedZones[1], forKey: "tz2")
            self.tzName2.text = self.selectedZones[1]!.location()
            tableView.reloadData()
        }
        
        let select3 = UITableViewRowAction(style: .Normal, title: "3") { action, index in
//            print("3: \(self.timeZones[indexPath.row])")
            self.selectedZones[2] = self.timeZones[indexPath.row]
            self.defaults!.setValue(self.selectedZones[2], forKey: "tz3")
            self.tzName3.text = self.selectedZones[2]!.location()
            tableView.reloadData()
        }
        
        if (screenWidth >= 375) {
            let select4 = UITableViewRowAction(style: .Normal, title: "4") { action, index in
//                print("4: \(self.timeZones[indexPath.row])")
                self.selectedZones[3] = self.timeZones[indexPath.row]
                self.defaults!.setValue(self.selectedZones[3], forKey: "tz4")
                self.tzName4.text = self.selectedZones[3]!.location()
                tableView.reloadData()
            }
            updateTime()
            return [select4, select3, select2, select1]
        } else {
            updateTime()
            return [select3, select2, select1]
        }
    }
    
    
    func genericAndStandardStyle(arr: [String]) -> [String] {
        return Array(Set( arr.map { "\( (NSTimeZone(name: $0)?.localizedName(NSTimeZoneNameStyle.Generic, locale: NSLocale.currentLocale()))! as String )/\( (NSTimeZone(name: $0)?.localizedName(NSTimeZoneNameStyle.ShortStandard, locale: NSLocale.currentLocale()))! as String )" } )).sort()
    }
    
    
    @IBAction func clockModeSwitch(sender: AnyObject) {
        if clockSwitch.on {
            defaults!.setBool(true, forKey: "clockSwitchState")
        } else {
            defaults!.setBool(false, forKey: "clockSwitchState")
        }
        defaults!.synchronize()
        updateTime()
    }
    @IBAction func dayModeSwitch(sender: AnyObject) {
        if daySwitch.on {
            defaults!.setBool(true, forKey: "daySwitchState")
        } else {
            defaults!.setBool(false, forKey: "daySwitchState")
        }
        defaults!.synchronize()
        updateTime()
    }
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZones.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(zoneCellIdentifier, forIndexPath: indexPath) as! TimeZonesTableViewCell
        
        cell.textLabel?.text = "\(timeZones[indexPath.row]) (\( (NSTimeZone(name: timeZones[indexPath.row])?.localizedName(NSTimeZoneNameStyle.ShortStandard, locale: NSLocale.currentLocale()))! as String ))"
        
        cell.layoutIfNeeded()
        updateTime()
        return cell
    }
    
    func updateTime() {
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
      
        let formatter = NSDateFormatter()
        formatter.dateFormat = "\(dateFormat)\n\(clockFormat)"
        
        formatter.timeZone = NSTimeZone(name: selectedZones[0]!)
        tz1.text = formatter.stringFromDate(NSDate())
        formatter.timeZone = NSTimeZone(name: selectedZones[1]!)
        tz2.text = formatter.stringFromDate(NSDate())
        formatter.timeZone = NSTimeZone(name: selectedZones[2]!)
        tz3.text = formatter.stringFromDate(NSDate())
        formatter.timeZone = NSTimeZone(name: selectedZones[3]!)
        tz4.text = formatter.stringFromDate(NSDate())
        
        // Hide 4th timezone if device width is less than 375 (currently older device than iPhone 6)
        let screenWidth = UIScreen.mainScreen().bounds.width
        if (screenWidth < 375) {
            tzName4.hidden = true
            tz4.hidden = true
        }
    }
    
    
    func resetDefaultsIfFree() {
        if (isFreeApp) {
            for key in Array(defaults!.dictionaryRepresentation().keys) {
                defaults!.removeObjectForKey(key)
            }
        }
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
