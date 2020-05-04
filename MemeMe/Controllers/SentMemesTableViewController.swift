//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Vangelis Bouzoukas on 5/2/20.
//  Copyright © 2020 Vangelis Bouzoukas. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        let meme = memes[(indexPath as NSIndexPath).row]
        cell.memeImageView.image = meme.memedImage
        cell.memeTitle.text = "\(meme.topText) \(meme.bottomText)"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeme = memes[(indexPath as NSIndexPath).row]
        
        let memeViewerViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeViewerViewController") as! MemeViewerViewController
        
        memeViewerViewController.meme = selectedMeme
        
        self.navigationController?.pushViewController(memeViewerViewController, animated: true)
    }

}
