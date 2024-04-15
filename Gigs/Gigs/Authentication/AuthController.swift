//
//  AuthController.swift
//  Gigs
//
//  Created by Carlos E. Alvarez-Berrios on 4/15/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import Foundation

final class AuthController {
    var bearer: Bearer?
    
    private let baseURL = URL(string: "https://dummyjson.com")!
    private(set) lazy var signupURL = URL(string: "/users/add", relativeTo: baseURL)!
    private(set) lazy var signinURL = URL(string: "/auth/login", relativeTo: baseURL)!
    
    private var task: URLSessionTask?
    
    func signUp(with user: User, completion: @escaping (Error?) -> Void) {
        task?.cancel()
        
        let requestURL = signupURL
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(error)
        }
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error signing up user: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.emanicomputers.Gigs", code: response.statusCode)
                completion(statusCodeError)
            }
            
            completion(nil)
        }
        
        task?.resume()
    }
    
    func signIn(with user: User, completion: @escaping (Error?) -> Void) {
        task?.cancel()
        
        let requestURL = signinURL
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            let userJSON = try encoder.encode(user)
            request.httpBody = userJSON
        } catch {
            NSLog("Error encoding user object: \(error)")
        }
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error signin in user: \(error)")
                completion(error)
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                let statusCodeError = NSError(domain: "com.emanicomputers.Gigs", code: response.statusCode)
                completion(statusCodeError)
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                let noDataError = NSError(domain: "com.emanicomputers.Gigs", code: -1)
                completion(noDataError)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                self.bearer = bearer
            } catch {
                NSLog("Error decoding token: \(error)")
                completion(error)
            }
            
            completion(nil)
        }
        task?.resume()
    }
}
