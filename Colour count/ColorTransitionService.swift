//
//  ColorTransitionService.swift
//  Colour count
//
//  Created by Vladimir Barus on 06.04.2021.
//

import Foundation

class ColorTransitionService {
    
    func lab2xyz(_ labColor: Color) -> Color {
        
        var varY = (labColor.channel1 + 16) / 116
        var varX = labColor.channel2 / 500 + varY
        var varZ = varY - labColor.channel3 / 200
        
        varY = pow(varY, 3) > 0.008856 ? pow(varY, 3) : (varY - 16.0 / 116.0) / 7.787
        varX = pow(varX, 3) > 0.008856 ? pow(varX, 3) : (varX - 16.0 / 116.0) / 7.787
        varZ = pow(varZ, 3) > 0.008856 ? pow(varZ, 3) : (varZ - 16.0 / 116.0) / 7.787
        
        let x = 95.047 * varX
        let y = 100.000 * varY
        let z = 108.883 * varZ
        
        return Color(channel1: x, channel2: y, channel3: z)
    }
        
    func xyz2rgb(_ xyzColor: Color) -> Color {

        let x = xyzColor.channel1
        let y = xyzColor.channel2
        let z = xyzColor.channel3

        let varX = x / 100
        let varY = y / 100
        let varZ = z / 100

        var varR = varX *  3.2406 + varY * -1.5372 + varZ * -0.4986
        var varG = varX * -0.9689 + varY *  1.8758 + varZ *  0.0415
        var varB = varX *  0.0557 + varY * -0.2040 + varZ *  1.0570
        
        let powC: Float = 1.0 / 2.4

        varR = varR > 0.0031308 ? 1.055 * pow(varR , powC)  - 0.055 : 12.92 * varR
        varG = varG > 0.0031308 ? 1.055 * pow(varG , powC)  - 0.055 : 12.92 * varG
        varB = varB > 0.0031308 ? 1.055 * pow(varB , powC)  - 0.055 : 12.92 * varB

        return Color(channel1: varR * 255, channel2: varG * 255, channel3: varB * 255)
        
    }
    
    func lab2lch(_ labColor: Color) -> Color {
        
        let l = labColor.channel1
        let a = labColor.channel2
        let b = labColor.channel3
        
        let c = sqrt((pow(a, 2) + pow(b, 2)))
        let varH = atan2(b, a)
        let h = varH > 0 ? (varH / .pi) * 180 : 360 - (abs(varH) / .pi) * 180
        
        return Color(channel1: l, channel2: c, channel3: h)
        
    }
    
    private func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    func lch2lab(_ lchColor: Color) -> Color {
        let l = lchColor.channel1
        let c = lchColor.channel2
        let h = lchColor.channel3

        let a = cos(deg2rad(Double(h))) * Double(c)
        let b = sin(deg2rad(Double(h))) * Double(c)

        return Color(channel1: Float (l), channel2: Float(a), channel3: Float(b))
    }
    
    func rgb2hsv(_ rgbColor: Color) -> Color {
        
        let r = rgbColor.channel1
        let g = rgbColor.channel2
        let b = rgbColor.channel3
        
        let varR = ( r / 255 )
        let varG = ( g / 255 )
        let varB = ( b / 255 )
        
        let varMin = min( varR, varG, varB )
        let varMax = max( varR, varG, varB )
        let delMax = varMax - varMin
        
        let v = varMax
        
        var h: Float = 0.0
        var s: Float = 0.0
        
        if (delMax == 0) {
            h = 0
            s = 0
        } else {
            s = delMax / varMax
            
            let delR = ((( varMax - varR) / 6) + (delMax / 2)) / delMax
            let delG = ((( varMax - varG) / 6) + (delMax / 2)) / delMax
            let delB = ((( varMax - varB) / 6) + (delMax / 2)) / delMax
            
            if varR == varMax {
                h = delB - delG
            } else if varG == varMax {
                h = (1 / 3) + delR - delB
            } else if (varB == varMax) {
                h = (2 / 3) + delG - delR
            }
            
            if (h < 0) {
                h += 1
            }
            if (h > 1) {
                h -= 1
            }
        }
        return Color(channel1: h, channel2: s, channel3: v)
    }
    
    func hsv2rgb(_ hsvColor: Color) -> Color {
        
        let h = hsvColor.channel1
        let s = hsvColor.channel2
        let v = hsvColor.channel3
        
        if (s == 0) {
            let r = v * 255
            let g = v * 255
            let b = v * 255
            
            return Color(channel1: r, channel2: g, channel3: b)
            
        } else {
            var varR: Float = 0.0
            var varG: Float = 0.0
            var varB: Float = 0.0
            
            var varH = h * 6
            if (varH == 6) {
                varH = 0
            }
            let varI = (varH)
            let var1 = v * (1 - s)
            let var2 = v * (1 - s * (varH - (varI)))
            let var3 = v * (1 - s * (1 - ( varH - (varI))))
            
            if (varI == 0) {
                varR = v
                varG = var3
                varB = var1
            } else if (varI == 1) {
                varR = var2
                varG = v
                varB = var1
            } else if (varI == 2) {
                varR = var1
                varG = v
                varB = var3
            } else if (varI == 3) {
                varR = var1
                varG = var2
                varB = v
            } else if (varI == 4) {
                varR = var3
                varG = var1
                varB = v
            } else {
                varR = v
                varG = var1
                varB = var2
            }
            return Color(channel1: varR * 255, channel2: varG * 255, channel3: varB * 255)
        }
    }
    func rgb2hsb(_ rgbColor: Color) -> Color {
        let r = rgbColor.channel1
        let g = rgbColor.channel2
        let b = rgbColor.channel3
        
        let minVal: Float = min(r, min(g, b))
        let maxVal: Float = max(r, max(g, b))
        
        let bri = (maxVal + minVal) / 510
        var sat: Float
        var hue: Float
        
        var varR: Float = 0.0
        var varG: Float = 0.0
        var varB: Float = 0.0
        
        if (maxVal == minVal) {
            sat = 0.0
        } else {
            var sum = Float(maxVal + minVal)
            
            if (sum > 255) {
                sum = 510 - sum
            }
            sat = (maxVal - minVal) / sum
        }
        
        if (maxVal == minVal) {
            hue = 0.0
        } else {
            // TODO: here
//            var diff: Float = 0.0
//            diff = (maxVal - minVal)
            varR = (maxVal - r)
            varG = (maxVal - g)
            varB = (maxVal - b)
            
            hue = 0.0
            
            if (r == maxVal) {
                hue = 60.0 * (6.0 + varB - varG)
            }
            
            if (g == maxVal) {
                hue = 60.0 * (2.0 + varR - varB)
            }
            
            if (b == maxVal) {
                hue = 60.0 * (4.0 + varG - varR)
            }
            
            if (hue > 360.0)
            {
                hue = hue - 360.0
            }
        }
        return Color(channel1: hue, channel2: sat, channel3: bri)
    }
    
    func hsb2rgb(_ hsbColor: Color) -> Color {
        let h = hsbColor.channel1
        let s = hsbColor.channel2
        let b = hsbColor.channel3
        
        var varR: Float = 0.0
        var varG: Float = 0.0
        var varB: Float = 0.0
        
        let i = (h / 60).truncatingRemainder(dividingBy: b)
        let f = (h / 60) - i
        let p = b * (1 - s)
        let q = b * (1 - f * s)
        let t = b * (1 - (1 - f) * s)
        
        switch i {
        case 0:
            varR = b
            varG = t
            varB = p
        case 1:
            varR = q
            varG = b
            varB = p
        case 2:
            varR = p
            varG = b
            varB = t
        case 3:
            varR = p
            varG = q
            varB = b
        case 4:
            varR = t
            varG = p
            varB = b
        case 5:
            varR = b
            varG = p
            varB = q
        default:
            break
        }
        return Color(channel1: varR * 255, channel2: varG * 255, channel3: varB * 255)
    }
    func rgb2hsi(_ rgbColor: Color) -> Color {
        let r = rgbColor.channel1
        let g = rgbColor.channel2
        let b = rgbColor.channel3

        var h: Float = 0
        var s: Float = 0
        var i: Float = 0

        var resultH = 0
        var resultS: Float = 0
        var resultI = 0

        i = (r + g + b) / 3
        
        if (r + g + b) == 765 {
            s = 0
            h = 0
        }
        
        let minimum = min(r, min(g, b))
        
        if i > 0 {
            s = 1 - minimum / i
        } else if i == 0 {
            s = 0
        }
        
        let temp = (r - (g / 2) - (b / 2)) / (sqrt((r * r) + (g * g) + (b * b) - (r * g) - (r * b) - (g * b)))
        
        if g >= b {
            h = acos(temp)
            resultH = Int(h)
        } else if b > g {
            h = 360 - acos(temp)
            resultH = Int(h)
        }
        
        resultH = Int(h)
        resultS = s
        resultI = Int(i)
        
        return Color(channel1: Float(resultH), channel2: resultS, channel3: Float(resultI))
    }
    
    func hsi2rgb(_ hsiColor: Color) -> Color {
        let h = hsiColor.channel1
        let s = hsiColor.channel2
        let i = hsiColor.channel3
        
        var r: Float = 0
        var g: Float = 0
        var b: Float = 0
        
        if h == 0 {
            r = Float(i + (2 * i * s))
            g = Float(i - (i * s))
            b = Float(i - (i * s))
        } else if (0 < h) && (h < 120) {
            r = Float(i + (i * s) * cos(h) / cos(60 - h))
            g = Float(i + (i * s) * (1 - cos(h) / cos(60 - h)))
            b = Float(i - (i * s))
        } else if h == 120 {
            r = Float(i - (i * s))
            g = Float(i + (2 * i * s))
            b = Float(i - (i * s))
        } else if (120 < h) && (h < 240) {
            r = Float(i - (i * s))
            g = Float(i + (i * s) * cos(h - 120) / cos(180 - h))
            b = Float(i + (i * s) * (1 - cos(h - 120 / cos(180 - h))))
        } else if h == 240 {
            r = Float(i - (i * s))
            g = Float(i - (i * s))
            b = Float(i + (2 * i * s))
        } else if (240 < h) && (h < 360) {
            r = Float(i + (i * s) * (1 - cos(h - 240) / cos(300 - h)))
            g = Float(i - (i * s))
            b = Float(i + (i * s) * cos(h - 240) / cos(300 - h))
        }
        
        return Color(channel1: r, channel2: g, channel3: b)
    }
    func rgb2xyz(_ rgbColor: Color) -> Color {
        let r = rgbColor.channel1
        let g = rgbColor.channel2
        let b = rgbColor.channel3

        var varR = r / 255
        var varG = g / 255
        var varB = b / 255

        if (varR > 0.04045) {
            varR = pow((varR + 0.055) / 1.055, 2.4)
        } else {
            varR = varR / 12.92
        }
        if (varG > 0.04045) {
            varG = pow((varG + 0.055) / 1.055, 2.4)
        } else {
            varG = varG / 12.92
        }
        if (varB > 0.04045) {
            varB = pow((varB + 0.055) / 1.055, 2.4)
        } else {
            varB = varB / 12.92
        }
        
        varR = varR * 100
        varG = varG * 100
        varB = varB * 100
        
        let x = varR * 0.4124 + varG * 0.3576 + varB * 0.1805
        let y = varR * 0.2126 + varG * 0.7152 + varB * 0.0722
        let z = varR * 0.0193 + varG * 0.1192 + varB * 0.9505
        
        return Color(channel1: x, channel2: y, channel3: z)
    }
    
    func xyz2lab (_ xyzColor: Color) -> Color {
        let x = xyzColor.channel1
        let y = xyzColor.channel2
        let z = xyzColor.channel3
        
        var varX = x / 95.047
        var varY = y / 100.000
        var varZ = z / 108.883
        
        if (varX > 0.008856) {
            varX = pow(varX, 1/3)
        } else {
            varX = (7.787 * varX) + (16 / 116)
        }
        if (varY > 0.008856) {
            varY = pow(varY, 1/3)
        } else {
            varY = (7.787 * varY) + (16 / 116)
        }
        if (varZ > 0.008856) {
            varZ = pow(varZ, 1/3)
        } else {
            varZ = (7.787 * varZ) + (16 / 116)
        }
        let l = (116 * varY) - 16
        let a = 500 * (varX - varY)
        let b = 200 * (varY - varZ)
        
        return Color(channel1: l, channel2: a, channel3: b)
    }
}
