//
//  ActivityIndicatorManager.swift
//  FinFlow
//
//  Created by Vlad Todorov on 29.03.23.
//

import Foundation
import UIKit

final class FFActivityIndicatorManager {

    static let shared = FFActivityIndicatorManager()

    private var container: UIView?
    private var loadingView: UIView?
    private var activityIndicatorView: UIActivityIndicatorView?


    public func showActivityIndicator(on view: UIView) {
    
        if container == nil && loadingView == nil && activityIndicatorView == nil {
            container = UIView()
            container?.backgroundColor = .white.withAlphaComponent(0.3)
            
            loadingView = UIView()
            loadingView?.frame = CGRectMake(0, 0, 50, 50)
            loadingView?.backgroundColor = .appColor(.systemAccentThree)?.withAlphaComponent(0.3)
            loadingView?.clipsToBounds = true
            loadingView?.layer.cornerRadius = 10
            
            activityIndicatorView = UIActivityIndicatorView(style: .medium)
            activityIndicatorView?.color = .appColor(.systemBG)?.withAlphaComponent(0.7)
            activityIndicatorView?.hidesWhenStopped = true
        }
        guard let container = container, let loadingView = loadingView, let activityIndicatorView = activityIndicatorView else { return }
        container.frame = view.frame
        container.center = view.center
        loadingView.center = view.center
        activityIndicatorView.center = CGPointMake(loadingView.frame.size.width / 2,
                                                   loadingView.frame.size.height / 2);
        loadingView.addSubview(activityIndicatorView)
        container.addSubview(loadingView)
        view.addSubview(container)
        activityIndicatorView.startAnimating()
    }

    public func stopActivityIndicator() {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.removeFromSuperview()
        activityIndicatorView = nil
        container?.removeFromSuperview()
        container = nil
        loadingView?.removeFromSuperview()
        loadingView = nil
        
    }

}

