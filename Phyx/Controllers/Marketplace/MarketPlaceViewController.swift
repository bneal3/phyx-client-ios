//
//  MarketPlaceViewController.swift
//  Camp
//
//  Created by sonnaris on 8/16/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class MarketPlaceViewController: UIViewController, ChatItemDelegate, MerchandizeItemDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var btnSearch: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    private func initialize() {

        btnSearch = UIBarButtonItem(image: UIImage(named: "Search"), style: .plain, target: self, action: #selector(self.clickedSearch))
        self.navigationItem.rightBarButtonItem = btnSearch
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let xib1 = UINib(nibName: "ChatCommandCell", bundle: nil)
        let xib2 = UINib(nibName: "MerchandizeCell", bundle: nil)
        self.tableView.register(xib1, forCellReuseIdentifier: ChatCommandCell.identifier)
        self.tableView.register(xib2, forCellReuseIdentifier: MerchandizeCell.identifier)
        
    }
    
    @objc func clickedSearch() {
        
    }
    
    @objc func clickedAll(_ button: UIButton) {
        
        let tag = button.tag
        let marketplaceAllVC = MarketplaceAllViewController(nibName: "MarketplaceAllViewController", bundle: nil)
        
        marketplaceAllVC.type = tag
        if tag == 0 {
            marketplaceAllVC.title = "Chat Commands"
        } else {
            marketplaceAllVC.title = "Merchandize"
        }
        self.navigationController?.pushViewController(marketplaceAllVC, animated: true)
    }
    
    func chatItemTapped(_ indexPath: IndexPath) {
        
        let purchaseVC = PurchaseViewController(nibName: "PurchaseViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: purchaseVC)
        self.navigationController?.tabBarController?.present(nav, animated: true, completion: nil)
        
    }
    
    func merchandizeItemTapped(_ indexPath: IndexPath) {
        
        let purchaseVC = PurchaseViewController(nibName: "PurchaseViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: purchaseVC)
        self.navigationController?.tabBarController?.present(nav, animated: true, completion: nil)
        
    }
}

extension MarketPlaceViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            return 400.0
        } else {
            return 420.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ChatCommandCell.identifier, for: indexPath) as! ChatCommandCell
            cell.btnAll.tag = 0
            cell.btnAll.addTarget(self, action: #selector(self.clickedAll(_ :)), for: .touchUpInside)
            cell.selectionStyle = .none
            
            cell.delegate = self
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: MerchandizeCell.identifier, for: indexPath) as! MerchandizeCell
            cell.btnAll.tag = 1
            cell.btnAll.addTarget(self, action: #selector(self.clickedAll(_ :)), for: .touchUpInside)
            cell.selectionStyle = .none
            
            cell.delegate = self
            
            return cell
            
        }
    }
}
