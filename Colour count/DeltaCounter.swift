//
//  DeltaCounter.swift
//  Colour count
//
//  Created by Vladimir Barus on 15.04.2021.
//

import Foundation

class DeltaCounter {
    
    func deltaE76 (color1: Color, color2: Color) -> Float {
        let delta = sqrt(pow(color1.channel1 - color2.channel1, 2) +
                            pow(color1.channel2 - color2.channel2, 2) +
                            pow(color1.channel3 - color2.channel3, 2))
        return delta
    }
    func deltaE94 (color1: Color, color2: Color) -> Float {
        var h1 = atan2(color1.channel3, color1.channel2)
        var h2 = atan2(color2.channel3, color2.channel2)
        
        if (h1 > 0) {
            h1 = h1 / .pi * 180
        } else {
            h1 = 360 - abs(h1) / .pi * 180
        }
        if (h2 > 0) {
            h2 = h2 / .pi * 180
        } else {
            h2 = 360 - abs(h2) / .pi * 180
        }
        
        let c1 = sqrt(color1.channel2 * color1.channel2 + color1.channel3 * color1.channel3)
        let c2 = sqrt(color2.channel2 * color2.channel2 + color2.channel3 * color2.channel3)
        
        let lDelta = (color2.channel1 - color1.channel1) / 1
        let cDelta = (c2 - c1) / (1 + 0.045 * c1)
        let hDelta = (h2 - h1) / (1 + 0.015 * c1)
        
        let result = pow(lDelta, 2) + pow(cDelta, 2) + pow(hDelta, 2)
        let delta = sqrt(result)
        
        return delta
    }
    func deltaE00 (color1: Color, color2: Color) -> Float {
        // input
        let l1 = color1.channel1
        let a1 = color1.channel2
        let b1 = color1.channel3
        
        let l2 = color2.channel1
        let a2 = color2.channel2
        let b2 = color2.channel3
        
        // calculate c
        
        let c1 = sqrt(pow(a1, 2) + pow(b1, 2))
        let c2 = sqrt(pow(a2, 2) + pow(b2, 2))
        
        // calculate a, c, b
        
        let cAV = (c1 + c2) / 2
        
        let g = 0.5 * (1 - sqrt(pow(cAV, 7) / (pow(cAV, 7) + pow(25.0, 7))))
        
        let derL1 = l1
        let derA1 = (1 + g) * a1
        let derB1 = b1
        
        let derL2 = l2
        let derA2 = (1 + g) * a2
        let derB2 = b2
        
        let derC1 = sqrt(pow(derA1, 2) + pow(derB1, 2))
        let derC2 = sqrt(pow(derA2, 2) + pow(derB2, 2))
        
        var derH1: Float = 0.0
        var derH2: Float = 0.0
        
        if (derA1 == 0 && derB1 == 0) {
            derH1 = 0
        }
        if (derB1 >= 0) {
            derH1 = atan2(derB1, derA1) * (180.0 / .pi)
        } else {
            derH1 = atan2(derB1, derA1) * (180.0 / .pi) + 360
        }
        if (derA2 == 0 && derB2 == 0) {
            derH2 = 0
        }
        if (derB2 >= 0) {
            derH2 = atan2(derB2, derA2) * (180.0 / .pi)
        } else {
            derH2 = atan2(derB2, derA2) * (180.0 / .pi) + 360
        }
        
        // Step 3 - Calculate dL', dC', dH', dh'
        
        var dhCond = 0
        
        if ((derH2 - derH1) > 180) {
            dhCond = 1;
        }
        if ((derH2 - derH1) < -180) {
            dhCond = 2;
        } else {
            dhCond = 0;
        }
        
        var dderh = 0.0
        
        switch (dhCond) {
        case 0:
            dderh = Double(derH2 - derH1);
        case 1:
            dderh = Double(derH2 - derH1 - 360);
        case 2:
            dderh = Double(derH2 - derH1 + 360);
        default:
            break;
        }
        
        let dderL = derL2 - derL1
        let dderC = derC2 - derC1
        let dderH = 2 * sqrt(Double(derC1 * derC2)) * sin((dderh / 2) * .pi / 180)
        
        // calculate delta00
        
        let derLav = (derL1 + derL2) / 2
        let derCav = (derC1 + derC2) / 2
        
        var haveCond = 0
        
        if (derC1 * derC2 == 0) {
            haveCond = 3
        }
        if (abs(derH2 - derH1) <= 180) {
            haveCond = 0
        } else if ((derH2 + derH1) < 360) {
            haveCond = 1
        } else {
            haveCond = 2
        }
        
        var derHav: Double = 0
        
        switch (haveCond) {
        case 0:
            derHav = Double((derH1 + derH2) / 2)
        case 1:
            derHav = Double((derH1 + derH2) / 2 + 180)
        case 2:
            derHav = Double((derH1 + derH2) / 2 - 180)
        case 3:
            derHav = Double(derH1 + derH2)
        default:
            derHav = 0;
            break;
        }
        
        let deravLpowfif = pow((derLav - 50), 2)
        
        let SL = 1 + (0.015 * deravLpowfif / sqrt(20 + deravLpowfif))
        
        let SC = 1 + 0.045 * derCav
        let T = 1 - 0.17 * cos((derHav - 30) * .pi / 180) + 0.24 * cos(2 * derHav * .pi / 180) + 0.32 * cos((3 * derHav + 6) * .pi / 180) - 0.2 * cos((4 * derHav - 63) * .pi / 180)
        
        let SH = 1 + 0.015 * Double(derCav) * T
        
        let dTheta = Float(30 * exp(-1 * pow((derHav - 275) / 25, 2)))
        
        let RC = 2 * sqrt(pow(derCav, 7) / (pow(derCav, 7) + pow(25, 7)))
        
        let RT = -sin(2 * dTheta * Float.pi / 180) * RC
        
        let last1 = dderL / SL / 1
        
        let last2 = dderC / SC / 1
        
        let last3 = Float(dderH / SH / 1)
        
        let finalDelta2000 = sqrt(pow(last1, 2) + pow(last2, 2) + pow(last3, 2) + RT * last2 * last3)
        
        let delta = finalDelta2000
        
        return delta
    }
}
