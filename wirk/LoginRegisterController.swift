//
//  ViewController.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class LoginRegisterController: UICollectionViewCell {
    
    // MARK: Properties
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let lrs = LoginRegisterSegments.self
        let sc = UISegmentedControl(items: [lrs.login.rawValue, lrs.register.rawValue])
        sc.tintColor = UIColor(colorType: .button)
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let inputsContainerView: InputsContainerView = {
        let icv = InputsContainerView()
        icv.backgroundColor = .white
        icv.layer.cornerRadius = 5
        icv.translatesAutoresizingMaskIntoConstraints = false
        return icv
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.init(colorType: .button)
        button.addTarget(self, action: #selector(handleLoginRegisterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var introductionController: IntroductionController?
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var user: User?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = UIColor(colorType: .background)
        
        addSubview(loginRegisterSegmentedControl)
        addSubview(inputsContainerView)
        addSubview(loginRegisterButton)
        
        // x, y, width and height constraints for the loginRegisterSegmentedControl
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // x, y, width and height constraints for the inputsContainerView
        inputsContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: widthAnchor, constant: -20).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 120)
        inputsContainerViewHeightAnchor?.isActive = true
        
        // x, y, width and height constraints for the loginRegisterButton
        loginRegisterButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

