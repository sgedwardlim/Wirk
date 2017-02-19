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
//        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "beforeImage")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let afterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.image = UIImage(named: "afterImage")
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
        label.font = UIFont.systemFont(ofSize: 16)
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
        
        // x, y, width height constraints
        beforeImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        beforeImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        beforeImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        beforeImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // x, y, width height constraints
        afterImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        afterImageView.topAnchor.constraint(equalTo: beforeImageView.bottomAnchor).isActive = true
        afterImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        afterImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // x, y, width height constraints
        jobTypeLabel.leftAnchor.constraint(equalTo: beforeImageView.rightAnchor, constant: 8).isActive = true
        jobTypeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        jobTypeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        // x, y, width height constraints
        jobDescriptionLabel.leftAnchor.constraint(equalTo: beforeImageView.rightAnchor, constant: 10).isActive = true
        jobDescriptionLabel.topAnchor.constraint(equalTo: jobTypeLabel.bottomAnchor, constant: 8).isActive = true
        jobDescriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        
        // Remove the gap that the default seperatior line given
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsets.zero
        layoutMargins = UIEdgeInsets.zero
    }
}















