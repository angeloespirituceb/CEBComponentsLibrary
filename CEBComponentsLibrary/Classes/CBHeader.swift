////
////  CBHeader.swift
////  CEBComponentsLibrary
////
////  Created by Nicole Jillian Day on 27/12/2019.
////
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
          
          makeRoundedBottomEdge(ofHeight: 24)
          initComponent()
    }
    required public init(data: JSON){
////        CPExpandingMenuList
//        self.headerType = data["headerType"].stringValue
//        self.title = data["title"].stringValue
//        self.className = data["className"].stringValue
//        self.leftBarBNuttonItemAction = data["action"]["name"].string
//        self.leftBarButtonItemActionParameter = data["action"]["parameter"].string
//
//        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: ViewSizeUtil.getHeaderHeight())
//        super.init(frame: frame)
//
//        makeRoundedBottomEdge(ofHeight: 24)
//        initComponent()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 private func initComponent(){
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 0, green: 0.376, blue: 0.655, alpha: 1)
        titleLabel.font = UIFont(name: "FSAlbert-ExtraBold", size: 18)
        titleLabel.textAlignment = .center
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        
        titleLabel.attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.kern: 0.03, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        self.addSubview(titleLabel)
        let titleLabelTopOffset: CGFloat
        let leftBarButtonTopOffset: CGFloat
        let hasNotch = UIDevice.current.hasNotch
        
        if headerType != "main" && !hasNotch {
            titleLabelTopOffset = 17.27
            leftBarButtonTopOffset = 25
        } else if headerType != "main" && hasNotch {
            titleLabelTopOffset = 41.27
            leftBarButtonTopOffset = 49
        } else if headerType == "main" && !hasNotch {
            titleLabelTopOffset = 24
            leftBarButtonTopOffset = 0
        } else {
            titleLabelTopOffset = 48
            leftBarButtonTopOffset = 0
        }
        
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(27)
            make.top.equalTo(titleLabelTopOffset)
            make.centerX.equalToSuperview()
        }
        
        //add subtitleLabel if subTitle exists
        if let subTitle = subTitle {
            let subTitleLabel = UILabel()
            subTitleLabel.textColor = UIColor(red: 0, green: 0.376, blue: 0.655, alpha: 1)
            subTitleLabel.font = UIFont(name: "SourceSansPro-Regular", size: 14)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.19
            
            subTitleLabel.attributedText = NSMutableAttributedString(string: subTitle, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
            
            self.addSubview(subTitleLabel)
            
            subTitleLabel.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(21)
                make.top.equalTo(titleLabel.snp.bottom)
                make.centerX.equalToSuperview()
            }

        }
        
        //add back button if presentation style is "push"
        switch headerType {
        case "pop":
            let backButton = UIButton()
            backButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            backButton.setImageAsArrowLeft()
            
            self.addSubview(backButton)
            
            backButton.snp.makeConstraints { (make) in
                make.top.equalTo(leftBarButtonTopOffset)
                make.leading.equalTo(16)
                make.width.equalTo(24)
                make.height.equalTo(24)
            }
            
            backButton.addTarget(self, action:#selector(handleTapped), for: .touchUpInside)
        case "dismiss":
            let dismissButton = UIButton()
            dismissButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            dismissButton.setImageAsDismissX()
            
            self.addSubview(dismissButton)
            
            dismissButton.snp.makeConstraints { (make) in
                make.top.equalTo(leftBarButtonTopOffset)
                make.leading.equalTo(16)
                make.width.equalTo(24)
                make.height.equalTo(24)
            }
            
            dismissButton.addTarget(self, action:#selector(handleTapped), for: .touchUpInside)
        default:
            print("Doing nothing for now, button headerType switch went to default")
        }
        
        
        snp.makeConstraints { (make) in
            make.height.equalTo(ViewSizeUtil.getHeaderHeight())
        }
    }
    
    @objc func handleTapped(button: UIButton){
        
        print("tapped")
        
        let payload = [
            "actionName": leftBarBNuttonItemAction!,
            "actionParameter": leftBarButtonItemActionParameter!,
            "title": "Your promo code has expired",
            "message": "Promo code is the past valid sale period. You can try another one or proceed without a promo code.",
            "positiveButtonText": "Proceed anyway",
            "negativeButtonText": "Go back"
        ]
        
        NotificationCenter.default.post(name: Notification.Name("button:\(self.className!)"), object: nil, userInfo: payload)
    }

}

extension CBHeader {
    private func makeRoundedBottomEdge(ofHeight height: CGFloat) {
        
        let offsetHeight: CGFloat = 40
        
        let arcBezierPath = UIBezierPath()
        
        arcBezierPath.move(to: CGPoint(x: 0, y: 0))
        arcBezierPath.addLine(to: CGPoint(x: 0, y: frame.height + offsetHeight))
        arcBezierPath.addQuadCurve(to: CGPoint(x: frame.width, y: frame.height + offsetHeight), controlPoint: CGPoint(x: frame.width / 2 , y: frame.height + height + offsetHeight ))
        arcBezierPath.addLine(to: CGPoint(x: frame.width, y: 0))
        arcBezierPath.close()

        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = arcBezierPath.cgPath
        let layer0 = CAGradientLayer()
        layer0.colors = [
          UIColor(red: 0.997, green: 0.926, blue: 0.409, alpha: 1).cgColor,
          UIColor(red: 1, green: 0.804, blue: 0, alpha: 1).cgColor
        ]
    
        layer0.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer0.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer0.frame = CGRect(x: 0, y: 0, width:  bounds.size.width, height:  bounds.size.height + height + offsetHeight)
        layer0.position = center
        
        layer0.mask = shapeLayer
        layer.addSublayer(layer0)
    }
}

 
