//
//  StnIndicatorView.swift
//  StnPhotoBrowser
//
//

import UIKit

class StnIndicatorView: UIActivityIndicatorView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        activityIndicatorViewStyle = .whiteLarge
    }
}
