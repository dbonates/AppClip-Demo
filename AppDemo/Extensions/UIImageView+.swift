//
//  UIImageView+.swift
//  AppDemo
//
//  Created by Daniel Bonates on 10/12/21.
//

import UIKit


extension UIImageView {
    func showImage(_ image: UIImage?) {
        UIView.transition(with: self,
                          duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.image = image
                }, completion: nil)
    }
}
