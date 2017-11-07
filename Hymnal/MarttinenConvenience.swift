//
//  MarttinenConvenience.swift
//  Hymnal
//
//  Created by Jacob Marttinen on 4/30/17.
//  Copyright © 2017 Jacob Marttinen. All rights reserved.
//

import UIKit
import Foundation

// MARK: - MarttinenClient (Convenient Resource Methods)

extension MarttinenClient {
    
    // MARK: GET Convenience Methods
    
    func getSchedule(
        completionHandlerForGetSchedule: @escaping (
        _ scheduleRaw: [ScheduleLine],
        _ error: NSError?
        ) -> Void
        ) {
        
        let parameters = [:] as [String:AnyObject]
        
        let _ = taskForGETMethod(Methods.Schedule, parameters: parameters as [String:AnyObject]) { (results, error) in
            var schedule = [ScheduleLine]()
            
            if let error = error {
                completionHandlerForGetSchedule(schedule, error)
            } else {
                func sendError(_ error: String) {
                    let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandlerForGetSchedule(
                        schedule,
                        NSError(domain: "MarttinenClient", code: 1, userInfo: userInfo)
                    )
                }
                
                guard let scheduleArray = results?[MarttinenClient.JSONResponseKeys.Schedule] as? [[String:AnyObject]] else {
                    sendError("Cannot find key '\(MarttinenClient.JSONResponseKeys.Schedule)' in results")
                    return
                }
                
                schedule = ScheduleLine.scheduleFromResults(scheduleArray)
                
                completionHandlerForGetSchedule(schedule, nil)
            }
        }
    }
}
