//
//  WebViewModel.swift
//  SwiftUI_WebViewCode
//
//  Created by 조상현 on 2022/10/11.
//

import Foundation
import Combine

typealias BottomTabType = WebViewModel.TabType

class WebViewModel: ObservableObject {
    
    enum TabType {
        case BACK
        case FORWARD
        case HOME
        case RELOAD
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    var isScrollUp = PassthroughSubject<Bool, Never>()
    var changedTabTypeSubject = PassthroughSubject<BottomTabType, Never>()
    
}
