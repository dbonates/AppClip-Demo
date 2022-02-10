//
//  UIView+.swift
//  AppDemo
//
//  Created by Daniel Bonates on 06/12/21.
//

import UIKit

// autolayout
extension UIView {
    func fillInParentView() {
        guard let superview = superview else { return }

        topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
        leftAnchor.constraint(equalTo: superview.leftAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor, constant: 0).isActive = true
    }
}

// MainThread

func  swizzleAddSubview() {
    let clazz = UIView.self
    let method: Method = class_getInstanceMethod(clazz, #selector(UIView.addSubview(_:)))!
    let swizzled: Method = class_getInstanceMethod(clazz, #selector(UIView.addSubviewOnMainThread(_:)))!
    method_exchangeImplementations(method, swizzled)
}

func swizzleCollectionViewReloadData() {
    let clazz = UICollectionView.self
    let method: Method = class_getInstanceMethod(clazz, #selector(UICollectionView.reloadData))!
    let swizzled: Method = class_getInstanceMethod(clazz, #selector(UICollectionView.reloadDataOnMainThread))!
    method_exchangeImplementations(method, swizzled)
}

extension UIView {

    @objc dynamic func addSubviewOnMainThread(_ view: UIView) {
        if Thread.isMainThread {
            addSubviewOnMainThread(view)
        } else {
            DispatchQueue.main.sync {
                self.addSubviewOnMainThread(view)
            }
        }
    }
}

extension UICollectionView {
    
    @objc dynamic func reloadDataOnMainThread() {
        if Thread.isMainThread {
            reloadDataOnMainThread()
        } else {
            DispatchQueue.main.sync {
                self.reloadDataOnMainThread()
            }
        }
    }
}
