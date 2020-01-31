//
//  SettingsViewController.swift
//  Broaden
//
//  Created by Adam Szczygiel on 05/12/2019.
//  Copyright © 2019 broaden. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let app = App();
    let global = Global();
    let user = User();
    
    @IBOutlet weak var spectrumPicker: UIPickerView!
    @IBOutlet weak var purgeButton: UIButton!
    
    var spectrumPickerData: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //connect data
        self.spectrumPicker.delegate = self
        self.spectrumPicker.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(user.getPoliticalLeaning() == ""){
            spectrumPicker.selectRow(0, inComponent: 0, animated: true)
        }else{
            spectrumPicker.selectRow(global.politicalSpectrum.firstIndex(of: user.getPoliticalLeaning())!, inComponent: 0, animated: true)
        }
    }
    
    //number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return global.politicalSpectrum.count
    }
    
    //data to return for every row and column thats being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return global.politicalSpectrum[row]
    }

    //capture the picker selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row != 0){
            user.savePoliticalLeaning(leaning: global.politicalSpectrum[row])
            let alert = UIAlertController(title: "Yay!", message: "Your political outlook has been saved.", preferredStyle: .alert)
            self.present(alert, animated:true, completion:{Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
        }else{
            spectrumPicker.selectRow(global.politicalSpectrum.firstIndex(of: user.getPoliticalLeaning())!, inComponent: 0, animated: true)
            let alert = UIAlertController(title: "Sorry!", message: "Your political outlook cannot be blank.", preferredStyle: .alert)
            self.present(alert, animated:true, completion:{Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
        }

    }

    @IBAction func purgeButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "This action cannot be undone!", message: "Do you wish to delete all of your reading data, saved articles and personalisation options?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes!", style: .default) { action -> Void in
            self.user.purgeAllSavedArticles()
            self.user.purgeNewsFeed()
            self.user.purgePoliticalLeaning()
            self.app.setFirstLaunch()
            self.tabBarController?.selectedIndex = self.global.navigationIndexNews
        })
        self.present(alert, animated:true)
        
    }
    
    
}
