//
//  UdaityClient.swift
//  OnTheMap
//
//  Created by Hao Wu on 03.06.19.
//  Copyright © 2019 Hao Wu. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var uniqueKey = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case signUp
        case getPublicUserData
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            case .signUp: return "https://auth.udacity.com/sign-up"
            case .getPublicUserData: return Endpoints.base + "/users/\(Auth.uniqueKey)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, response: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = body
        do {
            request.httpBody =  try JSONEncoder().encode(body)
        } catch {
            print("encoder fail")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String,completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: UdacityAccount(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.login.url, response: LoginResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.uniqueKey = response.account.key
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getPublicUserData(uniqueKey: String, completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getPublicUserData.url, response: PublicUser.self) { (response, error) in
            if let response = response {
                OnTheMapClient.StudentLocation.firstName = response.firstName
                OnTheMapClient.StudentLocation.lastName = response.lastName
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
        
    }
    
}
