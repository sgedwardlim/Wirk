//
//  EmailPreviewViewController.swift
//  ReferalPlus
//
//  Created by Edward on 1/8/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class EmailPreviewViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: Properties
    var referalComposer: ReferalComposer!
    var HTMLContent: String!
    
    let webView: UIWebView = {
        let webview = UIWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    lazy var composeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleComposeTapped))
//        button.isEnabled = false
        return button
    }()
    
    var company_name: String!
    var default_email_subject: String!
    var default_email_description: String!
    var email_recipient: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        referalComposer = ReferalComposer()
        webView.loadHTMLString(HTMLContent,baseURL: URL(string: referalComposer.pathToReferalHTMLTemplate!)!)
        
        setupViews()
    }
    
    func setupViews() {
        navigationItem.rightBarButtonItem = composeButton
        
        view.addSubview(webView)
        
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
    func handleComposeTapped(_ sender: UIBarButtonItem) {
        // Create the alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let email = UIAlertAction(title: "Email", style: .default) { (action) in
            self.referalComposer.exportHTMLContentToPDF(printFormatter: self.webView.viewPrintFormatter())
            self.presentMailComposeView()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            print(action)
        }
        
        alertController.addAction(email)
        alertController.addAction(cancel)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        // this is the center of the screen currently but it can be any point in the view
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Helper functions

    func presentMailComposeView() {
        // show email prompt if selected
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            mail.setToRecipients([email_recipient])
            mail.setSubject(default_email_subject)
            mail.setMessageBody(HTMLContent, isHTML: true)
            self.present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


