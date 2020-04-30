//
//  WorkoutController.swift
//  Clamtown Crossfit
//
//  Created by scott harris on 4/30/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation

class WorkoutController {
    var workouts: [Workout] = []
    
    func getAllWorkouts(completion: @escaping () -> Void) {
        FireBaseAPIClient.shared.fetchAllWorkouts { (workouts, error) in
            if error == nil {
                if let workouts = workouts {
                    self.workouts = workouts
                    completion()
                }
            }
        }
    }
    
}
