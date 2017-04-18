//
//  LoadingView.swift
//  QiitaWithFluxSample
//
//  Created by marty-suzuki on 2017/04/16.
//  Copyright © 2017年 marty-suzuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoadingView: UIView {
    
    
    private let activityIndicatorViewStyle: UIActivityIndicatorViewStyle
    let indicatorView: UIActivityIndicatorView
    
    init(indicatorStyle: UIActivityIndicatorViewStyle) {
        self.activityIndicatorViewStyle = indicatorStyle
        self.indicatorView = UIActivityIndicatorView(activityIndicatorStyle: indicatorStyle)
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override var isHidden: Bool {
        didSet {
            if isHidden {
                indicatorView.stopAnimating()
            } else {
                indicatorView.startAnimating()
            }
        }
    }
    
    private func configureView() {
        switch activityIndicatorViewStyle {
        case .gray:
            backgroundColor = UIColor.white.withAlphaComponent(0)
        case .white, .whiteLarge:
            backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

extension Reactive where Base: LoadingView {
    var isHiddenAndAnimating: UIBindingObserver<Base, Bool> {
        return UIBindingObserver(UIElement: base, binding: { (base, isHidden) in
            base.isHidden = isHidden
        })
    }
}
