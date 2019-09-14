//
//  LoginViewController.swift
//  Mastlia
//
//  Created by ymgn on 2018/11/23.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit
import MastodonKit
import RealmSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var domain: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var pass: UITextField!
    var responseJson = Dictionary<String, AnyObject>()
    var user: Account = Account()
    
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        if domain.text == nil || mail == nil || pass == nil {
            let controller = UIAlertController(title: nil, message: "正しく入力してください", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(controller, animated: true, completion: nil)
        }
        
        
        let client = Client(baseURL: "https://" + domain.text!)
        
        let request = Clients.register(clientName: "Mastlia", scopes: [.read, .write, .follow], website: "https://github.com/MastodonKit/MastodonKit")
        client.run(request) { result in
            guard let application = result.value else {
                let controller = UIAlertController(title: nil, message: "入力された内容が正しくありませんでした", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
                return
            }
            let loginRequest = Login.silent(clientID: application.clientID, clientSecret: application.clientSecret, scopes: [.read, .write], username: self.mail.text!, password: self.pass.text!)
            client.run(loginRequest) { result in
                if let loginSettings = result.value {
                    DispatchQueue.main.async {
                        self.user.domain = self.domain.text!
                        self.user.mail = self.mail.text!
                        self.user.pass = self.pass.text!
                        self.user.accessToken = loginSettings.accessToken
                        self.save(user: self.user)
                    }
                }
            }
        }
    }
    func save(user: Account) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(user)
            }
        } catch {
            let controller = UIAlertController(title: nil, message: "エラーが発生しました", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
