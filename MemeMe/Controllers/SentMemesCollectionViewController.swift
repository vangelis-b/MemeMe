//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Vangelis Bouzoukas on 5/2/20.
//  Copyright © 2020 Vangelis Bouzoukas. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Properties
    
    private var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    private var cellSpacing: CGFloat = 3.0
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.reloadData()
        
        let spacing: CGFloat = 3.0
        let numberOfItemsPerRow: CGFloat = UIDevice.current.orientation.isPortrait ? 3 : 5
        let dimension: CGFloat = (collectionView.frame.width - (numberOfItemsPerRow - 1) * cellSpacing) / numberOfItemsPerRow

        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
    
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
