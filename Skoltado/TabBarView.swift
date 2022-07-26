//
//  TabBarView.swift
//  Skoltado
//
//  Created by Mike Shevelinsky on 26.07.2022.
//

import UIKit

final class TabBarView: CardView {

    // MARK: - Public Properties

    var items: [UIImage] = [] {
        didSet {
            items.enumerated().forEach { (index, image) in
                let button = UIButton()
                let color = (index == selectedIndex ? Colors.orange : Colors.gray)
                button.tintColor = color
                button.setImage(image, for: .normal)
                button.addAction(UIAction(handler: { [weak self] action  in
                    self?.selectedIndex = index
                }), for: .touchUpInside)
                stack.addArrangedSubview(button)
            }
        }
    }

    var didTapIndex: ((Int) -> ())?

    // MARK: - UI Elements

    private var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Private Properties

    private var selectedIndex: Int = 0 {
        didSet {
            didTapIndex?(selectedIndex)
            stack
                .arrangedSubviews
                .compactMap { $0 as? UIButton }
                .enumerated()
                .forEach {
                    let color = ($0 == selectedIndex ? Colors.orange : Colors.gray)
                    $1.tintColor = color
                }
        }
    }

    // MARK: - Initializers

    override init() {
        super.init()

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setup() {
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        backgroundColor = .white

        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
