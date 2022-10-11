//
//  MainView.swift
//  SwiftUI_WebViewCode
//
//  Created by 조상현 on 2022/10/11.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var viewModel: WebViewModel
    
    let bottomTabHegiht: CGFloat = 55
    @State var bottomTabOffsetY: CGFloat = 0
    
}

extension ContentView {
    
    var bottomTabBar: some View {
        HStack {
            BottomButton(title: "이전", imageStr: "arrow.backward")
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    viewModel.changedTabTypeSubject.send(.BACK)
                }
            
            BottomButton(title: "다음", imageStr: "arrow.forward")
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    viewModel.changedTabTypeSubject.send(.FORWARD)
                }
            
            BottomButton(title: "홈", imageStr: "home.fill")
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    viewModel.changedTabTypeSubject.send(.HOME)
                }
            
            BottomButton(title: "새로고침", imageStr: "goforward")
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    viewModel.changedTabTypeSubject.send(.RELOAD)
                }
        }
    }
    
    var body: some View {
        GeometryReader { geometryReader in
            VStack {
                CustomWebView(url: "https://www.naver.com")
                    .environmentObject(viewModel)
                    .frame(height: geometryReader.size.height - bottomTabHegiht + bottomTabOffsetY)
                
                bottomTabBar
                    .frame(height: bottomTabHegiht)
//                    .offset(y: bottomTabOffsetY)
            }
            .onAppear {
                viewModel
                    .isScrollUp
                    .compactMap { $0 }
                    .sink { isScrollUp in
                        if isScrollUp {
                            if 0 <= bottomTabOffsetY {
                                bottomTabOffsetY -= 1
                            }
                        } else {
                            if bottomTabOffsetY <= bottomTabHegiht + 30 {
                                bottomTabOffsetY += 1
                            }
                        }
                    }
                    .store(in: &viewModel.subscriptions)
            }
        }
    }
    
}

struct BottomButton: View {
    
    var title: String
    var imageStr: String
    
    var body: some View {
        VStack {
            Image(systemName: imageStr)
            
            Text(title)
                .font(.system(size: 12))
        }
    }
    
}
