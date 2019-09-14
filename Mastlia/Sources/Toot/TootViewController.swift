//
//  TootViewController.swift
//  Mastlia
//
//  Created by ymgn on 2018/12/02.
//  Copyright © 2018 ymgn. All rights reserved.
//

import UIKit
import MastodonKit
import RealmSwift

class TootViewController: UIViewController {
    @IBOutlet weak var tootField: UITextView!
    
    var user: Account?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tootField.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTootTapped(_ sender: Any) {
        guard let tootContent = tootField.text else {
            return
        }
        
        if tootContent.count == 0 {
            return
        }
        
        guard let domain = user?.domain else {
            return
        }
        
        guard let accessToken = user?.accessToken else {
            return
        }
        
        let req = Statuses.create(status: tootContent)
        var client = Client(baseURL: "https://" + domain)
        client.accessToken = accessToken
    
        client.run(req) { result in
            if let _ = result.value {
                self.dismiss(animated: true, completion: nil)
            } else {
                let controller = UIAlertController(title: nil, message: "投稿に失敗しました", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                DispatchQueue.main.async {
                    self.present(controller, animated: true, completion: nil)
                }
                return
            }
        }
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
