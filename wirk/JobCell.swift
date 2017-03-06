//
//  JobCell.swift
//  wirk
//
//  Created by Edward on 2/14/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class JobCell: UITableViewCell {
    
    var job: Job? {
        didSet {
            guard let job = job else { return }
            
            jobTypeLabel.text = job.jobType
            jobDescriptionLabel.text = job.jobDescription
            
            if let beforeImageUrl = job.beforeImageUrl {
                beforeImageView.loadImagesUsingCache(urlString: beforeImageUrl)
            }
            if let afterImageUrl = job.afterImageUrl {
                afterImageView.loadImagesUsingCache(urlString: afterImageUrl)
            }
        }
    }
    
    let beforeImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "beforeImage")
        iv.layer.cornerRadius = 5
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let afterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "afterImage")
        iv.layer.cornerRadius = 5
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let jobTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Job Type Label"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let jobDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "A very long Job Description that wraps almost three lines worth of space for an avergae phone size"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // This property will be set by a cell
    var jobLocationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // This property will be set by a cell
    var distFromLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor(colorType: .background)
        
        addSubview(beforeImageView)
        addSubview(afterImageView)
        addSubview(jobTypeLabel)
        addSubview(jobDescriptionLabel)
        addSubview(jobLocationLabel)
        addSubview(distFromLabel)
        
        // x, y, width height constraints
        beforeImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        beforeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        beforeImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        beforeImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        // x, y, width height constraints
        afterImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        afterImageView.topAnchor.constraint(equalTo: beforeImageView.bottomAnchor, constant: 8).isActive = true
        afterImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        afterImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        // x, y, width height constraints
        jobTypeLabel.leftAnchor.constraint(equalTo: beforeImageView.rightAnchor, constant: 8).isActive = true
        jobTypeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        jobTypeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        // x, y constraints
        distFromLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        distFromLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        
        // x, y, width constraints
        jobLocationLabel.leftAnchor.constraint(equalTo: beforeImageView.rightAnchor, constant: 8).isActive = true
        jobLocationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        jobLocationLabel.topAnchor.constraint(equalTo: jobTypeLabel.bottomAnchor, constant: 4).isActive = true
        
        // x, y, width height constraints
        jobDescriptionLabel.leftAnchor.constraint(equalTo: beforeImageView.rightAnchor, constant: 10).isActive = true
        jobDescriptionLabel.topAnchor.constraint(equalTo: jobLocationLabel.bottomAnchor, constant: 4).isActive = true
        jobDescriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        // Remove the gap that the default seperatior line given
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
}















