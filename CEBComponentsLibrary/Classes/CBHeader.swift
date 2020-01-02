//
//  CBHeader.swift
//  CEBComponentsLibrary
//
//  Created by Nicole Jillian Day on 02/01/2020.
//

import Foundation
import SwiftyJSON
import SnapKit
 


open class CBHeader: UIView {
    let headerType: String!
    let title: String!
    var leftBarBNuttonItemAction: String?
    var leftBarButtonItemActionParameter: String?
    let className: String!
    var subTitle: String?
    required public init(data: JSON) {
        //        CPExpandingMenuList
          self.headerType = data["headerType"].stringValue
          self.title = data["title"].stringValue
          self.className = data["className"].stringValue
          self.leftBarBNuttonItemAction = data["action"]["name"].string
          self.leftBarButtonItemActionParameter = data["action"]["parameter"].string
        
          let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: ViewSizeUtil.getHeaderHeight())
          super.init(frame: frame)
          
        //   makeRoundedBottomEdge(ofHeight: 24)
        //   initComponent()
    }
 
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
