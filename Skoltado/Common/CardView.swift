//
//  CardView.swift
//  Skoltado
//
//  Created by Mike Shevelinsky on 24.07.2022.
//

import UIKit

class CardView: UIView {

    init() {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = Spacings.big
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = .zero
        layer.shadowRadius = 8
    }

}
