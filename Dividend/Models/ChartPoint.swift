//
//  ChartPoint.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/20/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import CoreData

class ChartPoint: NSManagedObject, Decodable {
    
    /* Example return in an array of objects
     
     // NEW
     "date": "20190221",
     "minute": "09:50",
     "label": "09:50 AM",
     "high": 143.79,
     "low": 143.71,
     "average": 143.76,
     "volume": 1394,
     "notional": 200401.54,
     "numberOfTrades": 19,
     "marketHigh": 143.81,
     "marketLow": 143.7,
     "marketAverage": 143.767,
     "marketVolume": 20338,
     "marketNotional": 2923926.8128,
     "marketNumberOfTrades": 315,
     "open": 143.73,
     "close": 143.79,
     "marketOpen": 143.7,
     "marketClose": 143.79,
     "changeOverTime": -0.004280430536508298,
     "marketChangeOverTime": -0.0043078073814488225
    */
    
    @NSManaged public var date: String
    @NSManaged public var minute: String
    @NSManaged public var label: String
    @NSManaged public var high: Double
    @NSManaged public var low: Double
    @NSManaged public var average: Double
    @NSManaged public var volume: Int64
    @NSManaged public var notional: Double
    @NSManaged public var numberOfTrades: Int16
    @NSManaged public var marketHigh: Double
    @NSManaged public var marketLow: Double
    @NSManaged public var marketAverage: Double
    @NSManaged public var marketVolume: Int16
    @NSManaged public var marketNotional: Double
    @NSManaged public var marketNumberOfTrades: Int16
    @NSManaged public var open: Double
    @NSManaged public var close: Double
    @NSManaged public var marketOpen: Double
    @NSManaged public var marketClose: Double
    @NSManaged public var changeOverTime: Float
    @NSManaged public var marketChangeOverTime: Float
    @NSManaged public var stock: Stock?
    
    enum CodingKeys: String, CodingKey {
        case date
        case minute
        case label
        case high
        case low
        case average
        case volume
        case notional
        case numberOfTrades
        case marketHigh
        case marketLow
        case marketAverage
        case marketVolume
        case marketNotional
        case marketNumberOfTrades
        case open
        case close
        case marketOpen
        case marketClose
        case changeOverTime
        case marketChangeOverTime
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "ChartPoint", in: CoreDataManager.shared.managedObjectContext) else {
            throw InitializationError.CoreDataError
        }
        self.init(entity: entity, insertInto: CoreDataManager.shared.managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        minute = try container.decode(String.self, forKey: .minute)
        label = try container.decode(String.self, forKey: .label)
        high = try container.decode(Double.self, forKey: .high)
        low = try container.decode(Double.self, forKey: .low)
        average = try container.decode(Double.self, forKey: .average)
        volume = try container.decode(Int64.self, forKey: .volume)
        notional = try container.decode(Double.self, forKey: .notional)
        numberOfTrades = try container.decode(Int16.self, forKey: .numberOfTrades)
        marketHigh = try container.decode(Double.self, forKey: .marketHigh)
        marketLow = try container.decode(Double.self, forKey: .marketLow)
        marketAverage = try container.decode(Double.self, forKey: .marketAverage)
        marketVolume = try container.decode(Int16.self, forKey: .marketVolume)
        marketNotional = try container.decode(Double.self, forKey: .marketNotional)
        marketNumberOfTrades = try container.decode(Int16.self, forKey: .marketNumberOfTrades)
        open = try container.decode(Double.self, forKey: .open)
        close = try container.decode(Double.self, forKey: .close)
        marketOpen = try container.decode(Double.self, forKey: .marketOpen)
        marketClose = try container.decode(Double.self, forKey: .marketClose)
        changeOverTime = try container.decode(Float.self, forKey: .changeOverTime)
        marketChangeOverTime = try container.decode(Float.self, forKey: .marketChangeOverTime)
    }
}
