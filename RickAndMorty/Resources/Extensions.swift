//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Shreya Pallan on 12/04/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
