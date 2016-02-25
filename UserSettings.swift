//
//  UserSettings.swift
//  MAXSIMA Simulator
//
//  Created by Luca Messina on 24/02/16.
//  Copyright © 2016 KTH Royal Institute of Technology. All rights reserved.
//

// Class to handle the user-defined settings.

import Foundation

/*
enum Reactors: Int {
    case Sealer = 1
    case Alfred
    case Electra
    case Myrrha
    case undefined
}
*/

class UserSettings: NSObject, NSCoding {
    
    // MARK: Properties
    
    var selectedReactor: String
    var userEmailAddress: String
    var accidentType: Int
    var reactivityInsertionFractionBeta: Double?
    var steamGeneratorPowerLoss: Double?
    var reactivityReduction: Double?
    var numberFailedSteamGeneratorsOvercooling: Int?
    var rampInterval: Double
    var transientDuration: Double
    
    var reactivityCoefficients = [Double]()
    var reactivityMinimumValues = [Double]()
    var reactivityMaximumValues = [Double]()

    let defaultReactivityInsertionFractionBeta = 0.2
    let defaultSteamGeneratorPowerLoss = 20.0
    let defaultReactivityReduction = -1000.0
    let defaultNumberFailedSteamGeneratorsOvercooling = 1
    let defaultRampInterval = 1.0
    let defaultTransientDuration = 1800.0
    
    let defaultReactivityCoefficients = [ 0.0, -0.43, -1.54, -0.70 ]
    
    let defaultReactivityMinimumValues = [ -2000.0, -1.0, -2.0, -2.0 ]
    let defaultReactivityMaximumValues = [ 500.0, 1.0, 0.0, 0.0 ]
    
    // MARK: Archiving Paths

    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("userSettings")

    // MARK: Types
    
    struct PropertyKey {
        static let reactorKey = "reactor"
        static let emailKey = "email"
        static let accidentKey = "accident"
        static let reactivityInsertionKey = "reactivityInsertion"
        static let steamGeneratorPowerLossKey = "steamGeneratorPowerLoss"
        static let reactivityReductionKey = "reactivityReduction"
        static let failedSteamGeneratorsKey = "failedSteamGenerators"
        static let rampIntervalKey = "rampInterval"
        static let transientKey = "transient"
        static let reactivityKey = "reactivity"
    }
    
    // MARK: Initialization
    
    init (reactorName: String) {
        
        // Assign reactor type
        selectedReactor = reactorName
        
        /*
        switch reactorName {
        case "Sealer":
            selectedReactor = .Sealer
        case "Alfred":
            selectedReactor = .Alfred
        case "Electra":
            selectedReactor = .Electra
        case "Myrrha":
            selectedReactor = .Myrrha
        default:
            selectedReactor = .undefined
        }
        */
        
        userEmailAddress = ""
        accidentType = 0
        
        // Default values
        reactivityInsertionFractionBeta = defaultReactivityInsertionFractionBeta
        steamGeneratorPowerLoss = defaultSteamGeneratorPowerLoss
        reactivityReduction = defaultReactivityReduction
        numberFailedSteamGeneratorsOvercooling = defaultNumberFailedSteamGeneratorsOvercooling
        rampInterval = defaultRampInterval
        transientDuration = defaultTransientDuration

        reactivityCoefficients = defaultReactivityCoefficients
        reactivityMinimumValues = defaultReactivityMinimumValues
        reactivityMaximumValues = defaultReactivityMaximumValues
        
        super.init()

    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(selectedReactor, forKey: PropertyKey.reactorKey)
        aCoder.encodeObject(userEmailAddress, forKey: PropertyKey.emailKey)
        aCoder.encodeInteger(accidentType, forKey: PropertyKey.accidentKey)
        aCoder.encodeDouble(reactivityInsertionFractionBeta!, forKey: PropertyKey.reactivityInsertionKey)
        aCoder.encodeDouble(steamGeneratorPowerLoss!, forKey: PropertyKey.steamGeneratorPowerLossKey)
        aCoder.encodeDouble(reactivityReduction!, forKey: PropertyKey.reactivityReductionKey)
        aCoder.encodeInteger(numberFailedSteamGeneratorsOvercooling!, forKey: PropertyKey.failedSteamGeneratorsKey)
        aCoder.encodeDouble(rampInterval, forKey: PropertyKey.rampIntervalKey)
        aCoder.encodeDouble(transientDuration, forKey: PropertyKey.transientKey)
        aCoder.encodeObject(reactivityCoefficients, forKey: PropertyKey.reactivityKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let selectedReactor = aDecoder.decodeObjectForKey(PropertyKey.reactorKey) as! String
        let userEmailAddress = aDecoder.decodeObjectForKey(PropertyKey.emailKey) as! String
        let accidentType = aDecoder.decodeIntegerForKey(PropertyKey.accidentKey)
        let reactivityInsertionFractionBeta = aDecoder.decodeDoubleForKey(PropertyKey.reactivityInsertionKey)
        let steamGeneratorPowerLoss = aDecoder.decodeDoubleForKey(PropertyKey.steamGeneratorPowerLossKey)
        let reactivityReduction = aDecoder.decodeDoubleForKey(PropertyKey.reactivityReductionKey)
        let numberFailedSteamGeneratorsOvercooling = aDecoder.decodeIntegerForKey(PropertyKey.failedSteamGeneratorsKey)
        let rampInterval = aDecoder.decodeDoubleForKey(PropertyKey.rampIntervalKey)
        let transientDuration = aDecoder.decodeDoubleForKey(PropertyKey.transientKey)
        let reactivityCoefficients = aDecoder.decodeObjectForKey(PropertyKey.reactivityKey) as! [Double]
        
        // Must call designated initilizer.
        self.init(reactorName: selectedReactor)
        self.userEmailAddress = userEmailAddress
        self.accidentType = accidentType
        self.reactivityInsertionFractionBeta = reactivityInsertionFractionBeta
        self.steamGeneratorPowerLoss = steamGeneratorPowerLoss
        self.reactivityReduction = reactivityReduction
        self.numberFailedSteamGeneratorsOvercooling = numberFailedSteamGeneratorsOvercooling
        self.rampInterval = rampInterval
        self.transientDuration = transientDuration
        self.reactivityCoefficients = reactivityCoefficients
        
    }
    
}