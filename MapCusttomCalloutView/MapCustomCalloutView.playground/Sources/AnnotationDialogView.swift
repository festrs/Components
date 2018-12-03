//
//  AnnotationDialogView.swift
//  Saque e Pague
//
//  Created by Gabriel Miranda Silveira on 13/04/18.
//  Copyright © 2018 4all. All rights reserved.
//

import UIKit
import MapKit

class AnnotationDialogView: CalloutView {
    
    //Image View
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 4.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16.0)
        return label
    }()
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    private var phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        
        return label
    }()
    
    var view: UIView!
    
    override init(annotation: MKAnnotation) {
        super.init(annotation: annotation)
        
        configure()
        
        updateContents(for: annotation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateContents(for annotation: MKAnnotation) {
        guard let pubAnnotation = annotation as? PubAnnotation else { return }
        titleLabel.text = pubAnnotation.name
        subtitleLabel.text = pubAnnotation.subtitle
        phoneLabel.text = pubAnnotation.phone
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = .vertical
        stackView.distribution  = .fill
        stackView.alignment = .leading
        stackView.spacing   = 2.0
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(phoneLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)
        //contentView.addSubview(imageView)
        
        let views: [String: UIView] = [
            "stackView": stackView,
            "imageView": imageView
        ]
        
        let vflStrings = [
            "V:|-19-[stackView(<=220)]-19-|",
            "H:|-20-[stackView(200)]-20-|"
        ]
        
        for vfl in vflStrings {
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: vfl, metrics: nil, views: views))
        }
    }
}

