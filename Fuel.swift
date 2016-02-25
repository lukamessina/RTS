//
//  Fuel.swift
//  MAXSIMA Simulator
//
//  Created by Luca Messina on 24/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import Foundation

class Fuel: Material {
    
    // Fixed values
    let latticeParameterRoomTemperature: Double
    let molarMass: Double
    let densityRoomTemperature: Double
    
    // Values depending on reactor geometry and evolution
    var massRoomTemperature: Double?
    // var volume: Double?
    
    var outerAverageTemperature: Double?
    var centerAverageTemperature: Double?
    var effectiveTemperature: Double?
    var conductivity: Double?
    var heatTransfer: Double?
    
    // Initializer
    init ( name: String ) {
        
        // Specific to plutoniumZirconiumNitride
        latticeParameterRoomTemperature = 0.47082e-9
        molarMass = ( 254.652*0.4 + 106.124*0.6 ) * amu
        densityRoomTemperature = 4.0 * molarMass / pow(latticeParameterRoomTemperature, 3.0)
        
        super.init()
        materialType = MaterialType.Fuel
        self.name = name
        
        conductivityCoefficients = [ -4.05, 0.0242, -5.43e-6, 0.0 ]
        heatCapacityCoefficients = [ 44.16, 0.01026, -3.0e5, 0.0 ]
        
    }
    
    override func calculateHeatCapacity(temperature: Double) -> Double {
        
        let cp0 = heatCapacityCoefficients[0]
        let cp1 = heatCapacityCoefficients[1]
        let cp2 = heatCapacityCoefficients[2]
        let T = temperature
        
        // Specific to plutoniumZirconiumNitride
        let heatCapacity = ( cp0 + cp1*T + cp2/(T*T) ) * 1e3 / ( molarMass / amu )
        
        return heatCapacity
    }
    
}
