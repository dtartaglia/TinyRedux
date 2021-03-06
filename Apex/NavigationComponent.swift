//
//  NavigationComponent.swift
//  Apex
//
//  Created by Daniel Tartaglia on 9/30/17.
//  Copyright © 2017 Daniel Tartaglia. MIT License
//

import UIKit


public final
class NavigationComponent<P: Publisher, ViewControllerID: Hashable> {

	init(navController: UINavigationController, publisher: P, lens: @escaping (P.State) -> [ViewControllerID], factory: @escaping (ViewControllerID, P.State) -> UIViewController) {
		self.navController = navController
		self.lens = lens
		createViewController = factory
		unobserver = publisher.observe(observer: { [weak self] state in
			self?.configure(with: state)
		})
	}

	private var unobserver: Unobserver?
	private var currentStack: [ViewControllerID] = []
	private let navController: UINavigationController
	private let lens: (P.State) -> [ViewControllerID]
	private let createViewController: (ViewControllerID, P.State) -> UIViewController

	private func configure(with state: P.State) {
		let newStack = lens(state)
		popPushExpress(current: self.currentStack, target: newStack, popTo: self.pop, push: self.push(state: state))
		self.currentStack = newStack
	}

	private func pop(index: Int, animated: Bool) {
		navController.popToViewController(navController.viewControllers[index], animated: animated)
	}

	private func push(state: P.State) -> (ViewControllerID, Bool) -> Void {
		return { [unowned self] vc, isLast in
			let controller = self.createViewController(vc, state)
			if self.navController.viewControllers.isEmpty {
				self.navController.viewControllers = [controller]
			}
			else {
				self.navController.pushViewController(controller, animated: isLast)
			}
		}
	}
}
