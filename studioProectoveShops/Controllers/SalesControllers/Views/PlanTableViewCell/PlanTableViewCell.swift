//
//  PlanTableViewCell.swift
//  studioProectoveShops
//
//  Created by Konstantyn Byhkalo on 2/2/17.
//  Copyright © 2017 Dmitriy Gaponenko. All rights reserved.
//

import UIKit

class PlanTableViewCell: UITableViewCell {

    @IBOutlet var identifiesLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var totalSumLabel: UILabel!
    @IBOutlet var ordersCountLabel: UILabel!
    @IBOutlet var shopsCountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillByModel(dayPlanModel: DayPlanModel) {
        self.identifiesLabel.text = dayPlanModel.identifier
        self.dateLabel.text = Converter.prettySringFromDate(dayPlanModel.date)
        self.totalSumLabel.text = "\(dayPlanModel.totalSum)"
        self.ordersCountLabel.text = "\(dayPlanModel.ordersList?.count ?? 0)"
        self.shopsCountLabel.text = "\(dayPlanModel.shopsList?.count ?? 0)"
    }

}
