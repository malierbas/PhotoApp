//
//  OnboardingMainVC.swift
//  PhotoApp
//
//  Created by Ali on 21.11.2021.
//

import UIKit

class OnboardingMainVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    //MARK: - Properties
    //: Views
    lazy var orderedViewControllers: [UIViewController] = {
          return [self.newVc(viewController: "OnboardingFirstVC"),
                  self.newVc(viewController: "OnboardingSecondVC"),
                  self.newVc(viewController: "OnboardingThirdVC") ]
      }()
    
    
    //: Variables
     
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true, completion: nil)
        }
        
        self.delegate = self
     }
     
    //MARK: - Public Functions
    
    //MARK: PageVC Methods
     func newVc(viewController: String) -> UIViewController {
         return UIStoryboard(name: "Main" , bundle: nil).instantiateViewController(withIdentifier: viewController)
     }

     func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
         guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil
         }
         
         let previousIndex = viewControllerIndex - 1
         
         guard previousIndex >= 0 else {
             return orderedViewControllers.last
         }
         
         guard orderedViewControllers.count > previousIndex else {
             return nil
         }
         
         return orderedViewControllers[previousIndex]
     }
     
     func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
         guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil
         }
         
         let nextIndex = viewControllerIndex + 1
         
         guard orderedViewControllers.count != nextIndex else {
             return orderedViewControllers.first
         }
         
         guard orderedViewControllers.count > nextIndex else {
             return nil
         }
          
         if OnboardingThirdVC.isOnboardCompleted { 
             DispatchQueue.main.async {
                 self.nextPage()
             }
         }
         
         return orderedViewControllers[nextIndex]
     }
     
     
     func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
     }
    
     func nextPage() {
         guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return
         }
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "TabbarViewController")

         window.rootViewController = vc

         let options: UIView.AnimationOptions = .transitionCrossDissolve

         let duration: TimeInterval = 0.3

         UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:
         { completed in
             // maybe do something on completion here
         })
    }
    //MARK: - Actions
    
}
