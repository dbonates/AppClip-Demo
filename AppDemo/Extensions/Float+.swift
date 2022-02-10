//
//  Float+.swift
//  AppDemo
//
//  Created by Daniel Bonates on 06/12/21.
//

import Foundation

extension Float {

    // for stars rating stuff

    func decuped() -> (Float, Float) {
        let major = Float(Int(self))
        let minor = ((self - major)*100).rounded()/100
        return (major, minor)
    }

    var major: Float {
        return self.decuped().0
    }

    var minor: Float {
        return self.decuped().1
    }
    
    /// This one is nice for random cell height on Pinterest Layout
    static func random(min: Float = 0, max: Float = 1) -> Float {
        return (Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
}
