//
//  ViewController.swift
//  Colour count
//
//  Created by Vladimir Barus on 06.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lTextField: UITextField!
    @IBOutlet weak var aTextField: UITextField!
    @IBOutlet weak var bTextField: UITextField!
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var r1TextField: UITextField!
    @IBOutlet weak var g1TextField: UITextField!
    @IBOutlet weak var b1TextField: UITextField!
    
    @IBOutlet weak var l2TextField: UITextField!
    @IBOutlet weak var c2TextField: UITextField!
    @IBOutlet weak var h2TextField: UITextField!
    
    @IBOutlet weak var h3TextField: UITextField!
    @IBOutlet weak var s3TextField: UITextField!
    @IBOutlet weak var b3TextField: UITextField!
    
    @IBOutlet weak var h4TextField: UITextField!
    @IBOutlet weak var s4TextField: UITextField!
    @IBOutlet weak var v4TextField: UITextField!
    
    @IBOutlet weak var h5TextField: UITextField!
    @IBOutlet weak var s5TextField: UITextField!
    @IBOutlet weak var i5TextField: UITextField!
    
    
    
    let colorTransitionService = ColorTransitionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorView()

    }

    func setupColorView() {
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 12
    }
    
    
    @IBAction func colorRanges(_ sender: UIButton) {
        guard let l = lTextField.text, let a = aTextField.text, let b = bTextField.text else {
            return
        }
        guard let lFloat = Float(l), let aFloat = Float(a), let bFloat = Float(b) else {
            return
        }
        
        let labColor = Color(channel1: lFloat, channel2: aFloat, channel3: bFloat)
        
        let xyzColor = colorTransitionService.lab2xyz(labColor)
        let rgbColor = colorTransitionService.xyz2rgb(xyzColor)
        let lchColor = colorTransitionService.lab2lch(labColor)
        let hsvColor = colorTransitionService.rgb2hsv(rgbColor)
        let hsbColor = colorTransitionService.rgb2hsb(rgbColor)
        let hsiColor = colorTransitionService.rgb2hsi(rgbColor)
        
        r1TextField.text = "\(Float(rgbColor.channel1))"
        g1TextField.text = "\(Float(rgbColor.channel2))"
        b1TextField.text = "\(Float(rgbColor.channel3))"
        
        l2TextField.text = "\(Float(lchColor.channel1))"
        c2TextField.text = "\(Float(lchColor.channel2))"
        h2TextField.text = "\(Float(lchColor.channel3))"
        
        h3TextField.text = "\(Float(hsbColor.channel1))"
        s3TextField.text = "\(Float(hsbColor.channel2))"
        b3TextField.text = "\(Float(hsbColor.channel3))"
        
        h4TextField.text = "\(Float(hsvColor.channel1))"
        s4TextField.text = "\(Float(hsvColor.channel2))"
        v4TextField.text = "\(Float(hsvColor.channel3))"
        
        h5TextField.text = "\(Float(hsiColor.channel1))"
        s5TextField.text = "\(Float(hsiColor.channel2))"
        i5TextField.text = "\(Float(hsiColor.channel3))"
    }
    
    @IBAction func colorTransition(_ sender: UIButton) {
        guard let l = lTextField.text, let a = aTextField.text, let b = bTextField.text else {
            return
        }
        
        guard let lFloat = Float(l), let aFloat = Float(a), let bFloat = Float(b) else {
            return
        }
        
        let labColor = Color(channel1: lFloat, channel2: aFloat, channel3: bFloat)
        
        let xyzColor = colorTransitionService.lab2xyz(labColor)
        let rgbColor = colorTransitionService.xyz2rgb(xyzColor)
        
        colorView.backgroundColor = UIColor(red: CGFloat(rgbColor.channel1 / 255.0), green: CGFloat(rgbColor.channel2 / 255.0), blue: CGFloat(rgbColor.channel3 / 255.0), alpha: 1.0)
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

