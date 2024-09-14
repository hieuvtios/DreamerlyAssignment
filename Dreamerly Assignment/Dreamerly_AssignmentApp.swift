//
//  Dreamerly_AssignmentApp.swift
//  Dreamerly Assignment
//
//  Created by Hieu Vu on 9/9/24.
//

import SwiftUI

@main

struct Dreamerly_AssignmentApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("didShowOnboarding") var didShowOnboarding = false

    var body: some Scene {
        WindowGroup {
            if(didShowOnboarding == false){
                        OnboardingUIView()
            }else{
                ListView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .onAppear(){
                        Utilities.shared.requestNotificationPermission()
                    }
            }
         
        }
    }
}
