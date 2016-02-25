//
//  Reactor.swift
//  MAXSIMA Simulator
//
//  Created by Luca Messina on 24/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

import Foundation

class Reactor {
    
    // Materials
    let lead = Coolant ( name: "lead" )
    let helium = GapGas ( name: "helium" )
    let plutoniumZirconiumNitride = Fuel ( name: "plutoniumZirconiumNitride" )
    let fifteenFifteenTitanium = Cladding ( name: "fifteenFifteenTitanium" )
    
    // Core geometry
    let numberCorePins: Int
    let numberSidePins: Int
    let claddingOuterDiameter: Double
    let claddingInnerDiameter: Double
    let spacerDiameter: Double
    let fuelDiameter: Double
    let claddingThickness: Double
    let gapThickness: Double
    let pinPitch: Double
    let spacerPitch: Double
    let fuelHeight: Double
    let upperPlenumHeight: Double
    let lowerPlenumHeight: Double
    let insulationHeight: Double
    let endplugHeight: Double
    let pinHeight: Double
    let claddingOuterRadius: Double
    let claddingInnerRadius: Double
    let fuelRadius: Double
    let spacerRadius: Double
    let pinPerimeter: Double
    let spacerPerimeter: Double
    let hexcanInnerPerimeter: Double
    let pinArea: Double
    let claddingArea: Double
    let gapArea: Double
    let fuelArea: Double
    let spacerArea: Double
    let hexcanInnerArea: Double
    let claddingSurface: Double
    let claddingVolume: Double
    let fuelVolume: Double
    let gapVolume: Double
    let hexcanInnerSideLength: Double
    
    // Primary loop
    let barrelInnerDiameter: Double
    let barrelOuterDiameter: Double
    let vesselInnerDiameter: Double
    let vesselOuterDiameter: Double
    let barrelInnerRadius: Double
    let barrelOuterRadius: Double
    let vesselInnerRadius: Double
    let vesselOuterRadius: Double
    let hotlegVolume: Double
    let coldlegVolume: Double
    let coldpoolVolume: Double
    let hotlegArea: Double
    let coldlegArea: Double
    let numberSteamGenerators: Int
    let numberSteamGeneratorTubes: Int
    let steamGeneratorElevation: Double
    let steamGeneratorTubeOuterDiameter: Double
    let steamGeneratorTubeOuterRadius: Double
    let steamGeneratorTubeArea: Double
    let steamGeneratorTubeHeight: Double
    
    // Hydraulic parameters
    let coreHydraulicDiameter: Double
    let pinCoolantArea: Double
    let coreCoolantArea: Double
    let coreCoolantVolume: Double
    let coreWetPerimeter: Double
    let pinWetPerimeter: Double
    let steamGeneratorWetPerimeter: Double
    
    // Reactivity and kinetics
    var dopplerCoefficient: Double
    var coolantReactivityCoefficient: Double
    var radialReactivityCoefficient: Double
    var axialReactivityCoefficient: Double
    
    let neutronGenerationTime: Double
    let betaEffective: Double
    var decayRates = [Double]()
    var delayedNeutronFractions = [Double]()
    var precursorConcentrations = [Double]()
    
    // Transient parameters
    var reactivity: Double?
    var reactivityFeedback: Double?
    var coolantReactivity: Double?
    var radialReactivity: Double?
    var axialReactivity: Double?
    var neutronPopulation: Double?
    var corePower: Double?
    var initialCorePower: Double?
    var linearCorePower: Double?
    
    // Accident parameters
    /*
    enum ReactorStatus: Int {
        case SteadyState = 0
        case UnprotectedTransientOfPower = 1
        case UnprotectedLossOfHeatSink = 2
        case Overcooling = 3
    }
    */
    var status: Int
    
    var reactivityInsertion: Double?
    var reactivityInsertionRate: Double?
    var accumulatedReactivityInsertion: Double?
    var steamGeneratorPowerLossFraction: Double?
    var lossHeatSinkRate: Double?
    var reactivityReduction: Double?
    var numberFailedSteamGeneratorsOvercooling: Int?
    var rampInterval: Double?
    var transientDuration: Double?
    
    var time: Double
    var neutronicTimeStep: Double
    var hydraulicTimeStep: Double
    var printingTime: Double
    var printingTimeStep: Double
    
    var output = Observables()
    
    // Initializer
    init () {
        // The data for now refer to Sealer only (or Electra?)
        
        // Given data
        
        numberCorePins = 397
        numberSidePins = 12
        claddingOuterDiameter = 12.6 * mm
        claddingThickness = 0.5 * mm
        fuelDiameter = 11.5 * mm
        pinPitch = 14 * mm
        spacerPitch = 480 * mm
        fuelHeight = 300 * mm
        upperPlenumHeight = 10 * mm
        lowerPlenumHeight = 130 * mm
        insulationHeight = 10 * mm
        endplugHeight = 10 * mm
        
        barrelInnerDiameter = 600 * mm
        barrelOuterDiameter = 620 * mm
        vesselInnerDiameter = 900 * mm
        vesselOuterDiameter = 1000 * mm
        hotlegVolume = 0.62
        coldlegVolume = 0.89
        coldpoolVolume = 0.19
        
        numberSteamGenerators = 8
        numberSteamGeneratorTubes = 30
        steamGeneratorElevation = 1.67
        steamGeneratorTubeOuterDiameter = 25.4 * mm
        steamGeneratorTubeHeight = 300 * mm
        
        dopplerCoefficient = 0.0 * pcm
        coolantReactivityCoefficient = -0.43 * pcm
        radialReactivityCoefficient = -1.54 * pcm
        axialReactivityCoefficient = -0.70 * pcm
        
        neutronGenerationTime = 0.05e-6
        
        /*
        // 6 gropus
        decayRates = [ 2.49177e-2, 4.25244e-2, 1.33042e-1, 2.92467e-1, 6.66488e-1, 1.81419e0 ]
        delayedNeutronFractions = [ 58.61*pcm, 22.66*pcm, 39.02*pcm, 88.45*pcm, 21.69*pcm, 36.67*pcm ]
        */
        
        // 2 groups
        decayRates = [ 4.25244e-2, 6.66488e-1 ]
        delayedNeutronFractions = [ 120.29*pcm, 146.81*pcm ]
        
        // Derived quantities
        
        // Reactor core
        claddingInnerDiameter = claddingOuterDiameter - 2.0 * claddingThickness
        spacerDiameter =  ( pinPitch - claddingOuterDiameter ) / 1.0444
        claddingOuterRadius = 0.5 * claddingOuterDiameter
        claddingInnerRadius = 0.5 * claddingInnerDiameter
        fuelRadius = 0.5 * fuelDiameter
        spacerRadius = 0.5 * spacerDiameter
        pinPerimeter = PI * claddingOuterDiameter
        spacerPerimeter = PI * spacerDiameter
        gapThickness = 0.5 * ( claddingInnerDiameter - fuelDiameter )
        pinArea = PI * claddingOuterRadius * claddingOuterRadius
        claddingArea = PI * ( claddingOuterRadius * claddingOuterRadius - claddingInnerRadius * claddingInnerRadius )
        gapArea = PI * ( claddingInnerRadius * claddingInnerRadius - fuelRadius * fuelRadius)
        fuelArea = PI * fuelRadius * fuelRadius
        spacerArea = PI * spacerRadius * spacerRadius
        claddingSurface = pinPerimeter * fuelHeight * Double (numberCorePins)
        pinHeight = fuelHeight + upperPlenumHeight + lowerPlenumHeight + 2.0 * insulationHeight + 2.0 * endplugHeight
        claddingVolume = claddingArea * fuelHeight * Double (numberCorePins)
        gapVolume = gapArea * fuelHeight * Double (numberCorePins)
        fuelVolume = fuelArea * fuelHeight * Double (numberCorePins)
        hexcanInnerSideLength = ( Double (numberSidePins - 1) ) * pinPitch + pinPitch * 2.0/3.0  // Modified formula!
        hexcanInnerPerimeter = 6.0 * hexcanInnerSideLength
        hexcanInnerArea = 6.0 * sqrt(3.0) / 4.0 * hexcanInnerSideLength * hexcanInnerSideLength
        
        // Primary loop
        barrelInnerRadius = 0.5 * barrelInnerDiameter
        barrelOuterRadius = 0.5 * barrelOuterDiameter
        vesselInnerRadius = 0.5 * vesselInnerDiameter
        vesselOuterRadius = 0.5 * vesselOuterDiameter
        hotlegArea = PI * barrelInnerRadius * barrelInnerRadius
        coldlegArea = PI * ( vesselInnerRadius * vesselInnerRadius - barrelOuterRadius * barrelOuterRadius )
        
        // Steam generator
        steamGeneratorTubeOuterRadius = 0.5 * steamGeneratorTubeOuterDiameter
        steamGeneratorTubeArea = PI * steamGeneratorTubeOuterRadius * steamGeneratorTubeOuterRadius
        
        // Hydraulic parameters
        pinCoolantArea = 2.0 * ( sqrt(3.0)/4.0 * pinPitch * pinPitch - 0.5 * pinArea )
        coreCoolantArea = hexcanInnerArea - Double (numberCorePins) * ( pinArea + spacerArea )
        coreCoolantVolume = coreCoolantArea * pinHeight
        coreWetPerimeter = hexcanInnerPerimeter + Double (numberCorePins) * ( pinPerimeter + spacerPerimeter )
        pinWetPerimeter = coreWetPerimeter / Double (numberCorePins)
        coreHydraulicDiameter = 4.0 * pinCoolantArea / pinWetPerimeter
        steamGeneratorWetPerimeter = PI * steamGeneratorTubeOuterDiameter * Double ( numberSteamGeneratorTubes * numberSteamGenerators )
        
        // Kinetic parameters
        betaEffective = delayedNeutronFractions.reduce(0, combine: +)
        for ( index, value ) in delayedNeutronFractions.enumerate() {
            let concentration = value / decayRates[index] / neutronGenerationTime
            precursorConcentrations += [concentration]
        }
        
        // Other material-related derived data
        fifteenFifteenTitanium.mass = claddingVolume * fifteenFifteenTitanium.calculateDensity(293.15)
        helium.coreMass = helium.densityRoomTemperature * gapVolume
        plutoniumZirconiumNitride.massRoomTemperature = fuelVolume * plutoniumZirconiumNitride.densityRoomTemperature
        
        // Steady-state initialization
        status = 0
        corePower = 0.5e6
        initialCorePower = corePower!
        linearCorePower = corePower! / Double (numberCorePins) / fuelHeight
        lead.coreInletTemperature = 400.0 + kelvin
        lead.coreOutletTemperature = 500.0 + kelvin
        lead.coreAverageTemperature = 0.5 * ( lead.coreOutletTemperature! + lead.coreInletTemperature! )
        lead.coreDeltaTemperature = lead.coreOutletTemperature! - lead.coreInletTemperature!
        lead.hotlegAverageTemperature = lead.coreOutletTemperature!
        lead.steamGeneratorInletTemperature = lead.hotlegAverageTemperature!
        lead.steamGeneratorDeltaTemperature = -100.0
        lead.steamGeneratorOutletTemperature = lead.steamGeneratorInletTemperature! + lead.steamGeneratorDeltaTemperature!
        lead.coldlegAverageTemperature = lead.coreInletTemperature!
        lead.coldpoolAverageTemperature = lead.coreInletTemperature!
        
        // Initialize massflow and hydraulic parameters at steady state
        lead.hotlegMass = hotlegVolume * lead.calculateDensity(lead.hotlegAverageTemperature!)
        lead.coldpoolMass = coldpoolVolume * lead.calculateDensity(lead.coldpoolAverageTemperature!)
        lead.coldlegMass = coldlegVolume * lead.calculateDensity(lead.coldlegAverageTemperature!) + lead.coldpoolMass!
        lead.buyoancyHead = g * steamGeneratorElevation * ( lead.calculateDensity(lead.coldlegAverageTemperature!) - lead.calculateDensity(lead.hotlegAverageTemperature!) )
        lead.initialBuyoancyHead = lead.buyoancyHead!
        lead.coreHeatCapacity = lead.calculateHeatCapacity(lead.coreAverageTemperature!)
        lead.coreConductivity = lead.calculateConductivity(lead.coreAverageTemperature!)
        lead.coreViscosity = lead.calculateViscosity(lead.coreAverageTemperature!)
        lead.coreDensity = lead.calculateDensity(lead.coreAverageTemperature!)
        lead.coreMassFlow = corePower! / ( lead.calculateHeatCapacity(lead.coreAverageTemperature!)  * lead.coreDeltaTemperature! )
        lead.initialCoreMassFlow = lead.coreMassFlow!
        lead.coreVelocity = lead.coreMassFlow! / ( coreCoolantArea * lead.coreDensity! )
        lead.coreReynoldsNumber = lead.coreDensity! * lead.coreVelocity! * coreHydraulicDiameter / lead.coreViscosity!
        lead.corePrandtlNumber = lead.coreViscosity! * lead.coreHeatCapacity! / lead.coreConductivity!
        lead.corePecletNumber = lead.coreReynoldsNumber! * lead.corePrandtlNumber!
        lead.coreNusseltNumber = 0.047 * ( 1 - exp ( -3.8 * ( pinPitch / claddingOuterDiameter - 1.0 ) ) ) * ( pow ( lead.corePecletNumber!, 0.77) + 250.0 )
        lead.heatTransferFromCladding = claddingSurface * lead.coreConductivity! * lead.coreNusseltNumber! / coreHydraulicDiameter
        fifteenFifteenTitanium.outerAverageTemperature = lead.coreAverageTemperature! + corePower! / lead.heatTransferFromCladding!
        
        // Initialize reactivity
        reactivity = 0.0
        coolantReactivity = 0.0
        radialReactivity = 0.0
        axialReactivity = 0.0
        neutronPopulation = 1.0
        
        // Accident parameters
        time = 0.0
        neutronicTimeStep = 0.01 * millisecond
        hydraulicTimeStep = 0.01
        printingTime = 0.0
        printingTimeStep = 0.5
        
        accumulatedReactivityInsertion = 0.0
        
        // Initialize average conductivities, heat-transfer coefficients and temperatures
        
        // Heat transfer from inner to outer surface of the clad
        fifteenFifteenTitanium.conductivity = fifteenFifteenTitanium.calculateConductivity(fifteenFifteenTitanium.outerAverageTemperature!)
        calculateCladdingInnerTemperatureByIterations()
        fifteenFifteenTitanium.heatTransfer = 2.0 * PI * fifteenFifteenTitanium.conductivity! * Double (numberCorePins) * fuelHeight / log ( claddingOuterRadius / claddingInnerRadius )
        
        // Heat transfer from inner to outer surface of the gap
        helium.gapConductivity = helium.calculateConductivity(fifteenFifteenTitanium.innerAverageTemperature!)
        calculateFuelOuterTemperatureByIterations()
        helium.heatTransfer = 2 * PI * helium.gapConductivity! * Double (numberCorePins) * fuelHeight / log ( claddingInnerRadius / fuelRadius )
        
        // Heat transfer from centre to surface of the fuel
        plutoniumZirconiumNitride.conductivity = plutoniumZirconiumNitride.calculateConductivity(plutoniumZirconiumNitride.outerAverageTemperature!)
        calculateFuelCenterTemperatureByIterations()
        plutoniumZirconiumNitride.heatTransfer = 4 * PI * plutoniumZirconiumNitride.conductivity! * Double ( numberCorePins ) * fuelHeight
        
        // Save output variables
        saveOutput()
    }
    
    func calculateCladdingInnerTemperatureByIterations() {
        var tolerance = 1.0
        var conductivityIteration = fifteenFifteenTitanium.conductivity!
        var deltaTest: Double?
        var deltaCheck: Double?
        while tolerance > 1e-6 {
            deltaTest = linearCorePower! / ( 2.0 * PI * conductivityIteration ) * log ( claddingOuterRadius / claddingInnerRadius )
            conductivityIteration = fifteenFifteenTitanium.calculateConductivity(fifteenFifteenTitanium.outerAverageTemperature! + 0.5 * deltaTest! )
            deltaCheck = linearCorePower! / ( 2.0 * PI * conductivityIteration ) * log ( claddingOuterRadius / claddingInnerRadius )
            conductivityIteration = fifteenFifteenTitanium.calculateConductivity(fifteenFifteenTitanium.outerAverageTemperature! + 0.5 * deltaCheck! )
            tolerance = abs ( deltaCheck! - deltaTest! )
        }
        fifteenFifteenTitanium.innerAverageTemperature = fifteenFifteenTitanium.outerAverageTemperature! + deltaCheck!
        fifteenFifteenTitanium.middleAverageTemperature = 0.5 * ( fifteenFifteenTitanium.innerAverageTemperature! + fifteenFifteenTitanium.outerAverageTemperature! )
        fifteenFifteenTitanium.conductivity = conductivityIteration
    }
    
    func calculateFuelOuterTemperatureByIterations() {
        var tolerance = 1.0
        var conductivityIteration = helium.gapConductivity!
        var deltaTest: Double?
        var deltaCheck: Double?
        while tolerance > 1e-6 {
            deltaTest = linearCorePower! / ( 2.0 * PI * conductivityIteration ) * log ( claddingInnerRadius / fuelRadius )
            conductivityIteration = helium.calculateConductivity( fifteenFifteenTitanium.innerAverageTemperature! + 0.5 * deltaTest! )
            deltaCheck = linearCorePower! / ( 2.0 * PI * conductivityIteration ) * log ( claddingInnerRadius / fuelRadius )
            conductivityIteration = helium.calculateConductivity( fifteenFifteenTitanium.innerAverageTemperature! + 0.5 * deltaCheck! )
            tolerance = abs ( deltaCheck! - deltaTest! )
        }
        plutoniumZirconiumNitride.outerAverageTemperature = fifteenFifteenTitanium.innerAverageTemperature! + deltaCheck!
        helium.gapConductivity = conductivityIteration
    }
    
    func calculateFuelCenterTemperatureByIterations() {
        var tolerance = 1.0
        var conductivityIteration = plutoniumZirconiumNitride.conductivity!
        var deltaTest: Double?
        var deltaCheck: Double?
        while tolerance > 1e-6 {
            deltaTest = linearCorePower! / ( 4.0 * PI * conductivityIteration )
            conductivityIteration = plutoniumZirconiumNitride.calculateConductivity( plutoniumZirconiumNitride.outerAverageTemperature! + 0.5 * deltaTest! )
            deltaCheck = linearCorePower! / ( 4.0 * PI * conductivityIteration )
            conductivityIteration = plutoniumZirconiumNitride.calculateConductivity( plutoniumZirconiumNitride.outerAverageTemperature! + 0.5 * deltaCheck! )
            tolerance = abs ( deltaCheck! - deltaTest! )
        }
        plutoniumZirconiumNitride.centerAverageTemperature = plutoniumZirconiumNitride.outerAverageTemperature! + deltaCheck!
        plutoniumZirconiumNitride.effectiveTemperature = 0.5 * ( plutoniumZirconiumNitride.centerAverageTemperature! + plutoniumZirconiumNitride.outerAverageTemperature! )
        plutoniumZirconiumNitride.conductivity = conductivityIteration
    }
    
    // Function to save output variables.
    func saveOutput() {
        output.time += [time]
        output.power += [neutronPopulation!]
        output.massFlow += [lead.coreMassFlow!/lead.initialCoreMassFlow!]
        output.reactivity += [reactivity!/pcm]
        output.coolantReactivity += [coolantReactivity!/pcm]
        output.radialReactivity += [radialReactivity!/pcm]
        output.axialReactivity += [axialReactivity!/pcm]
        output.fuelCenterTemperature += [plutoniumZirconiumNitride.centerAverageTemperature!]
        output.fuelOuterTemperature += [plutoniumZirconiumNitride.outerAverageTemperature!]
        output.claddingInnerTemperature += [fifteenFifteenTitanium.innerAverageTemperature!]
        output.claddingOuterTemperature += [fifteenFifteenTitanium.outerAverageTemperature!]
        output.coolantInletTemperature += [lead.coreInletTemperature!]
        output.coolantOutletTemperature += [lead.coreOutletTemperature!]
        output.coolantHotlegTemperature += [lead.hotlegAverageTemperature!]
        output.coolantColdlegTemperature += [lead.coldlegAverageTemperature!]
        //print("\(output.time)  np: \(output.power)  mf: \(output.massFlow)  pcm: \(output.reactivity)  \(output.coolantReactivity) \(output.radialReactivity) \(output.axialReactivity)  K: fuel \(output.fuelCenterTemperature) \(output.fuelOuterTemperature) \(output.claddingInnerTemperature)  clad \(output.claddingOuterTemperature) \(output.coolantInletTemperature)  fuel \(output.coolantOutletTemperature) \(output.coolantHotlegTemperature) \(output.coolantColdlegTemperature)")

    }
    
    // Function to run transient
    func runTransient ( initialTime: Double, maxTime: Double ) {

        // Calculate needed number of steps
        // let totalNumberHydraulicSteps = round ( maxTime / hydraulicTimeStep )
        // let totalNumberNeutronicSteps = round ( maxTime / neutronicTimeStep )
        
        var numberHydraulicSteps = 0
        // var numberNeutronicSteps = 0
        
        // Build up accident conditions
        switch status {
        case 1:
            reactivityInsertionRate = reactivityInsertion! * neutronicTimeStep / rampInterval!
        case 2:
            lossHeatSinkRate = steamGeneratorPowerLossFraction! * lead.steamGeneratorDeltaTemperature! * hydraulicTimeStep / rampInterval!
        default:
            break
        }
        
        // Timing
        let startInstant = NSDate()
        
        time = initialTime
        
        // When the simulation starts, the reactor status is always in an accident.
        printingTime = time + printingTimeStep
        while time <= (maxTime*0.999) {
            
            let intervalInstant = NSDate()
            
            ++numberHydraulicSteps
            
            if time > rampInterval! {
                status = 0
            }
            
            updateThermalHydraulics()
            solveRungeKutta()  // Time is advanced in this loop
            
            // Print only at given intervals.
            
            if time >= printingTime {
                printingTime += printingTimeStep
                let timePrint = round(100000*time)/100000
                let neutronPopulationPrint = round(100000*neutronPopulation!)/100000
                let massFlowPrint = round(100000*lead.coreMassFlow!/lead.initialCoreMassFlow!)/100000
                let reactivityPrint = round(1000000*reactivity!/pcm)/1000000
                let axialReactivityPrint = round(1000000*axialReactivity!/pcm)/1000000
                let coolantReactivityPrint = round(1000000*coolantReactivity!/pcm)/1000000
                let radialReactivityPrint = round(1000000*radialReactivity!/pcm)/1000000
                let leadInletTemperaturePrint = round(1000*lead.coreInletTemperature!)/1000
                let leadOutletTemperaturePrint = round(1000*lead.coreOutletTemperature!)/1000
                let leadCoreAverageTemperaturePrint = round(1000*lead.coreAverageTemperature!)/1000
                let cladOuterTemperaturePrint = round(1000*fifteenFifteenTitanium.outerAverageTemperature!)/1000
                let cladInnerTemperaturePrint = round(1000*fifteenFifteenTitanium.innerAverageTemperature!)/1000
                let fuelOuterTemperaturePrint = round(1000*plutoniumZirconiumNitride.outerAverageTemperature!)/1000
                let fuelCenterTemperaturePrint = round(1000*plutoniumZirconiumNitride.centerAverageTemperature!)/1000
                let fuelEffectiveTemperaturePrint = round(1000*plutoniumZirconiumNitride.effectiveTemperature!)/1000
                let leadHotlegTemperaturePrint = round(1000*lead.hotlegAverageTemperature!)/1000
                let leadColdlegTemperaturePrint = round(1000*lead.coldpoolAverageTemperature!)/1000
                let leadColdpoolTemperaturePrint = round(1000*lead.coldpoolAverageTemperature!)/1000
                
                print("\(timePrint)  np: \(neutronPopulationPrint)  mf: \(massFlowPrint)  pcm: \(reactivityPrint)  \(axialReactivityPrint) \(coolantReactivityPrint) \(radialReactivityPrint)  K: lead \(leadInletTemperaturePrint) \(leadOutletTemperaturePrint) \(leadCoreAverageTemperaturePrint)  clad \(cladOuterTemperaturePrint) \(cladInnerTemperaturePrint)  fuel \(fuelOuterTemperaturePrint) \(fuelCenterTemperaturePrint) \(fuelEffectiveTemperaturePrint)  primary \(leadHotlegTemperaturePrint) \(leadColdlegTemperaturePrint) \(leadColdpoolTemperaturePrint)")
                print("Average time per s: \(intervalInstant.timeIntervalSinceDate(startInstant) / time) s at step = \(numberHydraulicSteps) (Simulation time: \(time) s)")
                
                saveOutput()
            }
            
        }
        
    }
    
    // Update thermal hydraulic parameters during main loop
    func updateThermalHydraulics() {
        
        // Temporary variables to calculate temperature increments.
        let fuelCenterDeTemperature: Double
        let fuelOuterDeTemperature: Double
        let claddingInnerDeTemperature: Double
        let claddingOuterDeTemperature: Double
        let leadHotlegDeTemperature: Double
        let leadColdlegDeTemperature: Double
        let leadCoreInletDeTemperature: Double
        let leadCoreOutletDeTemperature: Double
        
        let fuelAxialDeltaTemperature: Double
        let claddingAverageDeltaTemperature: Double
        let leadAverageDeltaTemperature: Double
        let axialReactivityFeedback: Double
        let coolantReactivityFeedback: Double
        let radialReactivityFeedback: Double
        
        // Calculate hydraulic parameters
        
        lead.coreAverageTemperature = 0.5 * ( lead.coreOutletTemperature! + lead.coreInletTemperature! )
        lead.coreDeltaTemperature = lead.coreOutletTemperature! - lead.coreInletTemperature!
        lead.coreConductivity = lead.calculateConductivity(lead.coreAverageTemperature!)
        lead.coreHeatCapacity = lead.calculateHeatCapacity(lead.coreAverageTemperature!)
        lead.coreViscosity = lead.calculateViscosity(lead.coreAverageTemperature!)
        lead.coreInletDensity = lead.calculateDensity(lead.coreInletTemperature!)
        lead.coreDensity = lead.calculateDensity(lead.coreAverageTemperature!)
        lead.coreOutletDensity = lead.calculateDensity(lead.coreOutletTemperature!)
        lead.coreChannelDensity = lead.coreInletDensity! * ( lowerPlenumHeight + insulationHeight + endplugHeight ) / pinHeight + lead.coreDensity! * fuelHeight / pinHeight + lead.coreOutletTemperature! * ( upperPlenumHeight + insulationHeight + endplugHeight )
        lead.coreMass = coreCoolantVolume * lead.coreDensity!
        lead.coreVelocity = lead.coreMassFlow! / ( coreCoolantArea * lead.coreDensity! )
        lead.coreReynoldsNumber = lead.coreDensity! * lead.coreVelocity! * coreHydraulicDiameter / lead.coreViscosity!
        lead.corePrandtlNumber = lead.coreViscosity! * lead.coreHeatCapacity! / lead.coreConductivity!
        lead.corePecletNumber = lead.coreReynoldsNumber! * lead.corePrandtlNumber!
        lead.coreNusseltNumber = 0.047 * ( 1.0 - exp ( -3.8 * ( pinPitch / claddingOuterDiameter - 1.0 ) ) ) * ( pow ( lead.corePecletNumber!, 0.77 ) + 250.0 )
        
        // Calculate heat transfer coefficient from cladding to coolant
        lead.heatTransferFromCladding = claddingSurface * lead.coreConductivity! * lead.coreNusseltNumber! / coreHydraulicDiameter
        fifteenFifteenTitanium.outerAverageTemperature = lead.coreAverageTemperature! + corePower! / lead.heatTransferFromCladding!
        // other heat transfer coefficients are approximated to remain constant
        
        // Calculate temperature changes during hydraulic time step
        fuelCenterDeTemperature = ( corePower! - plutoniumZirconiumNitride.heatTransfer! * ( plutoniumZirconiumNitride.centerAverageTemperature! - plutoniumZirconiumNitride.outerAverageTemperature! ) ) / ( plutoniumZirconiumNitride.massRoomTemperature! * plutoniumZirconiumNitride.calculateHeatCapacity(plutoniumZirconiumNitride.effectiveTemperature!) * 0.5 ) * hydraulicTimeStep ;
        plutoniumZirconiumNitride.centerAverageTemperature! += fuelCenterDeTemperature
        // print("\(corePower!) \(plutoniumZirconiumNitride.heatTransfer!) \(plutoniumZirconiumNitride.centerAverageTemperature!) \(plutoniumZirconiumNitride.outerAverageTemperature!) \(plutoniumZirconiumNitride.massRoomTemperature!) \(plutoniumZirconiumNitride.calculateHeatCapacity(plutoniumZirconiumNitride.effectiveTemperature!)*0.5) \(hydraulicTimeStep)")
        
        fuelOuterDeTemperature = ( ( plutoniumZirconiumNitride.heatTransfer! * ( plutoniumZirconiumNitride.centerAverageTemperature! - plutoniumZirconiumNitride.outerAverageTemperature! ) - helium.heatTransfer! * ( plutoniumZirconiumNitride.outerAverageTemperature! - fifteenFifteenTitanium.innerAverageTemperature! ) ) / ( helium.coreMass! * helium.heatCapacity * 1e5 ) ) * hydraulicTimeStep ;
        plutoniumZirconiumNitride.outerAverageTemperature! += fuelOuterDeTemperature
        // print("\(plutoniumZirconiumNitride.heatTransfer!) \(plutoniumZirconiumNitride.centerAverageTemperature!) \(plutoniumZirconiumNitride.outerAverageTemperature!) \(helium.heatTransfer!) \(plutoniumZirconiumNitride.outerAverageTemperature!) \(fifteenFifteenTitanium.innerAverageTemperature!) \()")
        
        claddingInnerDeTemperature = ( ( helium.heatTransfer! * ( plutoniumZirconiumNitride.outerAverageTemperature! - fifteenFifteenTitanium.innerAverageTemperature! ) - fifteenFifteenTitanium.heatTransfer! * ( fifteenFifteenTitanium.innerAverageTemperature! - fifteenFifteenTitanium.outerAverageTemperature! ) ) / ( fifteenFifteenTitanium.mass! * fifteenFifteenTitanium.calculateHeatCapacity(fifteenFifteenTitanium.middleAverageTemperature!) ) ) * hydraulicTimeStep ;
        fifteenFifteenTitanium.innerAverageTemperature! += claddingInnerDeTemperature
        
        claddingOuterDeTemperature = ( ( fifteenFifteenTitanium.heatTransfer! * ( fifteenFifteenTitanium.innerAverageTemperature! - fifteenFifteenTitanium.outerAverageTemperature! ) - lead.heatTransferFromCladding! * ( fifteenFifteenTitanium.outerAverageTemperature! - lead.coreAverageTemperature! ) ) / ( fifteenFifteenTitanium.mass! * fifteenFifteenTitanium.calculateHeatCapacity(fifteenFifteenTitanium.middleAverageTemperature!) ) ) * hydraulicTimeStep ;
        fifteenFifteenTitanium.outerAverageTemperature! += claddingOuterDeTemperature
        
        leadCoreOutletDeTemperature = ( ( lead.heatTransferFromCladding! * ( fifteenFifteenTitanium.outerAverageTemperature! - lead.coreAverageTemperature! ) - lead.coreMassFlow! * lead.calculateHeatCapacity(lead.coreAverageTemperature!) * lead.coreDeltaTemperature! ) / ( lead.coreMass! * lead.calculateHeatCapacity(lead.coreAverageTemperature!) ) ) * hydraulicTimeStep ;
        lead.coreOutletTemperature! += leadCoreOutletDeTemperature ;
        
        // Update primary system.
        leadHotlegDeTemperature = lead.coreMassFlow! / lead.hotlegMass! * ( lead.coreOutletTemperature! - lead.hotlegAverageTemperature! ) * hydraulicTimeStep ;
        lead.hotlegAverageTemperature! += leadHotlegDeTemperature
        lead.steamGeneratorInletTemperature = lead.hotlegAverageTemperature!
        
        // Here possible ULOHS is applied by reducing the deltaT in the SG.
        if status == 2 {
            lead.steamGeneratorDeltaTemperature! -= lossHeatSinkRate!
        }
        /* print("\(lead.steamGeneratorDeltaTemperature!) K") */
        
        lead.steamGeneratorOutletTemperature = lead.steamGeneratorInletTemperature! + lead.steamGeneratorDeltaTemperature!
        lead.steamGeneratorAverageTemperature = 0.5 * ( lead.steamGeneratorOutletTemperature! + lead.steamGeneratorInletTemperature! )
        
        leadColdlegDeTemperature = lead.coreMassFlow! / lead.coldlegMass! * ( lead.steamGeneratorOutletTemperature! - lead.coldlegAverageTemperature! ) * hydraulicTimeStep
        lead.coldlegAverageTemperature! += leadColdlegDeTemperature
        leadCoreInletDeTemperature = leadColdlegDeTemperature
        lead.coreInletTemperature! += leadCoreInletDeTemperature
        
        lead.buyoancyHead = g * steamGeneratorElevation * ( lead.calculateDensity(lead.coldlegAverageTemperature!) - lead.calculateDensity(lead.hotlegAverageTemperature!) )
        
        lead.massFlowFactor = sqrt ( lead.buyoancyHead! / lead.initialBuyoancyHead! )
        lead.coreMassFlow = lead.massFlowFactor! * lead.initialCoreMassFlow!
        
        plutoniumZirconiumNitride.effectiveTemperature = 0.5 * ( plutoniumZirconiumNitride.centerAverageTemperature! + plutoniumZirconiumNitride.outerAverageTemperature! )
        fifteenFifteenTitanium.middleAverageTemperature = 0.5 * ( fifteenFifteenTitanium.innerAverageTemperature! + fifteenFifteenTitanium.outerAverageTemperature! )
        lead.coreAverageTemperature = 0.5 * ( lead.coreOutletTemperature! + lead.coreInletTemperature! )
        fuelAxialDeltaTemperature = 0.5 * ( fuelCenterDeTemperature + fuelOuterDeTemperature )
        claddingAverageDeltaTemperature = 0.5 * ( claddingInnerDeTemperature + claddingOuterDeTemperature )
        leadAverageDeltaTemperature = 0.5 * ( leadCoreOutletDeTemperature + leadCoreInletDeTemperature )
        
        axialReactivityFeedback = axialReactivityCoefficient * fuelAxialDeltaTemperature
        coolantReactivityFeedback = coolantReactivityCoefficient * leadAverageDeltaTemperature
        radialReactivityFeedback = radialReactivityCoefficient * leadCoreInletDeTemperature
        
        axialReactivity! += axialReactivityFeedback
        coolantReactivity! += coolantReactivityFeedback
        radialReactivity! += radialReactivityFeedback
        reactivityFeedback = axialReactivity! + coolantReactivity! + radialReactivity!
        
        // current_insertion = current_insertion + reactivity_insertion_rate ;
        // reactivity = current_insertion + reactivity_feedback ;
        
        // Could be good for memory issues to remove the function variables here.
        
    }
    
    // Solve point kinetics equation with the Runge-Kutta (4th order) method
    func solveRungeKutta() {
        
        // Calculate time to stop (after one hydraulic time step)
        let numberSteps = Int(hydraulicTimeStep/neutronicTimeStep)
        var step = 0
        
        while step <= numberSteps {
            
            ++step
            
            // Possibility of UTOP transient
            if status == 1 {
                accumulatedReactivityInsertion! += reactivityInsertionRate!
            }
            
            reactivity = accumulatedReactivityInsertion! + reactivityFeedback!  // Reactivity reduction to be included
            
            let K1: Double
            let K2: Double
            let K3: Double
            let K4: Double
            let population1: Double
            let population2: Double
            let population3: Double
            var L1 = [Double]()
            var L2 = [Double]()
            var L3 = [Double]()
            var L4 = [Double]()
            var concentrations1 = [Double]()
            var concentrations2 = [Double]()
            var concentrations3 = [Double]()
            
            K1 = evaluateKineticEquation(neutronPopulation!, concentrations: precursorConcentrations)
            //print("\(precursorConcentrations[0]) \(precursorConcentrations[1]) \(precursorConcentrations[2]) \(precursorConcentrations[3]) \(precursorConcentrations[4]) \(precursorConcentrations[5]) \(decayRates[0]) \(decayRates[1]) \(decayRates[2]) \(decayRates[3]) \(decayRates[4]) \(decayRates[5])")
            population1 = neutronPopulation! + K1 * 0.5 * neutronicTimeStep
            for ( index, value ) in precursorConcentrations.enumerate() {
                L1 += [ evaluateConcentrationEquation(neutronPopulation!, concentrations: precursorConcentrations, groupIndex: index) ]
                concentrations1 += [ value + L1[index] * 0.5 * neutronicTimeStep ]
            }
            // print("K1 done")
            
            K2 = evaluateKineticEquation(population1, concentrations: concentrations1)
            population2 = neutronPopulation! + K2 * 0.5 * neutronicTimeStep
            for ( index, value ) in precursorConcentrations.enumerate() {
                L2 += [ evaluateConcentrationEquation(population1, concentrations: concentrations1, groupIndex: index) ]
                concentrations2 += [ value + L2[index] * 0.5 * neutronicTimeStep ]
            }
            // print("K2 done")
            
            K3 = evaluateKineticEquation(population2, concentrations: concentrations2)
            population3 = neutronPopulation! + K2 * neutronicTimeStep
            for ( index, value ) in precursorConcentrations.enumerate() {
                // print("\(index), \(precursorConcentrations[index])")
                L3 += [ evaluateConcentrationEquation(population2, concentrations: concentrations2, groupIndex: index) ]
                concentrations3 += [ value + L3[index] * neutronicTimeStep ]
            }
            // print("K3 done")
            
            K4 = evaluateKineticEquation(population3, concentrations: concentrations3)
            for ( index, value ) in precursorConcentrations.enumerate() {
                L4 += [ evaluateConcentrationEquation(population3, concentrations: concentrations3, groupIndex: index) ]
            }
            // print("K4 done")
            
            neutronPopulation! += neutronicTimeStep * ( K1 + 2.0*K2 + 2.0*K3 + K4 ) / 6.0
            for ( index, value ) in precursorConcentrations.enumerate() {
                precursorConcentrations[index] += neutronicTimeStep * ( L1[index] + 2.0*L2[index] + 2.0*L3[index] + L4[index] ) / 6.0
            }
            
            corePower = initialCorePower! * neutronPopulation! ;
            linearCorePower = corePower! / ( Double (numberCorePins) * fuelHeight ) ;
            
        }
        time += hydraulicTimeStep
        
        // Could be good for memory issues to remove the function variables here.
    }
    
    // Function F(y,z) - One-group point kinetic equation
    // dn(t)/dt = (rho-beta_eff)/LAMBDA * n(t) + sum(lambda_i*c_i(t))
    func evaluateKineticEquation ( population: Double, concentrations: [Double] ) -> Double {
        
        var populationDerivative: Double
        populationDerivative = ( reactivity! - betaEffective ) / neutronGenerationTime * population ;
        // print(" \(populationDerivative) \(reactivity) \(betaEffective) \(neutronGenerationTime) \(population) \(concentrations[0]) \(concentrations[1]) \(concentrations[2]) \(concentrations[3]) \(concentrations[4]) \(concentrations[5]) \(decayRates[0]) \(decayRates[1]) \(decayRates[2]) \(decayRates[3]) \(decayRates[4]) \(decayRates[5])")
        
        for ( index, value ) in decayRates.enumerate() {
            // print("\(index), \(concentrations[index])")
            populationDerivative += value * concentrations[index]
            // print("\(populationDerivative) \(value*concentrations[index])")
        }
        
        
        return populationDerivative
    }
    
    // Function G(y,z) - Delayed neutron precursor equations
    // dc_i(t)/dt = beta_i/LAMBDA * n(t) - lambda__i * c_i(t)
    func evaluateConcentrationEquation ( population: Double, concentrations: [Double], groupIndex: Int ) -> Double {
        
        var concentrationDerivative: Double
        concentrationDerivative = delayedNeutronFractions[groupIndex] / neutronGenerationTime * population - decayRates[groupIndex] * concentrations[groupIndex]
        return concentrationDerivative
        
    }
    
}
