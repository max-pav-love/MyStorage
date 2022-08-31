//
//  FileCollectionViewCell.swift
//  MyStorage
//
//  Created by Maksim Khlestkin on 26.08.2022.
//

import Foundation
import UIKit

final class FileCollectionViewCell: UICollectionViewCell {
        
    var viewModel: FileCellViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var fileNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.lineBreakMode = .byTruncatingMiddle
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "questionmark")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setupCell() {
        backgroundColor = .white
        layer.borderColor = UIColor.black.cgColor
    }
    
    private func addSubviews() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(previewImageView)
        stackView.addArrangedSubview(fileNameLabel)
                
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            previewImageView.heightAnchor.constraint(equalTo: previewImageView.widthAnchor)
        ])
    }
    
    func configureCellWith(_ name: String, _ fileType: FileType, layoutMode: LayoutMode) {
        fileNameLabel.text = name
        set(preview: fileType)
        set(layoutMode: layoutMode)
    }
    
    private func set(preview: FileType) {
        switch preview {
        case .image:
            previewImageView.image = UIImage(systemName: "photo")
        case .document:
            previewImageView.image = UIImage(systemName: "doc")!
        case .folder:
            previewImageView.image = UIImage(systemName: "folder")!
        case .other:
            previewImageView.image = UIImage(systemName: "questionmark")!
        }
    }
    
    private func set(layoutMode: LayoutMode) {
        switch layoutMode {
        case .grid:
            stackView.alignment = .center
            stackView.axis = .vertical
        case .list:
            stackView.alignment = .fill
            stackView.axis = .horizontal
        }
    }
    
}
