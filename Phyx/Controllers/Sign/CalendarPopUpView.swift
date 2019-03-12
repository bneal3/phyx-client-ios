//
//  CalendarPopUpView.swift
//  VACalendarExample
//
//  Created by Noda Hikaru on 19.08.18.
//

import UIKit
// import VACalendar

class CalendarPopUpView: UIView {
    
//    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
//        didSet {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy LLLL"
//            let appereance = VAMonthHeaderViewAppearance(
//                monthFont: UIFont.systemFont(ofSize: 16),
//                monthTextWidth: 200,
//                previousButtonImage: UIImage(named: "Previous")!,
//                nextButtonImage: UIImage(named: "Next")!,
//                dateFormatter: formatter
//            )
//            
//            monthHeaderView.delegate = self
//            monthHeaderView.appearance = appereance
//            let path = UIBezierPath(rect: monthHeaderView.bounds)
//            let border = CAShapeLayer()
//            border.path = path.cgPath
//            border.lineWidth = 0.5
//            border.fillColor = UIColor.clear.cgColor
//            monthHeaderView.layer.addSublayer(border)
            
//        }
//    }
    
//    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
//        didSet {
//            let appereance = VAWeekDaysViewAppearance(
//                symbolsType: .short,
//                weekDayTextFont: UIFont.systemFont(ofSize: 13),
//                leftInset: 0,
//                rightInset: 0,
//                calendar: defaultCalendar
//            )
//
//            weekDaysView.appearance = appereance
//            weekDaysView.layer.borderWidth = 0.5
//            weekDaysView.layer.borderColor = UIColor.lightGray.cgColor
//
//        }
//    }
    
//    let defaultCalendar: Calendar = {
//        var calendar = Calendar.current
//        calendar.firstWeekday = 1
//        calendar.timeZone = TimeZone.current
//        return calendar
//    }()
    
    let birthdayPicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.date
        
        let gregorian = NSCalendar(calendarIdentifier: .gregorian)
        
        let components = NSDateComponents()
        components.year = -13
        let maxDate = gregorian?.date(byAdding: components as DateComponents, to: Date(), options: NSCalendar.Options(rawValue: 0))
        dp.maximumDate = maxDate

        let placeholder = NSDateComponents()
        placeholder.year = -14
        let placeholderDate = gregorian?.date(byAdding: placeholder as DateComponents, to: Date(), options: NSCalendar.Options(rawValue: 0))
        dp.date = placeholderDate!
        return dp
    }()
    
    let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 20)
        button.tintColor = .white
        button.backgroundColor = .phyx
        button.layer.cornerRadius = 5
        button.setTitle("Confirm", for: .normal)
        return button
    }()
    
    @objc var didSelectDay: (() -> Void)?
    
    // private var calendarView: VACalendarView!
    private var view: UIView!
    
    // MARK: Life cycle.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonSetup()
    }
    
    // MARK: - Private methods.
    
    private func commonSetup() {
        
        setupXib()
//        let calendar = VACalendar(calendar: defaultCalendar)
//        calendarView = VACalendarView(frame: CGRect(
//            x: 0, y: weekDaysView.frame.maxY,
//            width: view.frame.width,
//            height: view.frame.height - weekDaysView.frame.maxY
//        ), calendar: calendar)
//        calendarView.backgroundColor = .clear
//        view.backgroundColor = .clear
//        calendarView.showDaysOut = true
//        calendarView.selectionStyle = .single
//        calendarView.monthDelegate = monthHeaderView
//        calendarView.dayViewAppearanceDelegate = self
//        calendarView.calendarDelegate = self
//        calendarView.scrollDirection = .horizontal
//        calendarView.setup()
//        view.addSubview(calendarView)
        
        view.addSubview(birthdayPicker)
        birthdayPicker.anchor(top: view.safeTopAnchor(), left: view.safeLeftAnchor(), bottom: nil, right: view.safeRightAnchor(), paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.width * (3 / 4))
        view.addSubview(selectButton)
        selectButton.anchor(top: birthdayPicker.safeBottomAnchor(), left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 250, height: 32)
        selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    private func setupXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
}

//extension CalendarPopUpView: VAMonthHeaderViewDelegate {
//    
//    func didTapNextMonth() {
//        // calendarView.nextMonth()
//    }
//    
//    func didTapPreviousMonth() {
//        // calendarView.previousMonth()
//    }
//    
//}

//extension CalendarPopUpView: VADayViewAppearanceDelegate {
//
//    func font(for state: VADayState) -> UIFont {
//        return UIFont.systemFont(ofSize: 15)
//    }
//
//    func textColor(for state: VADayState) -> UIColor {
//        switch state {
//        case .out:
//            return UIColor(red: 214 / 255, green: 214 / 255, blue: 219 / 255, alpha: 1.0)
//        case .selected:
//            return UIColor(red: 55 / 255, green: 167 / 255, blue: 248 / 255, alpha: 1.0)
//        case .unavailable:
//            return .lightGray
//        default:
//            return .black
//        }
//    }
//
//    func backgroundColor(for state: VADayState) -> UIColor {
//        switch state {
//        case .out:
//            return UIColor(red: 249 / 255, green: 250 / 255, blue: 250 / 255, alpha: 1.0)
//        default:
//            return .white
//        }
//    }
//
//    func shape() -> VADayShape {
//        return .square
//    }
//
//    func borderWidth(for state: VADayState) -> CGFloat {
//        switch state {
//        case .selected:
//            return 2
//        default:
//            return 1 / UIScreen.main.scale
//        }
//    }
//
//    func borderColor(for state: VADayState) -> UIColor {
//        switch state {
//        case .selected:
//            return UIColor(red: 55 / 255, green: 167 / 255, blue: 248 / 255, alpha: 1.0)
//        default:
//            return UIColor(red: 221 / 255, green: 221 / 255, blue: 221 / 255, alpha: 1.0)
//        }
//    }
//
//}
//
//extension CalendarPopUpView: VACalendarViewDelegate {
//
//    func selectedDate(_ date: Date) {
//        didSelectDay?()
//    }
//
//}
