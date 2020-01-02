//
//  ViewSizeUtil.swift
//  Cebu Pacific
//
//  Created by Gino Alo on 16/12/2019.
//  Copyright © 2019 Randell Joseph Ramirez. All rights reserved.
//

import UIKit

class ViewSizeUtil {
    
    //should make adjustments to headerHeight when UIDevice has top notch
    static func getHeaderHeight() -> CGFloat {
        if UIDevice.current.hasNotch {
            return 104.98
        } else {
            return 80.98
        }
    }
}
