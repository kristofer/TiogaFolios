//
//  CustomShareViewController.swift
//  Archive It
//
//  Created by Kristofer Younger on 1/4/23.
//

import Foundation
import UIKit
import SwiftUI

class CustomShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1: Set the background and call the function to create the navigation bar
        self.view.backgroundColor = .systemGray6
        setupNavBar()
    }

    // 2: Set the title and the navigation items
    private func setupNavBar() {
        self.navigationItem.title = "Archive to a Folio"

        let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
        self.navigationItem.setLeftBarButton(itemCancel, animated: false)

        let itemDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        self.navigationItem.setRightBarButton(itemDone, animated: false)
    }

    // 3: Define the actions for the navigation items
    @objc private func cancelAction () {
        let error = NSError(domain: "co.tioga.TiogaFolios", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cancelled a Share attempt"])
        extensionContext?.cancelRequest(withError: error)
    }

    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    private lazy var textField: UITextField = {
            let textField = UITextField()
            textField.text = "some value"
            //textField.backgroundColor = .white
            textField.translatesAutoresizingMaskIntoConstraints = false

            return textField
        }()

        private func setupViews() {
            self.view.addSubview(textField)
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                textField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                textField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                textField.heightAnchor.constraint(equalToConstant: 44)
            ])
        }

}

//@objc(CustomShareNavigationController)
class CustomShareNavigationController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        // 2: set the ViewControllers
        self.setViewControllers([CustomShareViewController()], animated: false)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

