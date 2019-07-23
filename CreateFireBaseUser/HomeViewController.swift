//
//  HomeViewController.swift
//  CreateFireBaseUser
//
//  Created by Calvin Cantin1 on 2019-07-21.
//  Copyright © 2019 Calvin. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    // MARK: - Properties
    
    var welcomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        return label
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUserAndConfigureView()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Selectors
    
    @objc func handleSignOut()
    {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil) 
    }
    
    // MARK: - API
    
    func loadUserData()
    {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value)   { (snapshot) in
            guard let username = snapshot.value as? String else { return }
            self.welcomeLabel.text = "Welcome, \(username)"
            
            UIView.animate(withDuration: 0.5, animations: {
                self.welcomeLabel.alpha = 1
            })
        }
    }
    
    func signOut()
    {
        do {
            try Auth.auth().signOut()
            let navController = UINavigationController(rootViewController: LoginViewController())
            navController.navigationBar.barStyle = .black
            self.present(navController, animated: true, completion: nil)
        }
        catch let error
        {
            print("Failed to sign out with error..", error.localizedDescription)
        }
    }
    
    func authenticateUserAndConfigureView()
    {
        if Auth.auth().currentUser == nil
        {
            DispatchQueue.main.async {
                let navController = UINavigationController(rootViewController: LoginViewController())
                navController.navigationBar.barStyle = .black
                self.present(navController, animated: true, completion: nil)
            }
        } else {
            configureViewComponents()
            loadUserData()
        }
    }
    
    //MARK: - Helper functions
    
    
        func configureViewComponents() {
            view.backgroundColor = UIColor.mainBlue()
            
            navigationItem.title = "Firebase Login"
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_white_24dp"), style: .plain, target: self, action: #selector(handleSignOut))
            navigationItem.leftBarButtonItem?.tintColor = .white
            navigationController?.navigationBar.barTintColor = UIColor.mainBlue()
            
            view.addSubview(welcomeLabel)
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
