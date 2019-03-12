//
//  OnboardViewController.swift
//  Camp
//
//  Created by sonnaris on 8/15/18.
//  Copyright © 2018 sonnaris. All rights reserved.
//

import UIKit
import DeviceKit

class OnboardViewController: UIViewController {
    
    
    @IBOutlet weak var prtView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var scrollView: UIScrollView!

    var slides = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        scrollView.delegate = self
        
        configurePageControl()
        prtView.bringSubviewToFront(pageControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    fileprivate func configurePageControl() {
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = slides.count
        pageControl.pageIndicatorTintColor = UIColor.init(red: 169.0/255, green: 169.0/255, blue: 169.0/255, alpha: 0.4)
        pageControl.currentPageIndicatorTintColor = UIColor.init(red: 246.0/255, green: 104.0/255, blue: 95.0/255, alpha: 1.0)
        
    }
    
    fileprivate func createSlides() -> [UIView] {
        
        let device = Device()

        var imageHeight = scrollView.frame.size.height
        
        let modelName = UIDevice.modelName
        
        if modelName == "iPhone 8 Plus" || modelName == "Simulator iPhone 8 Plus" {
            
            imageHeight = scrollView.frame.size.height * 0.55
        } else if modelName == "iPhone 6" || modelName == "Simulator iPhone 6" {
            imageHeight = scrollView.frame.size.height * 0.4
        } else if modelName == "iPhone X" || modelName == "Simulator iPhone X" {
            imageHeight = scrollView.frame.size.height * 0.48
        } else {
            imageHeight = scrollView.frame.size.height * 0.45
        }
        
        
        let slide1 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: scrollView.bounds.height))
        slide1.backgroundColor = UIColor.clear
    
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 70), height: Int(imageHeight)))
        imageView1.center.x = slide1.center.x
        imageView1.image = UIImage(named: "walkthrough-1")
        slide1.addSubview(imageView1)
        
        let textView1 = UILabel(frame: CGRect(x: 0, y: Int(imageHeight) + 40, width: Int(UIScreen.main.bounds.width - 120), height: 80))
        textView1.textColor = UIColor.black
        textView1.font = UIFont.init(name: "Avenir Book", size: 18.0)
        textView1.textAlignment = .center
        textView1.center.x = slide1.center.x
        textView1.numberOfLines = 2
        textView1.text = "Camp elevates your typical messaging experience"
        textView1.adjustsFontSizeToFitWidth = true
        slide1.addSubview(textView1)
        
        
        let slide2 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: scrollView.bounds.height))
        slide2.backgroundColor = UIColor.clear
        
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 70), height: Int(imageHeight)))
        imageView2.center.x = slide2.center.x
        imageView2.image = UIImage(named: "walkthrough-2")
        slide2.addSubview(imageView2)
        
        let textView2 = UILabel(frame: CGRect(x: 0, y: Int(imageHeight) + 40, width: Int(UIScreen.main.bounds.width - 120), height: 80))
        textView2.textColor = UIColor.black
        textView2.font = UIFont.init(name: "Avenir Book", size: 18.0)
        textView2.textAlignment = .center
        textView2.center.x = slide2.center.x
        textView2.numberOfLines = 2
        textView2.text = "Use Camp Coins to buy in-app features and retail items"
        textView2.adjustsFontSizeToFitWidth = true
        slide2.addSubview(textView2)
        
        let slide3 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: scrollView.bounds.height))
        slide3.backgroundColor = UIColor.clear
        
        let imageView3 = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 70), height: Int(imageHeight)))
        imageView3.center.x = slide3.center.x
        imageView3.image = UIImage(named: "walkthrough-3")
        slide3.addSubview(imageView3)
        
        let textView3 = UILabel(frame: CGRect(x: 0, y: Int(imageHeight) + 40, width: Int(UIScreen.main.bounds.width - 120), height: 80))
        textView3.textColor = UIColor.black
        textView3.font = UIFont.init(name: "Avenir Book", size: 18.0)
        textView3.textAlignment = .center
        textView3.center.x = slide3.center.x
        textView3.numberOfLines = 2
        textView3.text = "Apply Camp's signature Sparks to your messages to enhance each conversation"
        textView3.adjustsFontSizeToFitWidth = true
        slide3.addSubview(textView3)
        
        let slide4 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: scrollView.bounds.height))
        slide1.backgroundColor = UIColor.clear
        
        let imageView4 = UIImageView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width - 70), height: Int(imageHeight)))
        imageView4.center.x = slide4.center.x
        imageView4.image = UIImage(named: "walkthrough-4")
        slide4.addSubview(imageView4)
        
        let textView4 = UILabel(frame: CGRect(x: 0, y: Int(imageHeight) + 40, width: Int(UIScreen.main.bounds.width - 120), height: 80))
        textView4.textColor = UIColor.black
        textView4.font = UIFont.init(name: "Avenir Book", size: 18.0)
        textView4.textAlignment = .center
        textView4.center.x = slide4.center.x
        textView4.numberOfLines = 2
        textView4.text = "See your Messaging Statistics to better understand your messaging habits"
        textView4.adjustsFontSizeToFitWidth = true
        slide4.addSubview(textView4)
        
        let btn = UIButton(frame: CGRect(x: 0, y: Int(imageHeight) + 40 + 80 + 30, width: Int(UIScreen.main.bounds.width - 80), height: 75))
        btn.center.x = slide4.center.x
        btn.setBackgroundImage(UIImage(named: "GetStarted"), for: .normal)
        
        btn.addTarget(self, action: #selector(self.clickedGetStarted), for: .touchUpInside)
        slide4.addSubview(btn)
        
        return [slide1, slide3, slide4]
    }
    
    fileprivate func setupSlideScrollView(slides: [UIView]) {
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(slides.count), height: scrollView.frame.size.height - 150)
        scrollView.contentInset = .zero
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        for i in 0 ..< slides.count {
            
            slides[i].frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(i), y: 0, width: UIScreen.main.bounds.width, height: scrollView.frame.size.height)
            scrollView.addSubview(slides[i])
        }
    
    }
    
    @objc func clickedGetStarted() {
        
        let verifyVC = VerifyViewController(nibName: "VerifyViewController", bundle: nil)
        self.navigationController?.pushViewController(verifyVC, animated: true)
        
    }
    
    @IBAction func clickedBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension OnboardViewController : UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        if pageNumber == 3 {
            
            pageControl.isHidden = true
        } else {
            pageControl.isHidden = false
        }
        pageControl.currentPage = Int(pageNumber)
    }
}

extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}
