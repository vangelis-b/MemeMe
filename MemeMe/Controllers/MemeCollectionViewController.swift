//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Vangelis Bouzoukas on 5/2/20.
//  Copyright © 2020 Vangelis Bouzoukas. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
    
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.memeImageView.image = meme.memedImage
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeViewerViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewerViewController") as! MemeViewerViewController
        
        memeViewerViewController.meme = self.memes[(indexPath as NSIndexPath).row]
        
        self.navigationController?.pushViewController(memeViewerViewController, animated: true)
    }

}
