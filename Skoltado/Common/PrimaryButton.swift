//
//  PrimaryButton.swift
//  Skoltado
//
//  Created by Mike Shevelinsky on 24.07.2022.
//

import UIKit

class PrimaryButton: UIButton {

    init() {
        super.init(frame: .zero)
        layer.cornerRadius = Spacings.big
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = .zero
        layer.shadowRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
