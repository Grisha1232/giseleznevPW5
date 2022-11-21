//
//  ColorPalleteView.swift
//  giseleznevPW3
//
//  Created by Григорий Селезнев on 10/29/22.
//

import UIKit

final class ColorPaletteView: UIControl, ObserverBackProtocol {
    
    weak var delegate: ObserverProtocol?
    private let stackView = UIStackView()
    private(set) var chosenColor: UIColor = .systemGray6
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let redControl = ColorSliderView(colorName: "R", value: Float(chosenColor.redComponent))
        let greenControl = ColorSliderView(colorName: "G", value: Float(chosenColor.greenComponent))
        let blueControl = ColorSliderView(colorName: "B", value: Float(chosenColor.blueComponent))
        redControl.tag = 0
        greenControl.tag = 1
        blueControl.tag = 2
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(redControl)
        stackView.addArrangedSubview(greenControl)
        stackView.addArrangedSubview(blueControl)
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 12
        
        [redControl, greenControl, blueControl].forEach {
            $0.addTarget(self, action: #selector(sliderMoved(slider:)), for: .touchDragInside)
        }
        
        addSubview(stackView)
        stackView.pin(to: self, [.top, .left, .right, .bottom])
    }
    
    
    func setSliders(_ color: UIColor) {
        self.chosenColor = color
        stackView.subviews.forEach {
            if ($0.tag == 0) {
                ($0 as! ColorSliderView).setupSlider(Float(chosenColor.redComponent))
            } else if ($0.tag == 1) {
                ($0 as! ColorSliderView).setupSlider(Float(chosenColor.greenComponent))
            } else {
                ($0 as! ColorSliderView).setupSlider(Float(chosenColor.blueComponent))
            }
        }
    }
    
    @objc
    private func sliderMoved(slider: ColorSliderView) {
        switch slider.tag {
        case 0:
            self.chosenColor = UIColor(red: CGFloat(slider.value),
                                       green: chosenColor.greenComponent,
                                       blue: chosenColor.blueComponent,
                                       alpha: chosenColor.alphaComponent)
        case 1:
            self.chosenColor = UIColor(red: chosenColor.redComponent,
                                       green: CGFloat(slider.value),
                                       blue: chosenColor.blueComponent,
                                       alpha: chosenColor.alphaComponent)
        default:
            self.chosenColor = UIColor(red: chosenColor.redComponent,
                                       green: chosenColor.greenComponent,
                                       blue: CGFloat(slider.value),
                                       alpha: chosenColor.alphaComponent)
        }
        delegate?.changeColor(self)
        sendActions(for: .touchDragInside)
    }
}
