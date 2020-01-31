//
//  App.swift
//  Broaden
//
//  Created by Adam Szczygiel on 05/12/2019.
//  Copyright © 2019 broaden. All rights reserved.
//  A App class to decide what to do with app variables - for now this only controls what happens at first launch, but of course this could be expanded to produce behaviour after an update or for showing new features etc.
//

import UIKit

class App{
    
    //using userDefaults to store app data
    let defaults = UserDefaults.standard
    
    //function to check if it is the first launch of the app
    func isFirstLaunch() -> Bool {
        if(defaults.bool(forKey: "AppLaunchedBefore") == true){
            //after first launch
            return false
        }else{
            //first launch
            defaults.set(true, forKey: "AppLaunchedBefore")
            return true
        }
    }
    
    //function to set the first launch - Broaden uses this to ask user for data about them
    func setFirstLaunch() {
        defaults.set(false, forKey: "AppLaunchedBefore")
    }
    
}
