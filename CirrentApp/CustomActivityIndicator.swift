//
//  CustomActivityIndicator.swift
//  CirrentApp
//
//  Created by Martynets Ruslan on 16.08.17.
//
//

import UIKit
import CirrentSDK


/**
 * This class is used to display custom activity indicator
 */
class CustomActivityIndicator: NSObject {
  
  // MARK: - Private methods
  fileprivate let activityIndicator = UIActivityIndicatorView()
  fileprivate let backgroundView = UIView()
  fileprivate let backgroundViewTag = 987
  fileprivate let container = UIStackView()
  fileprivate let titleLabel = UILabel()
  fileprivate var message: String?
  // MARK: - Static property
  static let shared = CustomActivityIndicator()
  
  // MARK: - Private methods
  fileprivate override init() {
    if let containerView = UIApplication.shared.keyWindow {
      
      backgroundView.translatesAutoresizingMaskIntoConstraints = false
      backgroundView.alpha = 0
      backgroundView.tag = backgroundViewTag
      backgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.796737456)
      backgroundView.layer.cornerRadius = 10
      backgroundView.clipsToBounds = true
      containerView.addSubview(backgroundView)
      
      container.translatesAutoresizingMaskIntoConstraints = false
      container.alignment = .center
      container.axis = .vertical
      container.distribution = .fill
      container.spacing = 5
      backgroundView.addSubview(container)
      
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicator.hidesWhenStopped = true
      container.addArrangedSubview(activityIndicator)
      
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      titleLabel.font = UIFont.systemFont(ofSize: 14)
      titleLabel.textColor = .white
      titleLabel.textAlignment = .center
      container.addArrangedSubview(titleLabel)
      
      container.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 12).isActive = true
      container.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -12).isActive = true
      container.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 12).isActive = true
      container.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -12).isActive = true
      
      backgroundView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
      backgroundView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    } else {
      print("\n\nCUSTOM ACTIVITY INDICATOR DOESN'T APPEAR!!! keyWindow property is absent!\n\n")
    }
  }
  
  func with(message: String) -> CustomActivityIndicator {
    self.message = message
    return self
  }
  
  fileprivate func show() {
    activityIndicator.style = .whiteLarge
    backgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.796737456)
    
    if let text = message {
      titleLabel.text = text
      titleLabel.isHidden = false
    } else {
      titleLabel.isHidden = true
    }
    
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    if let containerView = UIApplication.shared.keyWindow {
      if let tag = containerView.subviews.last?.tag, tag != backgroundViewTag {
        containerView.bringSubviewToFront(self.backgroundView)
      }
      OperationQueue.main.addOperation {
        self.activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.5, animations: {
          self.backgroundView.alpha = 1
        })
      }
    }
  }
  
  fileprivate func hide() {
    OperationQueue.main.addOperation {
        UIView.animate(withDuration: 0.5, animations: {
          self.backgroundView.alpha = 0
        }, completion: { _ in
          self.activityIndicator.stopAnimating()
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
  }
}

extension CustomActivityIndicator: CirrentProgressView {
  
  func showProgress() {
    show()
  }
  
  func stopProgress() {
    hide()
  }
}
