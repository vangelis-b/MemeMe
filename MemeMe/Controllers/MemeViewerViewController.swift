//
//  MemeViewerViewController.swift
//  MemeMe
//
//  Created by Vangelis Bouzoukas on 5/2/20.
//  Copyright © 2020 Vangelis Bouzoukas. All rights reserved.
//

import UIKit

class MemeViewerViewController: UIViewController {
    
    // MARK: - Properties
    
    var meme: Meme!
    
    // MARK: - Outlets

    @IBOutlet weak var memeImageView: UIImageView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        self.memeImageView.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }

}
