//
//  PaymentOptionsController.swift
//  wirk
//
//  Created by Edward on 3/11/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import UIKit
import StoreKit

class PaymentOptionsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let headerCellId = "headerCellId"
    fileprivate let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor(netHex: 0xE4F5E5)
        
        collectionView?.register(PaymentOptionsHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellId)
        // Register the cells to be used by tableView
        collectionView?.register(PaymentOptionsCell.self, forCellWithReuseIdentifier: cellId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SKProductsDidLoadFromiTunes), name: NSNotification.Name.init("SKProductsHaveLoaded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SKProductsDidLoadFromiTunes), name: NSNotification.Name.init(rawValue: "ReceiptDidUpdated"), object: nil)
    }
    
    func SKProductsDidLoadFromiTunes() {
        
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: Header cell functions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! PaymentOptionsHeaderCell
        return header
    }
    
    // MARK: Cell functions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return StoreManager.shared.productsFromStore.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 250)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = StoreManager.shared.productsFromStore[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PaymentOptionsCell
        
        cell.product = product
        
        // Change status of button if user is subscribed 
        if StoreManager.shared.receiptManager.isSubscribed {
            cell.purchaseButton.setTitle("Subscribed", for: .normal)
            dismiss(animated: true, completion: nil)
        }
        
        return cell
    }
}


class PaymentOptionsHeaderCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(colorType: .background)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let checkImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "checkmark")
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let attributedTextTextView: UITextView = {
        // Set up the properties for textview
        let title = "You've setup your account!"
        let message = "Select a plan to send referrals. Start a free trial - or choose a plan today."
        let color = UIColor(white: 0.2, alpha: 1)
        let attributedText = NSMutableAttributedString(string: title, attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium),
            NSForegroundColorAttributeName: color])
        
        // append message to text
        attributedText.append(NSAttributedString(string: "\n\n\(message)", attributes:
            [NSFontAttributeName: UIFont.systemFont(ofSize: 17),
             NSForegroundColorAttributeName: UIColor.lightGray]))
        
        // center our messages and title
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let length = attributedText.string.characters.count
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: length))
        
        let text = UITextView()
        text.backgroundColor = UIColor(colorType: .background)
        text.isEditable = false
        text.attributedText = attributedText
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        addSubview(containerView)
        containerView.addSubview(checkImage)
        containerView.addSubview(attributedTextTextView)
        
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        checkImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 80).isActive = true
        checkImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        checkImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        checkImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        attributedTextTextView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        attributedTextTextView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 4/5).isActive = true
        attributedTextTextView.topAnchor.constraint(equalTo: checkImage.bottomAnchor, constant: 0).isActive = true
        attributedTextTextView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
}

class PaymentOptionsCell: UICollectionViewCell {
    
    var product: SKProduct? {
        didSet {
            
            guard let product = product else { return }
            productName.text = product.localizedTitle
            productDescription.text = product.localizedDescription
            
            // Use NumberFormatter for thr price to show correct price currency
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product.priceLocale
            productPrice.text = formatter.string(from: product.price)
        }
    }
    
    var productName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var productDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var productPrice: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(netHex: 0x15EDA3)
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var purchaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Subscribe", for: .normal)
        button.addTarget(self, action: #selector(handlePurchase(sender:)), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(netHex: 0x55E9BC)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func handlePurchase(sender: UIButton) {
        guard let product = product else { return }
        StoreManager.shared.buy(product: product)
        print("purchased item clicked")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
//        backgroundColor = .gray
//        backgroundColor = UIColor(colorType: .background)
        backgroundColor = UIColor(netHex: 0xDFE0D4)
        
        addSubview(productName)
        addSubview(productDescription)
        addSubview(productPrice)
        addSubview(purchaseButton)
        
        productName.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        productName.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        productName.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        
        productDescription.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        productDescription.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        productDescription.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 16).isActive = true
        
        productPrice.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        productPrice.centerYAnchor.constraint(equalTo: purchaseButton.centerYAnchor).isActive = true
        
        purchaseButton.leftAnchor.constraint(equalTo: productPrice.rightAnchor).isActive = true
        purchaseButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        purchaseButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        purchaseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        purchaseButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
    }
}

//Get unlimited access to wirk app content, love it and subscribe if not, no love lost. See what it's like to increase your sales revenue












