//
//  PageViewController.swift
//  ChatXMPP
//
//  Created by ashfauck thaminsali on 17/02/21.
//

import UIKit

class PageViewController: UIPageViewController {

    // MARK: - Properties
    
    var selectedIndex:Int = 0
    var count = 2
    
    // MARK: - IBOutlets
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
     
        self.delegate = self
        self.dataSource = self
        
        self.setViewControllers([self.viewController(at: 0)], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
    }
    
    // MARK: - Set up

    func viewController(at index:Int) -> UIViewController
    {
        
        if index == 0 {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatListViewController") as? ChatListViewController
            {
                vc.pageId = index
                
                return vc
            }
        }else if index == 1
        {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as? WeatherViewController
            {
                vc.pageId = index
                
                return vc
            }
        }
        
        return UIViewController()
    }
    
    // MARK: - IBActions
    
    // MARK: - Actions
    
    // MARK: - Navigation
    
    // MARK: - Network Manager calls
    
}

// MARK: - Extensions


extension PageViewController : UIPageViewControllerDelegate,UIPageViewControllerDataSource
{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        guard completed else {
            return
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let index = viewController.pageId
        
        if index == 0
        {
            return self.viewController(at: 1)
        }
        
        return self.viewController(at: 0)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let index = viewController.pageId
                
        if index == 1
        {
            return self.viewController(at: 0)
        }
        
        return self.viewController(at: 1)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return self.selectedIndex
    }
}

