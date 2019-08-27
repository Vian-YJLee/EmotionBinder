//
//  Constants.swift
//  EmotionBinder
//
//  Created by LeeYongJin on 2019/08/23.
//  Copyright © 2019 vian. All rights reserved.
//

import Foundation

enum settingType: Int {
    
    case Camera = 0
    case Photo
    
}

struct AlertContentConstants {
    
    static let titles: [String?] = ["카메라 사용 권한", "사진 사용 권한"]
    static let message: [String?] = ["설정 - EmotionBinder에서 카메라 사용 권한을 요청합니다", "설정- EmotionBinder에서 사진 앨범의 접근 권한을 요청합니다"]
    static let cancel: String = "취소"
    static let setting: String = "설정"
    
}
