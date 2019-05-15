//
//  TermsViewController.swift
//  Phyx
//
//  Created by sonnaris on 8/22/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    
    var btnBack : UIBarButtonItem!
    @IBOutlet weak var termsView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }


    private func initialize() {
        
        self.title = "Terms of Service"
        termsView.text = "Phyx 1.0\nCopyright (c) 2018 Phyx Incorporated\n*** END USER LICENSE AGREEMENT ***\nIMPORTANT: PLEASE READ THIS LICENSE CAREFULLY BEFORE USING THIS SOFTWARE.\n1. LICENSE\nBy receiving, opening the file package, and/or using Phyx 1.0(\"Software\") containing this software, you agree that this End User User License Agreement(EULA) is a legally binding and valid contract and agree to be bound by it. You agree to abide by the intellectual property laws and all of the terms and conditions of this Agreement.\nUnless you have a different license agreement signed by Phyx Incorporated your use of Phyx 1.0 indicates your acceptance of this license agreement and warranty.\nSubject to the terms of this Agreement, Phyx Incorporated grants to you a limited, non-exclusive, non-transferable license, without right to sub-license, to use Phyx 1.0 in accordance with this Agreement and any other written agreement with Phyx Incorporated. Phyx Incorporated does not transfer the title of Phyx 1.0 to you; the license granted to you is not a sale. This agreement is a binding legal agreement between Phyx Incorporated and the purchasers or users of Phyx 1.0.\nIf you do not agree to be bound by this agreement, remove Phyx 1.0 from your computer now and, if applicable, promptly return to Phyx Incorporated by mail any copies of Phyx 1.0 and related documentation and packaging in your possession.\n2. DISTRIBUTION\nPhyx 1.0 and the license herein granted shall not be copied, shared, distributed, re-sold, offered for re-sale, transferred or sub-licensed in whole or in part except that you may make one copy for archive purposes only. For information about redistribution of Phyx 1.0 contact Phyx Incorporated.\n3. USER AGREEMENT\n3.1 Use\nYour license to use Phyx 1.0 is limited to the number of licenses purchased by you. You shall not allow others to use, copy or evaluate copies of Phyx 1.0.\n3.2 Use Restrictions\nYou shall use Phyx 1.0 in compliance with all applicable laws and not for any unlawful purpose. Without limiting the foregoing, use, display or distribution of Phyx 1.0 together with material that is pornographic, racist, vulgar, obscene, defamatory, libelous, abusive, promoting hatred, discriminating or displaying prejudice based on religion, ethnic heritage, race, sexual orientation or age is strictly prohibited.\nEach licensed copy of Phyx 1.0 may be used on one single computer location by one user. Use of Phyx 1.0 means that you have loaded, installed, or run Phyx 1.0 on a computer or similar device. If you install Phyx 1.0 onto a multi-user platform, server or network, each and every individual user of Phyx 1.0 must be licensed separately.\nYou may make one copy of Phyx 1.0 for backup purposes, providing you only have one copy installed on one computer being used by one person. Other users may not use your copy of Phyx 1.0 . The assignment, sublicense, networking, sale, or distribution of copies of Phyx 1.0 are strictly forbidden without the prior written consent of Phyx Incorporated. It is a violation of this agreement to assign, sell, share, loan, rent, lease, borrow, network or transfer the use of Phyx 1.0. If any person other than yourself uses Phyx 1.0 registered in your name, regardless of whether it is at the same time or different times, then this agreement is being violated and you are responsible for that violation!\n3.3 Copyright Restriction\nThis Software contains copyrighted material, trade secrets and other proprietary material. You shall not, and shall not attempt to, modify, reverse engineer, disassemble or decompile Phyx 1.0. Nor can you create any derivative works or other works that are based upon or derived from Phyx 1.0 in whole or in part.\nPhyx Incorporated's name, logo and graphics file that represents Phyx 1.0 shall not be used in any way to promote products developed with Phyx 1.0 . Phyx Incorporated retains sole and exclusive ownership of all right, title and interest in and to Phyx 1.0 and all Intellectual Property rights relating thereto.\nCopyright law and international copyright treaty provisions protect all parts of Phyx 1.0, products and services. No program, code, part, image, audio sample, or text may be copied or used in any way by the user except as intended within the bounds of the single user program. All rights not expressly granted hereunder are reserved for Phyx Incorporated.\n3.4 Limitation of Responsibility\nYou will indemnify, hold harmless, and defend Phyx Incorporated , its employees, agents and distributors against any and all claims, proceedings, demand and costs resulting from or in any way connected with your use of Phyx Incorporated's Software.\nIn no event (including, without limitation, in the event of negligence) will Phyx Incorporated , its employees, agents or distributors be liable for any consequential, incidental, indirect, special or punitive damages whatsoever (including, without limitation, damages for loss of profits, loss of use, business interruption, loss of information or data, or pecuniary loss), in connection with or arising out of or related to this Agreement, Phyx 1.0 or the use or inability to use Phyx 1.0 or the furnishing, performance or use of any other matters hereunder whether based upon contract, tort or any other theory including negligence.\nPhyx Incorporated's entire liability, without exception, is limited to the customers' reimbursement of the purchase price of the Software (maximum being the lesser of the amount paid by you and the suggested retail price as listed by Phyx Incorporated ) in exchange for the return of the product, all copies, registration papers and manuals, and all materials that constitute a transfer of license from the customer back to Phyx Incorporated.\n3.5 Warranties\nExcept as expressly stated in writing, Phyx Incorporated makes no representation or warranties in respect of this Software and expressly excludes all other warranties, expressed or implied, oral or written, including, without limitation, any implied warranties of merchantable quality or fitness for a particular purpose.\n3.6 Governing Law\nThis Agreement shall be governed by the law of the United States applicable therein. You hereby irrevocably attorn and submit to the non-exclusive jurisdiction of the courts of United States therefrom. If any provision shall be considered unlawful, void or otherwise unenforceable, then that provision shall be deemed severable from this License and not affect the validity and enforceability of any other provisions.\n3.7 Termination\nAny failure to comply with the terms and conditions of this Agreement will result in automatic and immediate termination of this license. Upon termination of this license granted herein for any reason, you agree to immediately cease use of Phyx 1.0 and destroy all copies of Phyx 1.0 supplied under this Agreement. The financial obligations incurred by you shall survive the expiration or termination of this license.\n4. DISCLAIMER OF WARRANTY\nTHIS SOFTWARE AND THE ACCOMPANYING FILES ARE SOLD \"AS IS\" AND WITHOUT WARRANTIES AS TO PERFORMANCE OR MERCHANTABILITY OR ANY OTHER WARRANTIES WHETHER EXPRESSED OR IMPLIED. THIS DISCLAIMER CONCERNS ALL FILES GENERATED AND EDITED BY Phyx 1.0 AS WELL.\n5. CONSENT OF USE OF DATA\nYou agree that Phyx Incorporated may collect and use information gathered in any manner as part of the product support services provided to you, if any, related to Phyx 1.0.Phyx Incorporated may also use this information to provide notices to you which may be of use or interest to you."
        btnBack = UIBarButtonItem(image: UIImage(named: "BackBlack"), style: .plain, target: self, action: #selector(self.clickedBack))
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func clickedBack() {
        
        self.navigationController?.dismiss(animated: true, completion: nil)
        
    }
}
