//
//  NoteTableViewCell.swift
//  NotePad
//
//  Created by Hamza Sikandar on 09/09/2025.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    static let reuseIdentifier = "NoteTableViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 1
        return label
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .red
        label.numberOfLines = 2
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .blue
        return label
    }()

    private let favLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(favLabel)

        [titleLabel, contentLabel, dateLabel, favLabel].forEach { item in
            
            item.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            favLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            favLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favLabel.widthAnchor.constraint(equalToConstant: 20),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: favLabel.leadingAnchor, constant: -8),

            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            dateLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    func configure(note: Note, formattedDate: String) {
        titleLabel.text = note.title 
        contentLabel.text = note.content
        dateLabel.text = formattedDate
        favLabel.text = note.isFavorite ?"⭐" : ""
    }
}
