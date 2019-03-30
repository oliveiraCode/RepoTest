//
//  PageViewController.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-01.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    var pageControl = UIPageControl()
    
    // MARK: UIPageViewControllerDataSource
    
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "ViewController1"),
                self.newVc(viewController: "ViewController2"),
                self.newVc(viewController: "ViewController3")]
    }()
    
    lazy var button: UIButton = {
        var btn: UIButton!
        btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.maxX - 150,y: UIScreen.main.bounds.maxY - 90,width: 130,height: 50))
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 10
        btn.setTitle("Próximo", for: .normal)
        btn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        
        // Set up the first view that will show up on page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        configurePageControl()
        
        self.view.addSubview(button)
        
        
    }
    
    func configurePageControl() {
        // The total number of pages that are available
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    @objc func buttonPressed(){
        
        self.pageControl.currentPage += 1
        self.setViewControllers([orderedViewControllers[self.pageControl.currentPage]],
                                direction: .forward,
                                animated: true,
                                completion: nil)
        
        if button.titleLabel?.text == "Bem-vindo!" {
            
            let viewPageController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC")
            self.present(viewPageController, animated: true, completion: nil)
 
        }
        
        self.changeButtonValue()
    }
    
    
    func changeButtonValue(){
        if self.pageControl.currentPage == 2 {
            self.button.setTitle("Bem-vindo!", for: .normal)
        } else {
            self.button.setTitle("Próximo", for: .normal)
        }
    }
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    // MARK: Delegate methods
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
        
        self.changeButtonValue()
    }
    
    // MARK: DataSource functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    
}
