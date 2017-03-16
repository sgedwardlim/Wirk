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
    var introductionPages: [IntroductionPage]?
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(IntroductionCell.self, forCellWithReuseIdentifier: cellId)
        
        initalizePages()
        setupViews()
    }
    
    func initalizePages() {
        
        let page1 = IntroductionPage(imageName: "beforeImage", description: "Inroduction descrption for page 1")
        let page2 = IntroductionPage(imageName: "beforeImage", description: "Inroduction descrption for page 2")
        let page3 = IntroductionPage(imageName: "beforeImage", description: "Inroduction descrption for page 3")
        let page4 = IntroductionPage(imageName: "beforeImage", description: "Inroduction descrption for page 4")
        
        introductionPages?.append(page1)
        introductionPages?.append(page2)
        introductionPages?.append(page3)
        introductionPages?.append(page4)
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: CollectionView Data Source Functions
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! IntroductionCell
        
        cell.introductionPage = introductionPages?[indexPath.item]
        
        return cell
    }
    
    // MARK: CollectionView Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}


class IntroductionCell: UICollectionViewCell {
    
    // MARK: Properties
    var introductionPage: IntroductionPage? {

        didSet {
            guard let introductionPage = introductionPage else { return }
            introImage.image = introductionPage.image
            descriptionTextView.text = introductionPage.description
        }
    }
    
    var introImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "beforeImage")
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var descriptionTextView: UITextView = {
        
        // Customize the message to display
        let message = "DATA DUMP"
        let color = UIColor(white: 0.2, alpha: 1)
        let attributedText = NSMutableAttributedString(string: message, attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium),
            NSForegroundColorAttributeName: color])
        
        // append message to text with different attribuites
        let description = "dsdsadsadas"
        attributedText.append(NSAttributedString(string: "\n\n\(description)", attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 15),
            NSForegroundColorAttributeName: color]))
        
        // Center our text
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let length = attributedText.string.characters.count
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: length))
        
        let tv = UITextView()
        tv.attributedText = attributedText
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
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
        addSubview(descriptionTextView)
        
        introImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        introImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        introImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        introImage.bottomAnchor.constraint(equalTo: descriptionTextView.topAnchor).isActive = true
        
        descriptionTextView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}














