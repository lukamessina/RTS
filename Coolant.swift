//
//  Coolant.swift
//  MAXSIMA Simulator
//
//  Created by Luca Messina on 24/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import Foundation

class Coolant: Material {
    
    var coreInletTemperature: Double?
    var coreOutletTemperature: Double?
    var coreAverageTemperature: Double?
    var coreDeltaTemperature: Double?
    var steamGeneratorInletTemperature: Double?
    var steamGeneratorOutletTemperature: Double?
    var steamGeneratorDeltaTemperature: Double?
    var steamGeneratorAverageTemperature: Double?
    var coldlegAverageTemperature: Double?
    var hotlegAverageTemperature: Double?
    var coldpoolAverageTemperature:  Double?
    var hotlegMass: Double?
    var coldpoolMass: Double?
    var coldlegMass: Double?
    var buyoancyHead: Double?
    var initialBuyoancyHead: Double?
    
    var coreHeatCapacity: Double?
    var coreConductivity: Double?
    var coreViscosity: Double?
    var coreDensity: Double?
    var coreInletDensity: Double?
    var coreOutletDensity: Double?
    var coreChannelDensity: Double?
    var coreMass: Double?
    var coreMassFlow: Double?
    var initialCoreMassFlow: Double?
    var massFlowFactor: Double?
    var coreVelocity: Double?
    var coreReynoldsNumber: Double?
    var corePrandtlNumber: Double?
    var corePecletNumber: Double?
    var coreNusseltNumber: Double?
    
    var heatTransferFromCladding: Double?
    
    var viscosityCoefficients = [Double]()
    
    // Initializer
    
    init ( name: String ) {
        
        super.init()
        
        materialType = MaterialType.Coolant
        self.name = name
        
        // Specific to lead
        densityCoefficients = [ 11367.0, -1.1944, 0.0, 0.0 ]
        conductivityCoefficients = [ 9.2, 0.011, 0.0, 0.0 ]
        heatCapacityCoefficients = [ 162.9, -0.03022, 8.341e-6, 0.0 ]
        viscosityCoefficients = [ 4.55e-4, 1069.0 ]
        
    }
    
    func calculateViscosity ( temperature: Double ) -> Double {
        
        let v0 = viscosityCoefficients[0]
        let v1 = viscosityCoefficients[1]
        let T = temperature
        let viscosity = v0 * exp(v1/T)
        return viscosity
        
    }
    
}
