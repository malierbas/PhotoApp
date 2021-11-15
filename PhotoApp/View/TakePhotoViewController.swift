//
//  TakePhotoViewController.swift
//  PhotoApp
//
//  Created by Ali on 14.11.2021.
//

import UIKit

class TakePhotoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.showViewController(storyboardName: "Main", viewController: "CameraViewController")
        }
    }
}
