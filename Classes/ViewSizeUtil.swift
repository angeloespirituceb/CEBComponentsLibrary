//
//  ViewSizeUtil.swift
//  CEBComponentsLibrary
//
//  Created by Nicole Jillian Day on 02/01/2020.
//

import Foundation
import UIkit
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
