//
//  CreateShotLocationView.swift
//  Skoltado
//
//  Created by Mike Shevelinsky on 24.07.2022.
//

import UIKit

final class CreateShotLocationView: CardView {

    // MARK: - Public Properties

    var titleText: String? {
        nameField.text
    }

    var descriptionText: String? {
        descriptionField.text
    }

    var didTapClose: (() -> ())?
    var didTapSubmit: (() -> ())?

    // MARK: - UI Elements

    private let nameField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "Title"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let saveButton: UIButton = {
        let view = PrimaryButton()
        view.backgroundColor = Colors.orange
        view.setTitleColor(Colors.white, for: .normal)
        view.setTitle("Submit", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let dismissButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "xmark"), for: .normal)
        view.imageView?.contentMode = .scaleAspectFit
        view.imageView?.tintColor = Colors.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Create a new spot"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let descriptionField: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 0.1
        view.text = "Description"
        view.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        view.font = .systemFont(ofSize: 18.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Private Properties
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

        descriptionField.delegate = self
        dismissButton.addAction(UIAction(handler: { _ in
            self.didTapClose?()
        }), for: .touchUpInside)

        saveButton.addAction(UIAction(handler: { _ in
            self.didTapSubmit?()
        }), for: .touchUpInside)
    }

    // MARK: - UI Setup

    private func setupUI() {
        backgroundColor = Colors.white

        addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacings.big),
            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: Spacings.big),
            dismissButton.heightAnchor.constraint(equalToConstant: Spacings.extraBig),
            dismissButton.widthAnchor.constraint(equalToConstant: Spacings.extraBig)
        ])

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacings.big),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        addSubview(nameField)
        NSLayoutConstraint.activate([
            nameField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacings.big),
            nameField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacings.big),
            nameField.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: Spacings.big)
        ])

        addSubview(descriptionField)
        NSLayoutConstraint.activate([
            descriptionField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacings.big),
            descriptionField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacings.big),
            descriptionField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: Spacings.regular),
            descriptionField.heightAnchor.constraint(equalTo: nameField.heightAnchor, multiplier: 3)
        ])

        addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: Spacings.big),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacings.big),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacings.big),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacings.big),
        ])
    }
}

extension CreateShotLocationView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray.withAlphaComponent(0.7) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        }
    }
}
