//
//  SwapRootViewController.swift
//  TransactionUIKit
//
//  Created by Paulo on 01/10/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import PlatformUIKit
import RIBs

public protocol SwapRootViewControllable: ViewControllable {
    func replaceRoot(viewController: ViewControllable?)
    func present(viewController: ViewControllable?)
    func push(viewController: ViewControllable?)
}

final class SwapRootViewController: UINavigationController, SwapRootViewControllable {

    weak var listener: SwapRootListener?

    func replaceRoot(viewController: ViewControllable?) {
        guard let viewController = viewController else {
            return
        }
        setViewControllers([viewController.uiviewController], animated: true)
    }

    func present(viewController: ViewControllable?) {
        guard let viewController = viewController else {
            return
        }
        present(viewController.uiviewController, animated: true, completion: nil)
    }

    func push(viewController: ViewControllable?) {
        guard let viewController = viewController else {
            return
        }
        switch presentedViewController {
        case nil:
            let nav = UINavigationController(rootViewController: viewController.uiviewController)
            present(nav, animated: true, completion: nil)
        case .some(let presentedViewController):
            if presentedViewController is UINavigationController {
                (presentedViewController as? UINavigationController)?
                    .pushViewController(viewController.uiviewController, animated: true)
            } else {
                presentedViewController.navigationController?
                    .pushViewController(viewController.uiviewController, animated: true)
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listener?.viewDidAppear()
    }
}
