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
    
    @IBOutlet weak var lch76: UITextField!
    @IBOutlet weak var rgb76: UITextField!
    @IBOutlet weak var hsb76: UITextField!
    @IBOutlet weak var hsv76: UITextField!
    @IBOutlet weak var hsi76: UITextField!
    
    @IBOutlet weak var lch94: UITextField!
    @IBOutlet weak var rgb94: UITextField!
    @IBOutlet weak var hsb94: UITextField!
    @IBOutlet weak var hsv94: UITextField!
    @IBOutlet weak var hsi94: UITextField!
    
    @IBOutlet weak var lch00: UITextField!
    @IBOutlet weak var rgb00: UITextField!
    @IBOutlet weak var hsb00: UITextField!
    @IBOutlet weak var hsv00: UITextField!
    @IBOutlet weak var hsi00: UITextField!
    
    
    let colorTransitionService = ColorTransitionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorView()

    }

    func setupColorView() {
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 12
    }
    
    var originalLABColor: Color?
    
    var rgb4Delta: Color?
    var lch4Delta: Color?
    var hsb4Delta: Color?
    var hsv4Delta: Color?
    var hsi4Delta: Color?
    
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
        
        originalLABColor = labColor
        
        rgb4Delta = rgbColor
        lch4Delta = lchColor
        hsb4Delta = hsbColor
        hsv4Delta = hsvColor
        hsb4Delta = hsbColor
        
        
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
    
    @IBAction func deltaCounter(_ sender: UIButton) {
        guard
            let originalLABColor = self.originalLABColor,
            let rgbColor = rgb4Delta,
            let lchColor = lch4Delta,
            let hsbColor = hsb4Delta,
            let hsvColor = hsv4Delta,
            let hsiColor = hsb4Delta
        else {
            return
        }
        
        let deltaCounter = DeltaCounter()
        
        // RGB delta
        let xyz4RGBDelta = colorTransitionService.rgb2xyz(rgbColor)
        let lab4RGBDelta = colorTransitionService.xyz2lab(xyz4RGBDelta)
        
        let deltaE76RGB = deltaCounter.deltaE76(color1: originalLABColor, color2: lab4RGBDelta)
        rgb76.text = "\(deltaE76RGB)"
        
        let deltaE94RGB = deltaCounter.deltaE94(color1: originalLABColor, color2: lab4RGBDelta)
        rgb94.text = "\(deltaE94RGB)"
        
        let deltaE00RGB = deltaCounter.deltaE00(color1: originalLABColor, color2: lab4RGBDelta)
        rgb00.text = "\(deltaE00RGB)"
        
        //lchDelta
        let lab4LCHDelta = colorTransitionService.lch2lab(lchColor)
        
        let deltaE76LCH = deltaCounter.deltaE76(color1: originalLABColor, color2: lab4LCHDelta)
        lch76.text = "\(deltaE76LCH)"
        
        let deltaE94LCH = deltaCounter.deltaE94(color1: originalLABColor, color2: lab4LCHDelta)
        lch94.text = "\(deltaE94LCH)"
        
        let deltaE00LCH = deltaCounter.deltaE00(color1: originalLABColor, color2: lab4LCHDelta)
        lch00.text = "\(deltaE00LCH)"
        
        //hsbDelta
        let rgb4HSBDelta = colorTransitionService.hsb2rgb(hsbColor)
        let xyz4HSBDelta = colorTransitionService.rgb2xyz(rgb4HSBDelta)
        let lab4HSBDelta = colorTransitionService.xyz2lab(xyz4HSBDelta)
        
        let deltaE76HSB = deltaCounter.deltaE76(color1: originalLABColor, color2: lab4HSBDelta)
        hsb76.text = "\(deltaE76HSB)"
        
        let deltaE94HSB = deltaCounter.deltaE94(color1: originalLABColor, color2: lab4HSBDelta)
        hsb94.text = "\(deltaE94HSB)"
        
        let deltaE00HSB = deltaCounter.deltaE00(color1: originalLABColor, color2: lab4HSBDelta)
        hsb00.text = "\(deltaE00HSB)"
        
        //hsvDelta
        let rgb4HSVDelta = colorTransitionService.hsv2rgb(hsvColor)
        let xyz4HSVDelta = colorTransitionService.rgb2xyz(rgb4HSVDelta)
        let lab4HSVDelta = colorTransitionService.xyz2lab(xyz4HSVDelta)
        
        let deltaE76HSV = deltaCounter.deltaE76(color1: originalLABColor, color2: lab4HSVDelta)
        hsv76.text = "\(deltaE76HSV)"
        
        let deltaE94HSV = deltaCounter.deltaE94(color1: originalLABColor, color2: lab4HSVDelta)
        hsv94.text = "\(deltaE94HSV)"
        
        let deltaE00HSV = deltaCounter.deltaE00(color1: originalLABColor, color2: lab4HSVDelta)
        hsv00.text = "\(deltaE00HSV)"
        
        //hsiDelta
        let rgb4HSIDelta = colorTransitionService.hsi2rgb(hsiColor)
        let xyz4HSIDelta = colorTransitionService.rgb2xyz(rgb4HSIDelta)
        let lab4HSIDelta = colorTransitionService.xyz2lab(xyz4HSIDelta)
        
        let deltaE76HSI = deltaCounter.deltaE76(color1: originalLABColor, color2: lab4HSIDelta)
        hsi76.text = "\(deltaE76HSI)"
        
        let deltaE94HSI = deltaCounter.deltaE94(color1: originalLABColor, color2: lab4HSIDelta)
        hsi94.text = "\(deltaE94HSI)"
        
        let deltaE00HSI = deltaCounter.deltaE00(color1: originalLABColor, color2: lab4HSIDelta)
        hsi00.text = "\(deltaE00HSI)"
    }
    
    
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

