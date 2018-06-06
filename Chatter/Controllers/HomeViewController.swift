//
//  HomeViewController.swift
//  Chatter
//
//  Created by Satish on 04/06/18.
//  Copyright © 2018 Satish Babariya. All rights reserved.
//

import Async
import Dwifft
import FirebaseAuth
import FirebaseFirestore
import FirebaseFunctions
import Foundation
import Kingfisher
import Material
import PKHUD
import RxFirebase
import RxSwift
import UIKit

class HomeViewController: UIViewController {
    
    fileprivate var tableView: TableView!
    fileprivate var tableViewDifft: SingleSectionTableViewDiffCalculator<UserProfile>?
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Conversations"
        view.backgroundColor = .white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .always
        }
        
        // Update User Profile in Firestore
        Auth.auth().currentUser?.set()
        
        tableView = TableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tableViewDifft = SingleSectionTableViewDiffCalculator(tableView: tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11, *) {
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0).isActive = true
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        observeConversationsList()
        
    }
    
    fileprivate func observeConversationsList() {
        guard let currentUser: User = Auth.auth().currentUser else {
            return
        }
        ChatRefrences.conversationsList(currentUser.uid).observe(.value) { [weak self] snapshot in
            if self == nil {
                return
            }
            var users: [UserProfile] = []
            if snapshot.exists(), let value: [String: Any] = snapshot.value as? [String: Any] {
                value.keys.forEach({ item in
                    Firestore.firestore().collection("users").document(item).getDocument { [weak self] snapshot, _ in
                        if self == nil { return }
                        if let snapshot = snapshot, snapshot.exists, let item = snapshot.data(), let uid: String = item["uid"] as? String {
                            var profile: UserProfile = UserProfile(displayName: nil, email: nil, phoneNumber: nil, photoURL: nil, uid: uid)
                            if let displayName: String = item["displayName"] as? String {
                                profile.displayName = displayName
                            }
                            
                            if let email: String = item["email"] as? String {
                                profile.email = email
                            }
                            
                            if let phoneNumber: String = item["phoneNumber"] as? String {
                                profile.phoneNumber = phoneNumber
                            }
                            
                            if let photoURL: String = item["photoURL"] as? String {
                                profile.photoURL = photoURL
                            }
                            users.append(profile)
                            self?.tableViewDifft?.rows = users
                        }
                    }
                })
                
            }
            
        }
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        HUD.show(HUDContentType.progress)
        ChatClient(Recipient: tableViewDifft!.rows[indexPath.row].uid)?.getReference().subscribe({ [weak self] event in
            if self == nil {
                return
            }
            
            switch event {
            case .next(let ref):
                self!.present(UINavigationController(rootViewController: ConversationViewController(Refrence: ref, Receipent: self!.tableViewDifft!.rows[indexPath.row].uid)), animated: true)
            case .error(let error):
                print(error.localizedDescription)
                HUD.flash(.error)
            case .completed:
                HUD.hide()
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: Extention of UITableView Delegate Methods
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDifft?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell = TableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.depthPreset = .depth1
        if let photoURL = tableViewDifft?.rows[indexPath.row].photoURL, let imageURL = URL(string: photoURL) {
            cell.imageView?.kf.indicatorType = .activity
            cell.imageView?.kf.setImage(with: imageURL, placeholder: #imageLiteral(resourceName: "picture(1)"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "picture(1)")
        }
        
        if let displayName = tableViewDifft?.rows[indexPath.row].displayName {
            cell.textLabel?.text = displayName
        } else {
            cell.textLabel?.text = tableViewDifft?.rows[indexPath.row].uid
        }
        
        if let email = tableViewDifft?.rows[indexPath.row].email {
            cell.detailTextLabel?.text = email
        }
        
        cell.imageView?.borderWidthPreset = .border4
        cell.imageView?.borderColor = .red
        
        ChatRefrences.presence.child(tableViewDifft!.rows[indexPath.row].uid).observe(.value) { snapshot in
            if snapshot.exists(), let value: [String: Any] = snapshot.value as? [String: Any], let connections: Bool = value["connections"] as? Bool, connections {
                cell.imageView?.borderColor = .green
            } else {
                cell.imageView?.borderColor = .red
            }
        }
        
        return cell
    }
}
