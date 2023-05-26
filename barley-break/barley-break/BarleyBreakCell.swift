//
//  BarleyBreakCell.swift
//  barley-break
//
//  Created by Андрей Лосюков on 26.05.2023.
//


import UIKit

class BarleyBreakCell: UICollectionViewCell {

    func configure(with digit: Int?) {
        contentView.backgroundColor = .white
        if let digit = digit {
            label.text = String(digit)
        } else {
            label.text = ""
        }
        contentView.addSubview(label)
        setupConstraints()
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
