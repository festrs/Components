//
//  PubAnnotationView.swift
//  Ambev
//
//  Created by Felipe Dias Pereira on 17/10/2018.
//  Copyright © 2018 4all. All rights reserved.
//

import UIKit
import MapKit

public class PubAnnotationView: MKAnnotationView {

    weak var calloutView: AnnotationDialogView?
    
    public override var annotation: MKAnnotation? {
        willSet {
            calloutView?.removeFromSuperview()
        }
    }
    
    /// Animation duration in seconds.
    
    let animationDuration: TimeInterval = 0.25
    
    // MARK: - Initialization methods
    
    public override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        canShowCallout = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Show and hide callout as needed
    
    // If the annotation is selected, show the callout; if unselected, remove it
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        guard let unAnnotation = annotation else { return }
        if selected {
            self.calloutView?.removeFromSuperview()
            
            let calloutView = AnnotationDialogView(annotation: unAnnotation)
            calloutView.add(to: self)
            self.calloutView = calloutView
            
            if animated {
                calloutView.alpha = 0
                UIView.animate(withDuration: animationDuration) {
                    calloutView.alpha = 1
                }
            }
        } else {
            guard let calloutView = calloutView else { return }
            
            if animated {
                UIView.animate(withDuration: animationDuration, animations: {
                    calloutView.alpha = 0
                }, completion: { finished in
                    calloutView.removeFromSuperview()
                })
            } else {
                calloutView.removeFromSuperview()
            }
        }
    }
    
    // Make sure that if the cell is reused that we remove it from the super view.
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        calloutView?.removeFromSuperview()
    }
    
    // MARK: - Detect taps on callout
    
    // Per the Location and Maps Programming Guide, if you want to detect taps on callout,
    // you have to expand the hitTest for the annotation itself.
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) { return hitView }
        
        if let calloutView = calloutView {
            let pointInCalloutView = convert(point, to: calloutView)
            return calloutView.hitTest(pointInCalloutView, with: event)
        }
        
        return nil
    }

}
