//
//  Material.swift
//  MAXSIMA Simulator
//
//  Created by Luca Messina on 24/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import Foundation

class Material {
    
    enum MaterialType {
        case Cladding
        case Coolant
        case Fuel
        case GapGas
    }
    
    var materialType: MaterialType?
    var name: String?
    
    var densityCoefficients = [Double]()
    var conductivityCoefficients = [Double]()
    var heatCapacityCoefficients = [Double]()
    
    // Initializer
    init () {
        
        densityCoefficients = [ 0.0, 0.0, 0.0, 0.0 ]
        conductivityCoefficients = [ 0.0, 0.0, 0.0, 0.0 ]
        heatCapacityCoefficients = [ 0.0, 0.0, 0.0, 0.0 ]
        
    }
    
    func calculateDensity ( temperature: Double ) -> Double {
        let d0 = densityCoefficients[0]
        let d1 = densityCoefficients[1]
        let d2 = densityCoefficients[2]
        let d3 = densityCoefficients[3]
        let T = temperature
        let density = d0 + d1*T + d2*T*T + d3*T*T*T
        return density
    }
    
    func calculateConductivity ( temperature: Double ) -> Double {
        let c0 = conductivityCoefficients[0]
        let c1 = conductivityCoefficients[1]
        let c2 = conductivityCoefficients[2]
        let c3 = conductivityCoefficients[3]
        let T = temperature
        let conductivity = c0 + c1*T + c2*T*T + c3*T*T*T
        return conductivity
    }
    
    func calculateHeatCapacity ( temperature: Double ) -> Double {
        let cp0 = heatCapacityCoefficients[0]
        let cp1 = heatCapacityCoefficients[1]
        let cp2 = heatCapacityCoefficients[2]
        let cp3 = heatCapacityCoefficients[3]
        let T = temperature
        let heatCapacity = cp0 + cp1*T + cp2*T*T + cp3*T*T*T
        return heatCapacity
    }
    
}
