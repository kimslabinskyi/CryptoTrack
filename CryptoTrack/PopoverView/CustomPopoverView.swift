//
//  CustomPopoverView.swift
//  Money Manager
//
//  Created by Kim on 13.08.2024.
//

import UIKit

class CustomPopoverView: UIView {

    private let dateLabel = UILabel()
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
        layer.cornerRadius = 16
        
        dateLabel.textColor = .white
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        
        addSubview(dateLabel)
        addSubview(label)

        // Constraints for dateLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4)
        ])
        
        // Constraints for label
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func setup(date: String, text: String) {
        dateLabel.text = date
        label.text = text
    }

    func show(at point: CGPoint, in view: UIView) {
        self.frame = CGRect(x: point.x, y: point.y, width: 100, height: 70)
        view.addSubview(self)

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
