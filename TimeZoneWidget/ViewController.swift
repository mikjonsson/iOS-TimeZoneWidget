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
    
    var selectedZones = [String?](count: 4, repeatedValue: nil)
    let zoneCellIdentifier = "TimeZoneCell"
    var timeZones = NSTimeZone.knownTimeZoneNames()
    let defaults = NSUserDefaults(suiteName: "group.com.mikjonsson.TimeZoneWidget")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            selectedZones[0] = timeZones[0]
            defaults!.setValue(selectedZones[0], forKey: "tz1")
        }
        if (defaults!.objectForKey("tz2") != nil) {
            selectedZones[1] = defaults!.objectForKey("tz2") as? String
        } else {
            selectedZones[1] = timeZones[1]
            defaults!.setValue(selectedZones[1], forKey: "tz2")
        }
        if (defaults!.objectForKey("tz3") != nil) {
            selectedZones[2] = defaults!.objectForKey("tz3") as? String
        } else {
            selectedZones[2] = timeZones[2]
            defaults!.setValue(selectedZones[2], forKey: "tz3")
        }
        if (defaults!.objectForKey("tz4") != nil) {
            selectedZones[3] = defaults!.objectForKey("tz4") as? String
        } else {
            selectedZones[3] = timeZones[3]
            defaults!.setValue(selectedZones[3], forKey: "tz4")
        }
        
        sortAndCheck()
    }

    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let select1 = UITableViewRowAction(style: .Normal, title: "1") { action, index in
            print("1: \(self.timeZones[indexPath.row])")
            
            self.selectedZones[0] = self.timeZones[indexPath.row]
            self.defaults!.setValue(self.selectedZones[0], forKey: "tz1")

            self.sortAndCheck()
            
            tableView.reloadData()
        }
        
        let select2 = UITableViewRowAction(style: .Normal, title: "2") { action, index in
            print("2: \(self.timeZones[indexPath.row])")
            
            self.selectedZones[1] = self.timeZones[indexPath.row]
            self.defaults!.setValue(self.selectedZones[1], forKey: "tz2")

            self.sortAndCheck()
            
            tableView.reloadData()
        }
        
        let select3 = UITableViewRowAction(style: .Normal, title: "3") { action, index in
            print("3: \(self.timeZones[indexPath.row])")
            
            self.selectedZones[2] = self.timeZones[indexPath.row]
            self.defaults!.setValue(self.selectedZones[2], forKey: "tz3")

            self.sortAndCheck()
            
            tableView.reloadData()
        }
        
        let select4 = UITableViewRowAction(style: .Normal, title: "4") { action, index in
            print("4: \(self.timeZones[indexPath.row])")
            
            self.selectedZones[3] = self.timeZones[indexPath.row]
            self.defaults!.setValue(self.selectedZones[3], forKey: "tz4")

            self.sortAndCheck()
            
            tableView.reloadData()
        }

        return [select4, select3, select2, select1]
    }
    
    
    func sortAndCheck() {
        timeZones.sortInPlace()
        timeZones.removeAtIndex(timeZones.indexOf(selectedZones[0]!)!)
        timeZones.insert(selectedZones[0]!, atIndex: 0)
        timeZones.removeAtIndex(timeZones.indexOf(selectedZones[1]!)!)
        timeZones.insert(selectedZones[1]!, atIndex: 1)
        timeZones.removeAtIndex(timeZones.indexOf(selectedZones[2]!)!)
        timeZones.insert(selectedZones[2]!, atIndex: 2)
        timeZones.removeAtIndex(timeZones.indexOf(selectedZones[3]!)!)
        timeZones.insert(selectedZones[3]!, atIndex: 3)
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
    }
    @IBAction func dayModeSwitch(sender: AnyObject) {
        if daySwitch.on {
            defaults!.setBool(true, forKey: "daySwitchState")
        } else {
            defaults!.setBool(false, forKey: "daySwitchState")
        }
        defaults!.synchronize()
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
        
        if (indexPath.row > 3) {
            cell.accessoryType = .None
        } else {
            cell.accessoryType = .Checkmark
        }
        
        cell.textLabel?.text = "\(timeZones[indexPath.row]) (\( (NSTimeZone(name: timeZones[indexPath.row])?.localizedName(NSTimeZoneNameStyle.ShortStandard, locale: NSLocale.currentLocale()))! as String ))"
        cell.layoutIfNeeded()
        
        return cell
    }
}
