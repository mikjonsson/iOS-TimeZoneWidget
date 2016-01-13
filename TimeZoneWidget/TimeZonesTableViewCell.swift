//
//  TimeZones.swift
//  TimeZoneWidget
//
//  Created by Mikael Jonsson on 9/11/2015.
//  Copyright © 2015 mikjonsson. All rights reserved.
//

import UIKit

class TimeZonesTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureView()
    }
    
    func configureView() {
        // add and configure subviews here
    }
    
}