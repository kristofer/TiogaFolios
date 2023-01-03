//
//  ShareSelectViewController.swift
//  ToArchive
//
//  Created by Kristofer Younger on 6/14/22.
//

import UIKit


protocol ShareSelectViewControllerDelegate: AnyObject {
    func selected(f: Folio)
}

class ShareSelectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var folios = [Folio]()
    weak var delegate: ShareSelectViewControllerDelegate?

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.FolioCell, for: indexPath)
        cell.textLabel?.text = folios[indexPath.row].title
        cell.backgroundColor = .clear
        return cell

    }
    //extension ShareSelectViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //print("TFdebug selected row \(indexPath.row) \(String(describing: folioTags[indexPath.row].title))")
            delegate?.selected(f: folios[indexPath.row])
        }
    //}
        
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.FolioCell)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = "Select Folio"
        view.addSubview(tableView)
    }

}

private extension ShareSelectViewController {
    struct Identifiers {
        static let FolioCell = "folioCell"
    }
}
