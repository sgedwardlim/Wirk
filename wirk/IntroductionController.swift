//
//  IntroductionController.swift
//  wirk
//
//  Created by Edward on 3/14/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit

class IntroductionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    fileprivate let cellId = "cellId"
    fileprivate let loginRegisterCellId = "loginRegisterCellId"
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    var introductionPages: [IntroductionPage] = {
        
        let firstPage = IntroductionPage(imageName: "beforeImage", title: "First Page Title", description: "Introduction descrption for page 1 Introduction descrption for page 1")
        let secondPage = IntroductionPage(imageName: "beforeImage", title: "Second Page Title", description: "Introduction descrption for page 2")

        let thirdPage = IntroductionPage(imageName: "beforeImage", title: "Third Page Title", description: "Introduction descrption for page 3")

        return [firstPage, secondPage, thirdPage]
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(colorType: .button), for: .normal)
        button.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func handleSkip() {
        pageControl.currentPage = introductionPages.count - 1
        handleNext()
    }
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(colorType: .button), for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func handleNext() {
        // we are on the last page
        if pageControl.currentPage == introductionPages.count {
            return
        }
        
        // we are on second to last page
        if pageControl.currentPage == introductionPages.count - 1 {
            moveControlConstraintsOffScreen()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage = indexPath.item
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = UIColor(colorType: .button)
        pc.numberOfPages = self.introductionPages.count + 1
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(IntroductionCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LoginRegisterController.self, forCellWithReuseIdentifier: loginRegisterCellId)
        setupViews()
        observeKeyboardNotifications()
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // Create reference to bottom anchor
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControlBottomAnchor = pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        pageControlBottomAnchor?.isActive = true
        
        // Create reference to top anchor
        skipButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        skipButtonTopAnchor = skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        skipButtonTopAnchor?.isActive = true
        
        // Create reference to top anchor
        nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        nextButtonTopAnchor = nextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        nextButtonTopAnchor?.isActive = true
    }
    
    // MARK: CollectionView Data Source Functions
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return introductionPages.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == introductionPages.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loginRegisterCellId, for: indexPath) as! LoginRegisterController
            cell.introductionController = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! IntroductionCell
        
        let page = introductionPages[indexPath.item]
        cell.introductionPage = page
        
        return cell
    }
    
    // MARK: CollectionView Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        // scroll to item after rotation is complete
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    // MARK: PageControl Handle Selection
    fileprivate func observeKeyboardNotifications() {
        // notify the selector method everytime keyboard shows
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            self.view.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        if pageNumber == introductionPages.count {
            moveControlConstraintsOffScreen()
        } else {
            pageControlBottomAnchor?.constant = 0
            skipButtonTopAnchor?.constant = 16
            nextButtonTopAnchor?.constant = 16
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func moveControlConstraintsOffScreen() {
        pageControlBottomAnchor?.constant = pageControl.frame.height
        skipButtonTopAnchor?.constant = -16 - skipButton.frame.height
        nextButtonTopAnchor?.constant = -16 - nextButton.frame.height
    }
}

class IntroductionCell: UICollectionViewCell {
    
    // MARK: Properties
    var introductionPage: IntroductionPage? {

        didSet {
            guard let page = introductionPage else { return }
            introImage.image = UIImage(named: page.imageName)
            
            // setup text description for page using attribuited text
            // Customize the message to display
            let title = page.title
            let color = UIColor(white: 0.2, alpha: 1)
            let attributedText = NSMutableAttributedString(string: title, attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium),
                NSForegroundColorAttributeName: color])
            
            // append message to text with different attribuites
            let description = page.description
            attributedText.append(NSAttributedString(string: "\n\n\(description)", attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 15),
                NSForegroundColorAttributeName: color]))
            
            // Center our text
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let length = attributedText.string.characters.count
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: length))
            
            descriptionText.attributedText = attributedText
        }
    }
    
    var introImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "beforeImage")
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var descriptionText: UITextView = {
        let tv = UITextView()
        tv.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(introImage)
        addSubview(dividerLine)
        addSubview(descriptionText)
        
        introImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        introImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        introImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        introImage.bottomAnchor.constraint(equalTo: dividerLine.topAnchor).isActive = true
        
        dividerLine.topAnchor.constraint(equalTo: introImage.bottomAnchor).isActive = true
        dividerLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        dividerLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        descriptionText.topAnchor.constraint(equalTo: dividerLine.bottomAnchor).isActive = true
        descriptionText.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        descriptionText.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
//        descriptionText.heightAnchor.constraint(equalToConstant: 150).isActive = true
        descriptionText.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/3).isActive = true
        descriptionText.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}














