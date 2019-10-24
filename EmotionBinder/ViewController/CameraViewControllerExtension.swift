//
//  CameraViewControllerExtension.swift
//  EmotionBinder
//
//  Created by LeeYongJin on 2019/10/24.
//  Copyright © 2019 vian. All rights reserved.
//

import UIKit
import AVFoundation

@available(iOS 10.2, *)
extension CameraViewController {
    
        
        enum FlashModeCheck: Int {
            case off = 0
            case on
            case auto
            //열거형으로 상태 검증..
        }
        
        
        func getFlashModeConstants(_ mode: Int) -> AVCaptureDevice.FlashMode {
            // Objective-C 문법..애플 개발자 문서 상세 참조...
            
            var valueOfFlashMode: AVCaptureDevice.FlashMode = .off
            
            
            if #available(iOS 10.2, *) {
                switch mode {
                case FlashModeCheck.off.rawValue: valueOfFlashMode = .off
                case FlashModeCheck.auto.rawValue: valueOfFlashMode = .auto
                case FlashModeCheck.on.rawValue: valueOfFlashMode = .on
                    
                default:
                    break;
                }
            } else {
                // Fallback on earlier versions
            }
            return valueOfFlashMode
        }
    
    
    
    // MARK:- Change the Device's activeFormet property
    
    func showNotice(alertCase : settingType) {
        
        let alertController = UIAlertController(title: AlertContentConstants.titles[alertCase.rawValue], message: AlertContentConstants.message[alertCase.rawValue], preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: AlertContentConstants.setting, style: .default, handler: { (action: UIAlertAction) -> Void in
            let settingUrl = URL(string: UIApplication.openSettingsURLString)
            if #available(iOS 10.2, *) {
                UIApplication.shared.open(settingUrl!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(settingUrl!)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: AlertContentConstants.cancel, style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}

