//
//  GigController.swift
//  Gigs
//
//  Created by Carlos E. Alvarez-Berrios on 4/17/24.
//  Copyright © 2024 Emani Computers and Support, LLC. All rights reserved.
//

import Foundation

class GigController {
    
    enum NetworkError: Error {
        case noData
        case noAuthToken
        case serverError(Error)
        case unexpectedStatusCode
        case badDecode
        case badEncode
    }
    
    var gigs = [Gig]()
    
    private let baseURL = URL(string: "https://gigsapi.wiremockapi.cloud/")!
    private(set) lazy var gigsURL = URL(string: "/gigs", relativeTo: baseURL)!
    
    private var task: URLSessionTask?
    
    func getAllGigs(with auth: Bearer, completion: @escaping (Result<[Gig], NetworkError>)-> Void) {
        task?.cancel()
        
        let requestURL = gigsURL
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(auth.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error getting gigs: \(error)")
                completion(.failure(.serverError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.unexpectedStatusCode))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let gigs = try decoder.decode([Gig].self, from: data)
                self.gigs  = gigs
                completion(.success(gigs))
            } catch {
                NSLog("Error decoding gigs data: \(error)")
                completion(.failure(.badDecode))
            }
        }
        
        task?.resume()
        
    }
    
    func createGig(with auth: Bearer, newGig: Gig, completion: @escaping (Result<Gig, NetworkError>) -> Void) {
        task?.cancel()
        
        let requestURL = gigsURL
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(auth.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let newGigData = try encoder.encode(newGig)
            request.httpBody = newGigData
        } catch {
            NSLog("Error encoding gig data: \(error)")
            completion(.failure(.badEncode))
        }
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
        
            if let error = error {
                NSLog("Error creating gig: \(error)")
                completion(.failure(.serverError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.unexpectedStatusCode))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy  = .iso8601
                
                let gig = try decoder.decode(Gig.self, from: data)
                self.gigs.append(newGig)
                completion(.success(newGig))
            } catch {
                NSLog("Error decoding new gig data: \(error)")
                completion(.failure(.badDecode))
            }
            
        }
        
        task?.resume()
    }
}
