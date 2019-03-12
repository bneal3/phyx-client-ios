//
//  MarketplaceAllViewController.swift
//  Camp
//
//  Created by sonnaris on 8/24/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class MarketplaceAllViewController: UIViewController {
    
    var btnBack : UIBarButtonItem!
    var btnSearch: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    static let TYPE_CHAT = 0
    static let TYPE_MERCHANDIZE = 1
    
    var type: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        
    }
    
    private func initialize() {
        
        btnBack = UIBarButtonItem(image: UIImage(named: "BackBlack"), style: .plain, target: self, action: #selector(self.clickedBack))
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationItem.hidesBackButton = true
        
        btnSearch = UIBarButtonItem(image: UIImage(named: "Search"), style: .plain, target: self, action: #selector(self.clickedSearch))
        self.navigationItem.rightBarButtonItem = btnSearch
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let xib = UINib(nibName: "MarketplaceItem", bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: MarketplaceItem.identifier)
        
        collectionView.reloadData()
        
    }
    
    @objc func clickedBack() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func clickedSearch() {
        
        
    }

}

extension MarketplaceAllViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarketplaceItem.identifier, for: indexPath) as! MarketplaceItem
        
        if self.type == 0 {
            cell.configureCell(type: true)
        } else {
            cell.configureCell(type: false)
            //cell.imageView.kf.setImage(with: URL(string: "https://thumb.ibb.co/chkGLK/uber_rebrand_designcrowd_contest_dezeen_1568_13.jpg"))
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                return CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: UIScreen.main.bounds.height / 2 - 130)
            default:
                return CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: UIScreen.main.bounds.height / 2 - 80)
            }
        } else {
            return CGSize(width: UIScreen.main.bounds.width / 2 - 10, height: UIScreen.main.bounds.height / 2 - 80)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
