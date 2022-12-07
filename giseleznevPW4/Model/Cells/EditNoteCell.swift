//
//  EditNoteCell.swift
//  giseleznevPW4
//
//  Created by Григорий Селезнев on 11/21/22.
//

import UIKit

final class EditNoteCell: UITableViewCell {
    static let reuseIdentifier = "EditNoteCell"
    private var indexPath: IndexPath?
    private var textView = UITextView()
    public var submitButton = UIButton()
    public var cancelButton = UIButton()
    public var delegate: EditNoteDelegate?
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.indexPath = nil
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.textColor = .tertiaryLabel
        textView.backgroundColor = .clear
        textView.setHeight(140)
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        submitButton.setTitleColor(.systemBackground, for: .normal)
        submitButton.backgroundColor = .label
        submitButton.layer.cornerRadius = 8
        submitButton.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        submitButton.alpha = 0.5
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.setTitleColor(.systemBackground, for: .normal)
        cancelButton.backgroundColor = .label
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        cancelButton.alpha = 0.5
        cancelButton.setWidth((contentView.frame.width - 40) / 2)
        submitButton.setWidth((contentView.frame.width - 40) / 2)
        
        let stackViewButtons =  UIStackView(arrangedSubviews: [submitButton, cancelButton])
        stackViewButtons.axis = .horizontal
        stackViewButtons.spacing = 8
        let stackView = UIStackView(arrangedSubviews: [textView, stackViewButtons])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        
        contentView.addSubview(stackView)
        stackView.pin(to: contentView, [.left: 16, .top: 16, .right: 16, .bottom: 16])
        contentView.backgroundColor = .systemGray5
    }
    
    public func setIndexPath(index: IndexPath) {
        self.indexPath = index
    }
    
    @objc
    private func submitButtonTapped(_ sender: UIButton) {
        print("submitted")
        delegate?.editNote(note: ShortNote(text: textView.text), indexPath: indexPath ?? IndexPath(row: 0, section: 1))
    }
    
    @objc
    private func cancelButtonTapped(_ sender: UIButton) {
        print("cancel")
        delegate?.cancelEditing()
    }
    
    public func configure(note: ShortNote) {
        textView.text = note.text
    }
}
