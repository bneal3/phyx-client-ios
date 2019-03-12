//
//  MerchandizeCell.swift
//  Camp
//
//  Created by sonnaris on 8/21/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class MerchandizeCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "MerchandizeCell"

    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: MerchandizeItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let xib = UINib(nibName: "MerchandizeItemCell", bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: MerchandizeItemCell.identifier)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MerchandizeItemCell.identifier, for: indexPath) as! MerchandizeItemCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if delegate != nil {
            
            delegate?.merchandizeItemTapped(indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 2 / 3 + 20, height: collectionView.frame.size.height)
    }
    
}
