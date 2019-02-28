//
//  WeekHour.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-02-21.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

protocol WeekHourDelegate: class {
    func switch24HoursChanged(sender: UISwitch)
    func switchClosedChanged(sender: UISwitch)
    func datePickerOpen(sender: UIDatePicker)
    func datePickerClose(sender: UIDatePicker)
    func btnSave(sender: UIBarButtonItem)
    func btnCancel(sender: UIBarButtonItem)
    
}
class WeekHour: UIView {
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lbWeek: UILabel!
    @IBOutlet weak var switchClosed: UISwitch!
    @IBOutlet weak var switch24Hours: UISwitch!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var datePickerOpen: UIDatePicker!
    @IBOutlet weak var datePickerClose: UIDatePicker!
    
    public weak var weekHourDelegate: WeekHourDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit(){
        
        Bundle.main.loadNibNamed("WeekHour", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
 
        initUI()
    }
    
    func initUI(){
        toolBar.setGradientBackground()
    }
    
    
    @IBAction func switch24HoursChanged(_ sender: UISwitch) {
        self.weekHourDelegate?.switch24HoursChanged(sender: sender)
    }
    @IBAction func switchClosedChanged(_ sender: UISwitch) {
        self.weekHourDelegate?.switchClosedChanged(sender: sender)
    }
    @IBAction func datePickerOpen(_ sender: UIDatePicker) {
        self.weekHourDelegate?.datePickerOpen(sender: sender)
    }
    @IBAction func datePickerClose(_ sender: UIDatePicker) {
        self.weekHourDelegate?.datePickerClose(sender: sender)
    }
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        self.weekHourDelegate?.btnSave(sender: sender)
    }
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        self.weekHourDelegate?.btnCancel(sender: sender)
    }
}
