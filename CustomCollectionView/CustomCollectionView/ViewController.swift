//
//  ViewController.swift
//  CustomCollectionView
//
//  Created by HuuTrung on 12/11/17.
//  Copyright © 2017 HuuTrung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var clvCustom: UICollectionView!

    var photos = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        clvCustom.delegate = self
        clvCustom.dataSource = self
        if let layout = clvCustom.collectionViewLayout as? CustomCollectionLayout {
            layout.delegate = self
        }
        
        clvCustom.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        for i in 0...9 {
            photos.append(UIImage(named: "\(i+1)")!)
        }
//        clvCustom.contentSize = CGSize(width: UIScreen.main.bounds.size.width*2, height: UIScreen.main.bounds.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        let se: Selector = #selector(dismissVC)
        //        self.perform(se, with: nil, afterDelay: 3)
    }
    
    @objc func dismissVC() {
        performSegue(withIdentifier: "unwind1", sender: nil)
    }
}

extension ViewController: CustomCollectionLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return photos[indexPath.item].size.height
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath)
        cell.backgroundColor = UIColor(patternImage: photos[indexPath.item])
        cell.contentView.layer.borderColor = UIColor.red.cgColor
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.contentMode = .scaleAspectFit
        return cell
    }
}

