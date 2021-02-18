//
//  WeatherViewController.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 17/02/21.
//

import UIKit

class WeatherViewController: UIViewController {

    // MARK: - Properties
    
    let viewModel = CXWeatherViewModel()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setUpViewModel()
        self.setUpTableView()
        
        self.viewModel.getApi()
    }
    
    // MARK: - Set up
    
    func setUpTableView()
    {
        self.tableView.register(identifier: CXWeatherTableViewCell.identifier)
        self.tableView.tableFooterView = UIView()
    }
    
    func setUpViewModel()
    {
        
        self.viewModel.didUpdateLoading = { (_ success) in
            
            DispatchQueue.main.async {
                if success
                {
                    self.view.showLoadingHUD()
                }else
                {
                    self.view.hideLoadingHUD()
                }
            }
            
        }
        
        self.viewModel.alertMessage = { (_ message) in
            
            DispatchQueue.main.async {
                self.showAlert(withTitle: message, message: nil)
            }
        }
        
        self.viewModel.updateUI =
        {
            DispatchQueue.main.async
            {
                self.tableView.reloadData()
            }
        }
        
    }
    
    @objc func didTapSectionView(_ gesture: UITapGestureRecognizer)
    {
        if let view  = gesture.view
        {
            self.viewModel.weathers[view.tag].isSelected = !(self.viewModel.weathers[view.tag].isSelected ?? false)
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - IBActions
    
}

// MARK: - Extensions

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.viewModel.weathers[section].isSelected ?? false ? 1 : 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.viewModel.weathers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let view = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.tableView.frame.size.width, height: 44.0)))
        
        view.tag = section
        let label = UILabel(frame: CGRect(origin: CGPoint(x: 20.0, y: 0), size: view.frame.size))
        
        label.text = self.viewModel.weathers[section].name
        
        view.addTapGesture(tapNumber: 1, target: self, action: #selector(didTapSectionView(_:)))
        
        view.backgroundColor = .lightGray
        
        view.addSubview(label)
        return view
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
//    {
//        return self.viewModel.weathers[section].name
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CXWeatherTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(ofType: CXWeatherTableViewCell.self, for: indexPath)
        
        cell.updateUI(weather: self.viewModel.weathers[indexPath.section])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
