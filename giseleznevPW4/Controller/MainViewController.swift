//
//  ViewController.swift
//  giseleznevPW4
//
//  Created by Григорий Селезнев on 11/21/22.
//

import UIKit

final class MainViewController: UIViewController, ObserverProtocol {
    //MARK: - Variables
    weak var delegate: ObserverBackProtocol?
    
    let incrementButton = UIButton()
    
    let commentLabel = UILabel()
    let valueLabel = UILabel()
    
    var buttonsSV = UIStackView()
    
    let colorPaletteView = ColorPaletteView()
    
    var value: Int = 0
    
    //MARK: - overrides default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - Setup View
    private func setupView() {
        view.backgroundColor = .systemGray6
        
        // Main button to increment value
        setupIncrementButton()
        // Main Label that represents value
        setupValueLabel()
        // CommentView that shown at the top
        setupCommentView()
        // Buttons that shown at the bottom
        setupMenuButtons()
        // Color palette View
        setupColorControlSV()
    }
    
    //MARK: - Setup Increment Button
    private func setupIncrementButton() {
        incrementButton.backgroundColor = .white
        incrementButton.layer.cornerRadius = 12
        incrementButton.applyShadows()
        incrementButton.setTitle("Increment", for: .normal)
        incrementButton.setTitleColor(.black, for: .normal)
        incrementButton.layer.shadowColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        self.view.addSubview(incrementButton)
        incrementButton.setHeight(48)
        incrementButton.pinTop(to: self.view.centerYAnchor)
        incrementButton.pinLeft(to: view.leadingAnchor, 24)
        incrementButton.pinRight(to: view.trailingAnchor, 24)
        
        incrementButton.addTarget(self, action: #selector(incrementButtonPressed(_:)), for: .touchUpInside)
    }
    
    //MARK: - setup Value label
    private func setupValueLabel() {
        valueLabel.font = .systemFont(ofSize: 40, weight: .bold)
        valueLabel.textColor = .black
        valueLabel.text = "\(value)"
        
        self.view.addSubview(valueLabel)
        valueLabel.pinBottom(to: incrementButton.topAnchor, 16)
        valueLabel.pinCenterX(to: self.view.centerXAnchor)
    }
    
    //MARK: - Setup Comment View
    @discardableResult
    private func setupCommentView() -> UIView {
        let commentView = UIView()
        commentView.backgroundColor = .white
        commentView.layer.cornerRadius = 12
        
        view.addSubview(commentView)
        commentView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        commentView.pinLeft(to: view.leadingAnchor, 24)
        commentView.pinRight(to: view.trailingAnchor, 24)
        
        commentLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        commentLabel.font = .systemFont(ofSize: 18, weight: .regular)
        commentLabel.textColor = .systemGray
        commentLabel.numberOfLines = 0
        commentLabel.textAlignment = .center
        
        commentView.addSubview(commentLabel)
        commentLabel.pin(to: commentView, [.right: 16, .left: 16, .top: 16, .bottom: 16])
        
        return commentView
    }
    
    
    private func makeMenuButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalTo:
        button.widthAnchor).isActive = true
        return button
    }
    
    //MARK: - Setup Menu buttons
    private func setupMenuButtons() {
        let colorsButton = makeMenuButton(title: "🎨")
        colorsButton.addTarget(self, action: #selector(colorsButtonPressed(_:)), for: .touchUpInside)
        let randomColorBackground = makeMenuButton(title: "random🎨")
        randomColorBackground.addTarget(self, action: #selector(randomColorPressed(_:)), for: .touchUpInside)
        let notesButton = makeMenuButton(title: "📝")
        notesButton.addTarget(self, action: #selector(notesButtonPressed(_:)), for: .touchUpInside)
        let newsButton = makeMenuButton(title: "📰")
        newsButton.addTarget(self, action: #selector(newsButtonPressed(_:)), for: .touchUpInside)
         
        buttonsSV = UIStackView(arrangedSubviews: [colorsButton, randomColorBackground, notesButton, newsButton])
        buttonsSV.spacing = 12
        buttonsSV.axis = .horizontal
        buttonsSV.distribution = .fillEqually
        self.view.addSubview(buttonsSV)
        buttonsSV.pin(to: self.view, [.left: 24, .right: 24])
        buttonsSV.pinBottom(to: self.view.safeAreaLayoutGuide.bottomAnchor, 24)
    }
    
    //MARK: - Setup Color Palette View
    private func setupColorControlSV() {
        colorPaletteView.isHidden = true
        view.addSubview(colorPaletteView)
        
        colorPaletteView.pinTop(to: incrementButton.bottomAnchor, 8)
        colorPaletteView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 24)
        colorPaletteView.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 24)
        colorPaletteView.pinBottom(to: buttonsSV.topAnchor, 8)
        
        colorPaletteView.delegate = self
        delegate = colorPaletteView
    }
    
    
    //MARK: - Update funcs
    private func updateUI() {
        UIView.transition(with: valueLabel,
                      duration: 0.25,
                       options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.valueLabel.text = String(self?.value ?? 0) },
                    completion: nil)
        
        UIView.transition(with: commentLabel,
                      duration: 0.25,
                       options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.commentLabel.text = self?.updateCommentView(value: self?.value ?? 0) },
                    completion: nil)
    }
    
    private func updateCommentView(value: Int) -> String {
        var result: String = ""
        switch  value {
            case 0...10:
                result = "1"
            case 10...20:
                result = "2"
            case 20...30:
                result = "3"
            case 30...40:
                result = "4"
            case 40...50:
                result = "🎉🎉🎉🎉🎉🎉🎉"
            case 50...60:
                result = "big boy"
            case 60...70:
                result = "70 70 70 moreeee"
            case 70...80:
                result = "⭐️⭐️⭐️⭐️⭐️⭐️"
            case 80...90:
                result = "80+\ngo higher"
            case 90...100:
                result = "Hooray!!! 90+"
            case 100... :
                result = "100!!! to the moon!!"
            default:
                break
        }
        return result
    }
    
    
    //MARK: - Actions
    func changeColor(_ slider: ColorPaletteView) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = slider.chosenColor
        }
    }
    
    
    @objc
    private func incrementButtonPressed(_ sender: UIButton) {
        value += 1
        let generator = UIImpactFeedbackGenerator(style:  .light)
        generator.impactOccurred()
        
        
        UIView.animate(withDuration: 0.15) {
            self.updateUI()
        }
    }
    
    @objc
    private func colorsButtonPressed(_ sender: UIButton) {
        colorPaletteView.isHidden.toggle()
        delegate?.setSliders(view.backgroundColor ?? .black)
        colorPaletteView.applyHapticResponse()
    }
    
    @objc
    private func randomColorPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor(red: .random(in: 0...1),
                                           green: .random(in: 0...1),
                                           blue: .random(in: 0...1),
                                           alpha: 1)
            self.delegate?.setSliders(self.view.backgroundColor ?? .black)
        }
       
    }
    
    
    @objc
    private func notesButtonPressed(_ sender: UIButton) {
        let notesViewController = NotesViewController()
        navigationController?.present(notesViewController, animated: true, completion: {})
    }
    
    @objc
    private func newsButtonPressed(_ sender: UIButton) {
    }
}

