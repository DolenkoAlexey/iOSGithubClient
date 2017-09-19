//
//  UserExploreViewController.swift
//  iOSAppForGitHub
//
//  Created by Alex Dolenko on 19/09/2017.
//  Copyright © 2017 Alex Dolenko. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserExploreViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTranslucency()
    }

    
    private func setTranslucency() {
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifiers.userEmbed,
            let userViewController = segue.destination as? UserViewController {
            
            let userName = searchBar.rx.text
                .orEmpty
                .asDriver()
                .throttle(1)
                .distinctUntilChanged()
            
            userViewController.userName = userName
            userViewController.viewModel = UserViewModel()
        }
        
    }
 

}
