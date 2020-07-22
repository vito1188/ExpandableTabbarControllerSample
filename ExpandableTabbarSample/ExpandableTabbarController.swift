//
//  ExpandableTabbarController.swift
//  ExpandableTabbarSample
//
//  Copyright © 2020 VietTa. All rights reserved.
//

import UIKit

class ExpandableTabbarController: UITabBarController {
	
	enum Constant {
		static let dockViewHeight: CGFloat = 70
		static let barButtonHeight: CGFloat = 12
	}
	
	private var _dockViewBottomConstraint: NSLayoutConstraint?
	
	private var _isOpen = true {
		didSet {
			view.layoutIfNeeded()
			let height = (_isOpen ? 0 : Constant.dockViewHeight - Constant.barButtonHeight) - tabBar.frame.size.height
			UIView.animate(withDuration: 0.5) {
				self._dockViewBottomConstraint!.constant = height
				self.view.layoutIfNeeded()
			}
		}
	}
	
	private lazy var _button1: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Button 1", for: .normal)
		button.backgroundColor = UIColor.red
		button.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
		return button
	}()
	
	private lazy var _button2: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Button 2", for: .normal)
		button.backgroundColor = UIColor.blue
		button.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
		return button
	}()
	
	private lazy var _button3: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("Button 3", for: .normal)
		button.backgroundColor = UIColor.orange
		button.addTarget(self, action: #selector(onTapped), for: .touchUpInside)
		return button
	}()
	
	private lazy var _buttonStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		stackView.spacing = 16.0

		stackView.addArrangedSubview(_button1)
		stackView.addArrangedSubview(_button2)
		stackView.addArrangedSubview(_button3)
		return stackView
	}()
	
	private lazy var _stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.spacing = 4.0
		stackView.alignment = .fill
		stackView.distribution = .fill
		
		let barButton = UIButton()
		barButton.translatesAutoresizingMaskIntoConstraints = false
		barButton.backgroundColor = UIColor.white
		barButton.setImage(UIImage(named: "rectangle"), for: .normal)
		barButton.addTarget(self, action: #selector(closeOpenAction), for: .touchUpInside)
		
		let bottomSpace = UIView()
		bottomSpace.backgroundColor = .clear
		bottomSpace.translatesAutoresizingMaskIntoConstraints = false

		stackView.addArrangedSubview(barButton)
		stackView.addArrangedSubview(_buttonStackView)
		stackView.addArrangedSubview(bottomSpace)
		
		NSLayoutConstraint.activate([
			barButton.heightAnchor.constraint(equalToConstant: Constant.barButtonHeight),
			bottomSpace.heightAnchor.constraint(equalToConstant: Constant.barButtonHeight / 2),
		])
		return stackView
	}()
	
	private lazy var _dockView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .white
		view.clipsToBounds = true
		view.layer.cornerRadius = 8
		view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		
		view.addSubview(_stackView)
		NSLayoutConstraint.activate([
			_stackView.topAnchor.constraint(equalTo: view.topAnchor),
			_stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			_stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			_stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])
		return view
	}()
	
	override func loadView() {
		super.loadView()
		setupView()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tabBar.isTranslucent = false
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		print("ExpandableTabbarController viewDidLayoutSubviews: \(self.tabBar.isHidden)")
		if tabBar.isHidden == false {
			view.bringSubviewToFront(tabBar)
		}
		let height = (_isOpen ? 0 : Constant.dockViewHeight - Constant.barButtonHeight) - tabBar.frame.size.height
		_dockViewBottomConstraint!.constant = height
		_dockViewBottomConstraint?.isActive = !tabBar.isHidden
	}
	
	func hideDockView(_ shouldHide: Bool) {
		view.bringSubviewToFront(tabBar)
		_dockView.isHidden = shouldHide
	}
	
	private func setupView() {
		view.addSubview(_dockView)
		_dockViewBottomConstraint = _dockView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		
		// crash because tabBar is removed from view tree
		// _dockViewBottomConstraint = _dockView.bottomAnchor.constraint(equalTo: tabBar.topAnchor)
		
		NSLayoutConstraint.activate([
			_dockView.heightAnchor.constraint(equalToConstant: Constant.dockViewHeight),
			_dockView.leftAnchor.constraint(equalTo: view.leftAnchor),
			_dockView.rightAnchor.constraint(equalTo: view.rightAnchor),
			_dockViewBottomConstraint!
		])
	}
	
	@objc private func onTapped(_ sender: UIButton) {
		let vc = UIViewController()
		if sender == _button1 {
			vc.view.backgroundColor = .red
		} else if sender == _button2 {
			vc.view.backgroundColor = .blue
		} else if sender == _button3 {
			vc.view.backgroundColor = .orange
		}
		self.present(vc, animated: true, completion: nil)
	}

	@objc private func closeOpenAction(_ sender: Any) {
		_isOpen = !_isOpen
	}
}
