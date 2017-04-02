//
//  EmailController.swift
//  wirk
//
//  Created by Edward on 3/26/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit
import MessageUI

class EmailController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    // MARK: Properties
    let emailSectionTitle: UILabel = {
        let label = UILabel()
        label.text = "Email Recipient"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailFieldContainer: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor(colorType: .background)
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    lazy var emailRecipientField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "user@example.com"
        textField.keyboardType = .emailAddress
        textField.backgroundColor = UIColor(colorType: .background)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailRecipientDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emailSubjectField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email subject"
        textField.backgroundColor = UIColor(colorType: .background)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let emailSubjectDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emailMessageField: UITextView = {
        let textField = UITextView()
        textField.placeholder = "Email description"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = UIColor(colorType: .background)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let jobsSectionTitle: UILabel = {
        let label = UILabel()
        label.text = "Jobs Selected"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor(colorType: .background)
        tv.dataSource = self
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var composeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleComposeTapped))
        button.isEnabled = false
        return button
    }()
    
    func handleComposeTapped(_ sender: UIBarButtonItem) {
        // Create the alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // Create a dismiss button
        let preview = UIAlertAction(title: "Preview", style: .default) { (action) in
            
            let view = EmailPreviewViewController()
            view.email_recipient = self.emailRecipientField.text
            view.HTMLContent = self.HTMLContent
            self.navigationController?.pushViewController(view, animated: true)
        }
        
        let email = UIAlertAction(title: "Email", style: .default) { (action) in
            self.referalComposer.exportHTMLContentToPDF(printFormatter: self.webView.viewPrintFormatter())
            self.presentMailComposeView()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
        }
        
        alertController.addAction(preview)
        alertController.addAction(email)
        alertController.addAction(cancel)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        // this is the center of the screen currently but it can be any point in the view
        present(alertController, animated: true, completion: nil)
    }
    
    let webView: UIWebView = {
        let webview = UIWebView()
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    fileprivate let jobCell = "jobCell"
    var referalComposer: ReferalComposer!
    var HTMLContent: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(netHex: 0xF0F0F0)
        
        navigationItem.title = "Email"
        navigationItem.rightBarButtonItem = composeButton
        
        tableView.register(JobCell.self, forCellReuseIdentifier: jobCell)
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SelectedJobs.shared.addCustomersToJobs {
            self.createReferalAsHTML()
        }
        
        // get the default user email subject and email description
        loadUserEmailPreferences()
        // clear the tabbar badges
        tabBarController?.tabBar.items?[2].badgeValue = nil
        tableView.reloadData()
    }
    
    func setupViews() {
        // Need so that view controller is not behind nav controller
        self.edgesForExtendedLayout = []
        
        view.addSubview(emailSectionTitle)
        view.addSubview(jobsSectionTitle)
        view.addSubview(tableView)
        
        emailSectionTitle.heightAnchor.constraint(equalToConstant: 26).isActive = true
        emailSectionTitle.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        emailSectionTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        emailSectionTitle.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        setupEmailFieldContainerView()
        
        jobsSectionTitle.heightAnchor.constraint(equalToConstant: 26).isActive = true
        jobsSectionTitle.topAnchor.constraint(equalTo: emailFieldContainer.bottomAnchor).isActive = true
        jobsSectionTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        jobsSectionTitle.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: jobsSectionTitle.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    private func setupEmailFieldContainerView() {
        // encapsulate the email message fields into the container view, used to create illusion of padded fields
        view.addSubview(emailFieldContainer)
        emailFieldContainer.addSubview(emailRecipientField)
        emailFieldContainer.addSubview(emailRecipientDividerLine)
        emailFieldContainer.addSubview(emailSubjectField)
        emailFieldContainer.addSubview(emailSubjectDividerLine)
        emailFieldContainer.addSubview(emailMessageField)
        
        emailFieldContainer.heightAnchor.constraint(equalToConstant: 40 + 40 + 0.5 + 0.5 + 100 + 0.5).isActive = true
        emailFieldContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        emailFieldContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailFieldContainer.topAnchor.constraint(equalTo: emailSectionTitle.bottomAnchor).isActive = true
        
        emailRecipientField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emailRecipientField.topAnchor.constraint(equalTo: emailFieldContainer.topAnchor).isActive = true
        emailRecipientField.leftAnchor.constraint(equalTo: emailFieldContainer.leftAnchor, constant: 8).isActive = true
        emailRecipientField.rightAnchor.constraint(equalTo: emailFieldContainer.rightAnchor).isActive = true
        
        emailRecipientDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        emailRecipientDividerLine.topAnchor.constraint(equalTo: emailRecipientField.bottomAnchor).isActive = true
        emailRecipientDividerLine.leftAnchor.constraint(equalTo: emailFieldContainer.leftAnchor, constant: 8).isActive = true
        emailRecipientDividerLine.rightAnchor.constraint(equalTo: emailFieldContainer.rightAnchor).isActive = true
        
        emailSubjectField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        emailSubjectField.topAnchor.constraint(equalTo: emailRecipientDividerLine.bottomAnchor).isActive = true
        emailSubjectField.leftAnchor.constraint(equalTo: emailFieldContainer.leftAnchor, constant: 8).isActive = true
        emailSubjectField.rightAnchor.constraint(equalTo: emailFieldContainer.rightAnchor).isActive = true
        
        emailSubjectDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        emailSubjectDividerLine.topAnchor.constraint(equalTo: emailSubjectField.bottomAnchor).isActive = true
        emailSubjectDividerLine.leftAnchor.constraint(equalTo: emailFieldContainer.leftAnchor, constant: 8).isActive = true
        emailSubjectDividerLine.rightAnchor.constraint(equalTo: emailFieldContainer.rightAnchor).isActive = true
        
        emailMessageField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        emailMessageField.topAnchor.constraint(equalTo: emailSubjectDividerLine.bottomAnchor).isActive = true
        emailMessageField.leftAnchor.constraint(equalTo: emailFieldContainer.leftAnchor, constant: 4).isActive = true
        emailMessageField.rightAnchor.constraint(equalTo: emailFieldContainer.rightAnchor).isActive = true
    }
    
    // MARK: TableView Datasoure
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectedJobs.shared.jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: jobCell, for: indexPath) as! JobCell
        cell.job = SelectedJobs.shared.jobs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            SelectedJobs.shared.jobs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // MARK: TableView Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 164
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedJob = SelectedJobs.shared.jobs[indexPath.row]
        let jobRegistrationView = JobRegistrationController()
        jobRegistrationView.job = selectedJob
        let nav = UINavigationController(rootViewController: jobRegistrationView)
        present(nav, animated: true, completion: nil)
    }
    
    private func loadUserEmailPreferences() {
        self.emailSubjectField.text = UserPreferences.getEmailSubject()
        self.emailMessageField.text = UserPreferences.getEmailMessage()
        self.emailMessageField.textViewDidChange(emailMessageField)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        composeButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        composeButton.isEnabled = false
        createReferalAsHTML()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        composeButton.isEnabled = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        composeButton.isEnabled = false
        createReferalAsHTML()
    }
    
    // MARK: Mail
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    // MARK: Helper Functions
    func createReferalAsHTML() {
        referalComposer = ReferalComposer()
        
        let jobs = SelectedJobs.shared.jobs
        let company_name = UserPreferences.getCompanyName()
        if let referalHTML = self.referalComposer.renderReferal(company_name: company_name!,
                                                                default_email_description: emailMessageField.text,
                                                                jobs: jobs)
        {
            self.webView.loadHTMLString(referalHTML, baseURL: URL(string: self.referalComposer.pathToReferalHTMLTemplate!)!)
            self.HTMLContent = referalHTML
            // keep the compose button disabled unless HTML is loaded
            composeButton.isEnabled = true
        }
    }
    
    func presentMailComposeView() {
        // show email prompt if selected
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            mail.setToRecipients([emailRecipientField.text!])
            mail.setSubject(emailSubjectField.text!)
            mail.setMessageBody(HTMLContent, isHTML: true)
            self.present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
}
