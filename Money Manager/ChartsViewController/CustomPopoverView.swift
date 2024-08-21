//
//  CustomPopoverView.swift
//  Money Manager
//
//  Created by Kim on 13.08.2024.
//

import UIKit

class CustomPopoverView: UIView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 8
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        addSubview(label)

        // Constraints for label
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func setup(with text: String) {
        label.text = text
    }

    func show(at point: CGPoint, in view: UIView) {
        // Set the position of the popover
        self.frame = CGRect(x: point.x, y: point.y, width: 100, height: 50)
        view.addSubview(self)

        // Optional: Add animation
        self.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
