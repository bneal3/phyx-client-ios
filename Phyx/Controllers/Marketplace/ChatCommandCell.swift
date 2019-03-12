//
//  ChatCommandCell.swift
//  Camp
//
//  Created by sonnaris on 8/21/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class ChatCommandCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let identifier = "ChatCommandCell"

    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: ChatItemDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let xib = UINib(nibName: "ChatCommandItemCell", bundle: nil)
        collectionView.register(xib, forCellWithReuseIdentifier: ChatCommandItemCell.identifier)
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCommandItemCell.identifier, for: indexPath) as! ChatCommandItemCell
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if delegate != nil {
            
            delegate?.chatItemTapped(indexPath)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width * 2 / 3, height: collectionView.frame.size.height)
        
    }
    
}
