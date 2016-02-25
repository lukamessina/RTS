//
//  Cladding.swift
//  MAXSIMA Simulator
//
//  Created by Luca Messina on 24/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import Foundation

class Cladding: Material {
    
    var mass: Double?
    var outerAverageTemperature: Double?
    var innerAverageTemperature: Double?
    var middleAverageTemperature: Double?
    var conductivity: Double?
    var heatTransfer: Double?
    // var heatTransferToCoolant: Double?
    
    // Initializer
    init ( name: String ) {
        
        super.init()
        
        materialType = MaterialType.Cladding
        self.name = name
        
        // Specific to 15-15 Ti
        densityCoefficients = [ 8103.0, -0.4723, 1.081e-4, -7.543e-8 ]
        conductivityCoefficients = [ 8.826, 1.707e-2, -2.351e-6, 0.0 ]
        heatCapacityCoefficients = [ 393.3, 0.3609, -2.431e-4, 9.202e-8 ]
        
    }
    
}
