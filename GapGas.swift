//
//  GapGas.swift
//  MAXSIMA Simulator
//
//  Created by Luca Messina on 24/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import Foundation

class GapGas: Material {
    
    let heatCapacity: Double
    let pressure: Double
    let molarMass: Double
    let molarVolumeRoomTemperature: Double
    let densityRoomTemperature: Double
    
    var coreMass: Double?
    var gapConductivity: Double?
    var heatTransfer: Double?
    
    // Initializer
    init ( name: String ) {
        
        // Specific to helium
        heatCapacity = 5193.0
        pressure = 1e5
        molarMass = 4.0026e-3
        molarVolumeRoomTemperature = gasConstant * 293.15 / pressure
        densityRoomTemperature = molarMass / molarVolumeRoomTemperature
        
        super.init()
        
        materialType = MaterialType.GapGas
        self.name = name
        
        conductivityCoefficients = [ 0.173e-2, 0.77163 ]
        
    }
    
    override func calculateConductivity(temperature: Double) -> Double {
        
        let c0 = conductivityCoefficients[0]
        let c1 = conductivityCoefficients[1]
        let T = temperature
        let conductivity = c0 * pow(T, c1)
        return conductivity
        
    }
    
}
