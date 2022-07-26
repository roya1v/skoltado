//
//  TabBarViewController.swift
//  Skoltado
//
//  Created by Mike Shevelinsky on 25.07.2022.
//

import UIKit

struct TabBarItem {
    let image: UIImage
    let vc: UIViewController
}

final class TabBarViewController: UIPageViewController {

    // MARK: - UI Elements

    private let tabBar: TabBarView = {
        let view = TabBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Private Properties

    private var vcs: [UIViewController] {
        items.map { $0.vc }
    }
    private var items: [TabBarItem]
    private var currentIndex = 0

    // MARK: - Initializers

    init(items: [TabBarItem]) {
        self.items = items
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vcs.forEach { $0.additionalSafeAreaInsets = UIEdgeInsets(top: 0,
                                                                 left: 0,
                                                                 bottom: tabBar.bounds.height + Spacings.big,
                                                                 right: 0)}
    }

    // MARK: - Private Methods

    private func setup() {
        setupUI()
        tabBar.items = items.map { $0.image }
        setViewControllers([vcs[0]], direction: .forward, animated: false)

        tabBar.didTapIndex = { [weak self] index in
            self?.handle(newIndex: index)
        }
    }

    private func handle(newIndex index: Int) {
        let direction: (UIPageViewController.NavigationDirection,
                        ((Int, Int) -> (Int))) = index > self.currentIndex ? (.forward, +) : (.reverse, -)

        repeat {
            currentIndex = direction.1(currentIndex, 1)
            self.setViewControllers([self.vcs[currentIndex]], direction: direction.0, animated: true)
        } while index != currentIndex
    }

    // MARK: - UI Setup

    func setupUI() {
        view.addSubview(tabBar)
        NSLayoutConstraint.activate([
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Spacings.big),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacings.big),
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacings.big),
            tabBar.heightAnchor.constraint(equalToConstant: Spacings.huge)
        ])
    }
}
