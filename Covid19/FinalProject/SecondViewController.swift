//
//  SecondViewController.swift
//  FinalProject
//
//  Created by Student on 2020-04-22.
//  Copyright © 2020 Student. All rights reserved.
//

import UIKit
import MessageUI

class SecondViewController: UIViewController, MFMailComposeViewControllerDelegate{

    
    @IBAction func BtnSendMail(_ sender: UIButton) {
        
        let mailCompese = MFMailComposeViewController()
            mailCompese.mailComposeDelegate = self
            mailCompese.setToRecipients(["abc.hospital@gmail.com"])
            mailCompese.setSubject("Immediately Help")
            mailCompese.setMessageBody("I have Covid symptoms. What can I do now?" , isHTML: false)
            
            if MFMailComposeViewController.canSendMail()
            {
                self.present(mailCompese, animated: true, completion: nil)
            }
            else
            {
                print("Error")
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
