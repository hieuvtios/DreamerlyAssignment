//
//  OnboardingUIView.swift
//  VoiceChanger
//
//  Created by Hieu Vu on 15/11/2023.
//

import SwiftUI
extension UserDefaults {
    var didShowOnboarding: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "didShowOnboarding")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "didShowOnboarding")
        }
    }
}
enum OnboardingPage: String, CaseIterable {

    case one
    case two
    case three
    var largeTitle: String {
        switch self {
        case .one:
            return "Task Management"
        case .two:
            return "To-Do List"
        case .three:
            return "Manage Your Daily Task"
        }
    }
    var title: String {
        switch self {
        case .one:
            return "This productive tool is designed to help you better manage your task"
        case .two:
            return "This productive tool is designed to help you better manage your tasks"
        case .three:
            return "This productive tool is designed to help you better manage your task"
        }
    }
    var image: Image {
        switch self {
        case .one:
            return Image("onboarding1")
        case .two:
            return Image("onboarding2")
        case .three:
            return Image("onboarding3")
        }
    }
}

struct OnboardingUIView: View {
    @State var listPage = OnboardingPage.allCases
    var nextBlock: (()->Void)?
    @AppStorage("didShowOnboarding") var didShowOnboarding = false
    @State var currentItem: OnboardingPage = .one
    @State var loadAdFaild: Bool = false
    
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black
    }
    fileprivate func nextTapped() {
        if currentItem == .three {
            didShowOnboarding = true
            nextBlock?()
        } else if currentItem == .one {
            withAnimation {
                currentItem = .two
            }
        } else {
            withAnimation {
                currentItem = .three
            }
        }
    }
    var body: some View {
        if #available(iOS 14.0, *) {
            ZStack(alignment: .top) {
                Color.white
                    .ignoresSafeArea()
              
                VStack{
                    ZStack{
                        TabView(selection: $currentItem) {
                            ForEach(listPage, id: \.self) { item in
                                VStack {
                                    ZStack(alignment:.topTrailing){
                                        Color.white
                                      

                                        VStack{
                                            Spacer().frame(height: 100)
                                            item.image
                                                .resizable()
                                                .scaledToFit()
                                                .background(Color.white)
                                        
                                        }

                                    }
                                    Spacer()
                                    Text(item.largeTitle)
                                        .font(.title.bold())
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .padding()
                                    Spacer().frame(height: 2)
                                    Text(item.title)
                                        .lineSpacing(10)
                                        .foregroundColor(.black)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                        .font(.callout)
                                        .padding(.horizontal,50)
                                    //                                .modifier(TextGradientStyle())
                                    Spacer().frame(minHeight: 20, maxHeight: 30)
                                   
                                    HStack{
                                        VStack{
                                            Spacer().frame(height: 5)
                                            HStack(alignment:.bottom){
                                                ForEach(listPage, id: \.self) { item in
                                                    if item == currentItem{
                                                        Rectangle()
                                                            .frame(width: 24,height: 8)
                                                            .cornerRadius(5)
                                                            .foregroundColor(Color(hex: "01597C"))
                                                    }else{
                                                        Circle().frame(height: 8)
                                                       
                                                            .foregroundColor(Color.black.opacity(0.5))

                                                    }
                                                }
                                            }.frame(width: 50,height: 35)
                                        }
                                        Spacer()
                                        Button(action: {
                                            nextTapped()
                                        }, label: {
                                            HStack{
                                                Spacer()
                                                Text(currentItem == .three ? "Start" : "Next")
                                                    .foregroundColor(.white)
                                                Spacer()
                                            }  .contentShape(Rectangle())
                                            
                                        })
                                        .frame(width: 116, height: 35)
                                        .contentShape(Rectangle())
                                        .foregroundColor(.white)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color(hex: "009F79"), Color(hex: "00147D")]), startPoint: .leading, endPoint: .trailing)
                                        )
                                        .cornerRadius(50)
                                        .padding(.top,20)
                                        .padding(.horizontal,20)
                                    }
                                    .padding(.horizontal,10)
                                    Spacer().frame(height: 10)
                                  
                                }
                                .edgesIgnoringSafeArea([.all])
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .indexViewStyle(.page(backgroundDisplayMode: .never))
                        .edgesIgnoringSafeArea(.top)
                        Spacer()
                    }
                }
                .onAppear {
                    setupAppearance()
                }
            }
            
        }
        
    }
}
#Preview {
    OnboardingUIView()
}
