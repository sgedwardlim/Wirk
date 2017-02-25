//
//  JobRegistrationController.swift
//  wirk
//
//  Created by Edward on 2/15/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class JobRegistrationController: UIViewController {
    
    // This property is used to check which image was selected
    var imageType = ImageTypes.before
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        return button
    }()
    
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        return button
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let jobTypeField: UITextField = {
        let field = UITextField()
        field.placeholder = "Job Type"
        field.font = UIFont.systemFont(ofSize: 16)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let jobTypeDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let jobDescriptionField: UICustomTextView = {
        let field = UICustomTextView()
        field.delegate = field
        field.placeholder = "Job Description"
        field.font = UIFont.systemFont(ofSize: 16)
        field.backgroundColor = UIColor(colorType: .background)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let jobDescriptionDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var beforeImageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleBeforeImageSelected)))
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "beforeImage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var afterImageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAfterImageSelected)))
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "afterImage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var job: Job? {
        didSet{
            // if customer is nil, then is a new customer
            guard let job = job else { return }
            
            if let jobType = job.jobType { jobTypeField.text = jobType }
            if let jobDescription = job.jobDescription  { jobDescriptionField.text = jobDescription }
            
            if let beforeImageUrl = job.beforeImageUrl {
                beforeImageView.loadImagesUsingCache(urlString: beforeImageUrl)
            }
            if let afterImageUrl = job.afterImageUrl {
                afterImageView.loadImagesUsingCache(urlString: afterImageUrl)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        // Need so that view controller is not behind nav controller
        self.edgesForExtendedLayout = []
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        view.backgroundColor = UIColor.init(colorType: .background)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(jobTypeField)
        contentView.addSubview(jobTypeDividerLine)
        contentView.addSubview(jobDescriptionField)
        contentView.addSubview(jobDescriptionDividerLine)
        contentView.addSubview(beforeImageView)
        contentView.addSubview(afterImageView)
        
        // x, y, width and height constraints
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // x, y, width and height constraints
        contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        // x, y, width and height constraints
        jobTypeField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        jobTypeField.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        jobTypeField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        jobTypeField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // x, y, width and height constraints
        jobTypeDividerLine.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        jobTypeDividerLine.topAnchor.constraint(equalTo: jobTypeField.bottomAnchor).isActive = true
        jobTypeDividerLine.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        jobTypeDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        // x, y, width and height constraints
        jobDescriptionField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 14).isActive = true
        jobDescriptionField.topAnchor.constraint(equalTo: jobTypeDividerLine.bottomAnchor).isActive = true
        jobDescriptionField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        jobDescriptionField.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        // x, y, width and height constraints
        jobDescriptionDividerLine.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        jobDescriptionDividerLine.topAnchor.constraint(equalTo: jobDescriptionField.bottomAnchor).isActive = true
        jobDescriptionDividerLine.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        jobDescriptionDividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        // x, y, width and height constraints
        beforeImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        beforeImageView.topAnchor.constraint(equalTo: jobDescriptionDividerLine.bottomAnchor).isActive = true
        beforeImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        beforeImageView.heightAnchor.constraint(equalTo: beforeImageView.widthAnchor).isActive = true
        
        // x, y, width and height constraints
        afterImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        afterImageView.topAnchor.constraint(equalTo: beforeImageView.bottomAnchor).isActive = true
        afterImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        afterImageView.heightAnchor.constraint(equalTo: afterImageView.widthAnchor).isActive = true
        afterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
}
