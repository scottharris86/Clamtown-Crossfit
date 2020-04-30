//
//  FireBaseAPIClient.swift
//  Clamtown Crossfit
//
//  Created by scott harris on 4/30/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import Foundation


class FireBaseAPIClient {
    let baseURL = URL(string: "https://clamtown-crossfit.firebaseio.com/")!
    
    static let shared = FireBaseAPIClient()
    
    func fetchAllWorkouts(completion: @escaping ([Workout]?, Error?) -> Void) {
        let workoutsURL = baseURL.appendingPathComponent("workouts").appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: workoutsURL) { (data, response, error) in
            if let error = error {
                NSLog("Error from network response: \(error)")
                completion(nil, error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                let error = NSError(domain: "com.clamtowncrossfit", code: 100, userInfo: ["message": "Status code: \(response.statusCode)"])
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "com.clamtowncrossfit", code: 200, userInfo: ["message": "Data was nil"])
                completion(nil, error)
                return
            }
            
            do {
                let workouts = try JSONDecoder().decode([Workout].self, from: data)
                completion(workouts, nil)
                
            } catch {
                NSLog("Error Decoding Json: \(error)")
                completion(nil, error)
                return
            }
            
            
        }.resume()
        
    }
    
    func fetchImage(at url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil)
                return
            }
            
            completion(data)
            return
            
        }.resume()
    }
    
}
