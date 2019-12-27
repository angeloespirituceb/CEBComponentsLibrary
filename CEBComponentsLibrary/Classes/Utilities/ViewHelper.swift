//
//  ViewHelper.swift
//  CEBComponentsLibrary
//
//  Created by Nicole Jillian Day on 27/12/2019.
//

import Foundation
import UIKit

extension UIView {
    
    //get class name of controller of from view
    var parentViewControllerName: String? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                let coarseName = String(describing: viewController)
                let coarseNameArray = coarseName.split(separator: ".")
                let crudeName = coarseNameArray.last!
                let nameArray = crudeName.split(separator: ":")
                
                return String(nameArray.first!)
            }
        }
        return nil
    }
    
    func CebAddShadow(){
        self.layer.shadowColor = UIColor.black.cgColor;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowRadius  = 10;
        self.layer.shadowOffset  = CGSize(width :0, height :10)
        //      self.layer.r.masksToBounds = false;
        self.layer.cornerRadius  =  10;
        //      self.layer.r.masksToBounds = true
        //      self.layer.r.borderWidth   = 0.5;

        self.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func CebTopRadiusOnly(){
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
         } else {
            //todo implement this
         }
    }
    
    func CebAddShadowTop(){
        self.layer.shadowColor = UIColor.black.cgColor;
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius  = 2;
        self.layer.shadowOffset  = CGSize(width :2, height :3)
        //      self.layer.r.masksToBounds = false;
        self.layer.cornerRadius  =  10;
        //      self.layer.r.masksToBounds = true
        //      self.layer.r.borderWidth   = 0.5;
     
        self.layer.backgroundColor     = UIColor.white.cgColor
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMinYCorner]
                  } else {
        }
    }
    
    func addDropDownToggleImage(view: UIView) -> UIButton {
          let button = UIButton(frame: CGRect(x: 0, y: 0, width: 7.25, height: 5))
          button.backgroundColor = UIColor.white
          
          //needed to separate into segments because bezierpath automatically closes shape
          let segment1 = UIBezierPath()
          segment1.move(to: CGPoint(x: 0, y: 0))
          segment1.addLine(to: CGPoint(x: button.frame.width, y: 0))
          segment1.addLine(to: CGPoint(x: button.frame.width / 2, y: button.frame.height))
          segment1.close()
          
          let arrowLayer = CAShapeLayer()
          arrowLayer.path = segment1.cgPath
          arrowLayer.strokeColor = UIColor(red: 0.745, green: 0.745, blue: 0.745, alpha: 1).cgColor
          arrowLayer.fillColor = UIColor(red: 0.745, green: 0.745, blue: 0.745, alpha: 1).cgColor
          arrowLayer.lineWidth = 2.0
          arrowLayer.lineJoin = CAShapeLayerLineJoin.round
          arrowLayer.lineCap = CAShapeLayerLineCap.round
                     
          button.layer.addSublayer(arrowLayer)

          addSubview(button)
    
          button.snp.makeConstraints { (make) in
              make.centerY.equalTo(self.snp.centerY)
              make.trailing.equalTo(-16)
              make.width.equalTo(7.25)
              make.height.equalTo(5)
          }
          
          return button
      }

}

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else {
            return false
        }
        
    }
    
    var getHeaderDistance :CGFloat {
        let height: CGFloat
        if hasNotch {
              height = 104.98
              return height
        }else {
            
            height = 80.98
            return height
        }
    }
}



extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIButton {
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0) //adjust title accordingly
    }

    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0) //adjust title accordingly
    }
    
    func setImageAsArrowLeft() {
        //needed to separate into segments because bezierpath automatically closes shape
        let segment1 = UIBezierPath()
        segment1.move(to: CGPoint(x: frame.width - 6.63, y: 2.62))
        segment1.addLine(to: CGPoint(x: 6.63, y: frame.height / 2))
        
        
        let segment2 = UIBezierPath()
        segment2.move(to: CGPoint(x: 6.63, y: frame.height / 2))
        segment2.addLine(to: CGPoint(x: frame.width - 6.63, y: frame.height - 2.62))
        
        
        segment1.append(segment2)
        
        let arrowLayer = CAShapeLayer()
        arrowLayer.path = segment1.cgPath
        arrowLayer.strokeColor = UIColor(red: 0, green: 0.376, blue: 0.655, alpha: 1).cgColor
        arrowLayer.fillColor = UIColor(red: 0, green: 0.376, blue: 0.655, alpha: 1).cgColor
        arrowLayer.lineWidth = 2.0
        arrowLayer.lineJoin = CAShapeLayerLineJoin.round
        arrowLayer.lineCap = CAShapeLayerLineCap.round
                   
        layer.addSublayer(arrowLayer)
    }
    
    func setImageAsDismissX() {
        //needed to separate into segments because bezierpath automatically closes shape
        let segment1 = UIBezierPath()
        segment1.move(to: CGPoint(x: 5.41, y: 5.41))
        segment1.addLine(to: CGPoint(x: frame.width - 5.41, y: frame.height - 5.41))
        
        
        let segment2 = UIBezierPath()
        segment2.move(to: CGPoint(x: 5.41, y: frame.height - 5.41))
        segment2.addLine(to: CGPoint(x: frame.width - 5.41, y: 5.41))
        
        
        segment1.append(segment2)
        
        let dissmisXLayer = CAShapeLayer()
        dissmisXLayer.path = segment1.cgPath
        dissmisXLayer.strokeColor = UIColor(red: 0, green: 0.376, blue: 0.655, alpha: 1).cgColor
        dissmisXLayer.fillColor = UIColor(red: 0, green: 0.376, blue: 0.655, alpha: 1).cgColor
        dissmisXLayer.lineWidth = 2.0
        dissmisXLayer.lineJoin = CAShapeLayerLineJoin.round
        dissmisXLayer.lineCap = CAShapeLayerLineCap.round
                   
        layer.addSublayer(dissmisXLayer)
    }
}

extension UIImage {
    func resizeImage(newWidth: CGFloat) -> UIImage? {

        let scale = newWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}



