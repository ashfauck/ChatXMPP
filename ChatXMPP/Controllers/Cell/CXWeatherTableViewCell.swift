//
//  CXWeatherTableViewCell.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 18/02/21.
//

import UIKit

class CXWeatherTableViewCell: UITableViewCell {

    @IBOutlet var baseView: UIView!
    @IBOutlet var cityName: UILabel!
    @IBOutlet var currentDegreeLbl: UILabel!
    @IBOutlet var highAndLowLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.baseView.dropShadow(show: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(weather: CXWeather)
    {
        self.cityName.text = weather.name
        self.currentDegreeLbl.text = "\(weather.main?.temp ?? 0)°c"
        self.highAndLowLbl.text = "H: \(weather.main?.tempMax ?? 0)°c - L: \(weather.main?.tempMin ?? 0)°c"
    }
    
    // MARK: - Height
    
    static var cellHeight:CGFloat
    {
        return 120.0
    }
    
}
