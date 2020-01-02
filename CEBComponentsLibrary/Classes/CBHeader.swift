//
//  CBHeader.swift
//  CEBComponentsLibrary
//
//  Created by Nicole Jillian Day on 02/01/2020.
//

import Foundation
import UIKit
import SwiftyJSON
import SnapKit

public class CBHeader: UIView {
//    let data: String!
    let headerType: String
    
    let title: String!
//    var button: [String]!
//    let buttonImage: [String]!
//    let actionParams: [String]!
    var leftBarBNuttonItemAction: String?
    var leftBarButtonItemActionParameter: String?
    let className: String!
    
    var subTitle: String?
//    var subTitle: String? = "Manila - Singapore"
    
    required public init(data: JSON){
//        self.data = data
        
//        let json = JSON.init(parseJSON: data)
//        let jsonObj = json.dictionaryValue
        
//        var _image = [String]()
//        var _actionName = [String]()
//        var _actionParams = [String]()
        
        self.headerType = data["headerType"].stringValue
//        self.headerType = "pop"
        self.title = data["title"].stringValue
        self.className = data["className"].stringValue
        self.leftBarBNuttonItemAction = data["action"]["name"].string
        self.leftBarButtonItemActionParameter = data["action"]["parameter"].string
        
//        for obj in jsonObj["button"]!.arrayValue {
//            _image.append(obj["image"].stringValue)
//            _actionName.append(obj["action"]["name"].stringValue)
//            _actionParams.append(obj["action"]["parameter"].stringValue)
//        }
        
//        self.buttonImage = _image
//        self.button = _actionName
//        self.actionParams = _actionParams
        
        //self.button = jsonObj["button"]?.arrayValue.map{$0.stringValue}
        //self.buttonImage = jsonObj["buttonImage"]?.arrayValue.map{$0.stringValue}
        
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: ViewSizeUtil.getHeaderHeight())
        super.init(frame: frame)
        
        makeRoundedBottomEdge(ofHeight: 24)
        initComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initComponent(){
//        var buttons = [UIView]()
//        var btns = [UIButton]()
        
        // add title label
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 0, green: 0.376, blue: 0.655, alpha: 1)
        titleLabel.font = UIFont(name: "FSAlbert-ExtraBold", size: 18)
        titleLabel.textAlignment = .center
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        
        titleLabel.attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.kern: 0.03, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        self.addSubview(titleLabel)
        
        
        //adjust top offset to availability of device notch
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
        
        
//        let buttonContainer = UIView()
//        self.addSubview(buttonContainer)
//        buttonContainer.backgroundColor = .white
//        buttonContainer.layer.cornerRadius = 17
//        buttonContainer.layer.masksToBounds = true
//        buttonContainer.layer.borderColor = ColorUtil.hexColor(hex: "#f0f0f0").cgColor
//        buttonContainer.layer.borderWidth = 1
//
//        buttonContainer.snp.makeConstraints { (make) -> Void in
//            make.right.equalTo(-12)
//            make.centerY.equalTo(titleLabel.snp.centerY)
//            make.height.equalTo(34)
//            make.width.equalTo(94)
//        }
        
//        for n in 0...button.count-1 {
//            let buttonImage = UIView()
//            buttonImage.backgroundColor = .white
//
//            let image = UIImage(named: self.buttonImage[n])
//            let imageView = UIImageView(image: image!)
//
//            let button = UIButton()
//            button.setTitle("", for: .normal)
//            button.accessibilityIdentifier = "\(self.button[n]):\(actionParams[n])"
//            button.addTarget(self, action:#selector(handleTapped), for: .touchUpInside)
//            btns.append(button)
//
//            buttonImage.addSubview(imageView)
//
//            imageView.snp.makeConstraints { (make) -> Void in
//                make.center.equalTo(buttonImage.snp.center)
//                make.width.equalTo(buttonImage.snp.width).multipliedBy(0.7)
//                make.height.equalTo(buttonImage.snp.height).multipliedBy(0.7)
//            }
//
//            buttonImage.addSubview(button)
//
//            button.snp.makeConstraints { (make) -> Void in
//                make.width.equalTo(buttonImage.snp.width)
//                make.height.equalTo(buttonImage.snp.height)
//            }
//
//            buttons.append(buttonImage)
//
//        }
        
//        let stackView = UIStackView(arrangedSubviews: buttons)
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        stackView.spacing = 4
//        buttonContainer.addSubview(stackView)
//
//        stackView.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(0)
//            make.bottom.equalTo(0)
//            make.left.equalTo(12)
//            make.right.equalTo(-12)
//        }
        
        snp.makeConstraints { (make) in
            make.height.equalTo(ViewSizeUtil.getHeaderHeight())
        }
//
//        if(headerType != "main"){
//            let leftButtonContainer = UIView()
//            leftButtonContainer.backgroundColor = .white
//            self.addSubview(leftButtonContainer)
//
//            leftButtonContainer.snp.makeConstraints { (make) -> Void in
//                make.bottom.equalTo(-8)
//                make.left.equalTo(8)
//                make.height.width.equalTo(34)
//            }
//
//            switch headerType {
//            case "pop":
//                let leftImage = UIImage(named: "arrow")
//                let leftImageView = UIImageView(image: leftImage!)
//                leftButtonContainer.addSubview(leftImageView)
//
//                leftImageView.snp.makeConstraints { (make) -> Void in
//                    make.width.equalTo(leftButtonContainer.snp.width)
//                    make.height.equalTo(leftButtonContainer.snp.height)
//                }
//            case "dismiss":
//                let leftImage = UIImage(named: "close")
//                let leftImageView = UIImageView(image: leftImage!)
//                leftButtonContainer.addSubview(leftImageView)
//
//                leftImageView.snp.makeConstraints { (make) -> Void in
//                    make.width.equalTo(leftButtonContainer.snp.width)
//                    make.height.equalTo(leftButtonContainer.snp.height)
//                }
//            default:
//                print("")
//            }
//
//            let leftButton = UIButton()
//            leftButton.setTitle("", for: .normal)
//
//            switch headerType {
//            case "pop":
//                leftButton.accessibilityIdentifier = "pop:\(0)"
//            case "dismiss":
//                leftButton.accessibilityIdentifier = "dismiss:\(0)"
//            default:
//                print("")
//            }
//
//            leftButton.addTarget(self, action:#selector(handleTapped), for: .touchUpInside)
//
//            leftButtonContainer.addSubview(leftButton)
//
//            leftButton.snp.makeConstraints { (make) -> Void in
//                make.width.equalTo(leftButtonContainer.snp.width)
//                make.height.equalTo(leftButtonContainer.snp.height)
//            }
//        }
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
        //print(button.accessibilityIdentifier)
    }

}

extension CBHeader {
    func makeRoundedBottomEdge(ofHeight height: CGFloat) {
        
        let offsetHeight: CGFloat = 40
        
        let arcBezierPath = UIBezierPath()
        
        arcBezierPath.move(to: CGPoint(x: 0, y: 0))
        arcBezierPath.addLine(to: CGPoint(x: 0, y: frame.height + offsetHeight))
        arcBezierPath.addQuadCurve(to: CGPoint(x: frame.width, y: frame.height + offsetHeight), controlPoint: CGPoint(x: frame.width / 2 , y: frame.height + height + offsetHeight ))
        arcBezierPath.addLine(to: CGPoint(x: frame.width, y: 0))
        arcBezierPath.close()

        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = arcBezierPath.cgPath
//            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
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
