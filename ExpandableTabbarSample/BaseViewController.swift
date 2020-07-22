//
//  BaseViewController.swift
//  ExpandableTabbarSample
//
//  Copyright © 2020 VietTa. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override open func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		print("\(self) - viewWillAppear")
		guard let controller  = self.tabBarController as? ExpandableTabbarController else {
			return
		}
		if hidesBottomBarWhenPushed {
			controller.hideDockView(hidesBottomBarWhenPushed)
		}
	}

	override open func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		print("\(self) - viewDidAppear")
		guard let controller  = self.tabBarController as? ExpandableTabbarController else {
			return
		}
		if hidesBottomBarWhenPushed == false {
			controller.hideDockView(hidesBottomBarWhenPushed)
		}
	}
	
}
