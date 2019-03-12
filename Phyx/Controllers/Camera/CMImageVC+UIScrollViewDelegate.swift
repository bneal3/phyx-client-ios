//
//  CMImageVC+UIScrollViewDelegate.swift
//  camp
//
//  Created by Kevin Hall on 5/11/18.
//  Copyright © 2018 Benjamin Neal. All rights reserved.
//

import UIKit

extension CMImageVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return previewImageView
    }
}
