//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by Hao Wu on 05.06.19.
//  Copyright © 2019 Hao Wu. All rights reserved.
//

import Foundation

class OnTheMapClient {
    
    struct StudentLocation {
        static var uniqueKey = UdacityClient.Auth.uniqueKey
        static var firstName = ""
        static var lastName = ""
        static var mapString = ""
        static var mediaURL = ""
        static var latitude = 0.0
        static var longitude = 0.0
        static var objectId = ""
        static var createdAt = ""
        static var updatedAt = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/StudentLocation"
        
        case getStudentsLocation
        case getOnlyStudentLocation
        case postStudentLocation
        case putStudentLocation
        
        var stringValue: String {
            switch self {
            case .getStudentsLocation: return Endpoints.base + "?limit=100&order=-updatedAt"
            case .getOnlyStudentLocation: return Endpoints.base + "?uniqueKey=\(StudentLocation.uniqueKey)"
            case .postStudentLocation: return Endpoints.base
            case .putStudentLocation: return Endpoints.base + "/\(StudentLocation.objectId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                
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
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, response: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
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
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
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
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, response: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
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
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
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
    
    class func putStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
        let putRequest = StudentLocationRequest(uniqueKey: StudentLocation.uniqueKey, firstName: StudentLocation.firstName, lastName: StudentLocation.lastName, mapString: StudentLocation.mapString, mediaURL: StudentLocation.mediaURL, latitude: StudentLocation.latitude, longitude: StudentLocation.longitude)
        
        taskForPUTRequest(url: Endpoints.putStudentLocation.url, response: PUTResponse.self, body: putRequest) { (response, error) in
            if let response = response {
                StudentLocation.updatedAt = response.updatedAt
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func postStudentLocation(completion: @escaping (Bool, Error?) -> Void) {
        let postRequest = StudentLocationRequest(uniqueKey: StudentLocation.uniqueKey, firstName: StudentLocation.firstName, lastName: StudentLocation.lastName, mapString: StudentLocation.mapString, mediaURL: StudentLocation.mediaURL, latitude: StudentLocation.latitude, longitude: StudentLocation.longitude)
        
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, response: PostStudentLocationResponse.self, body: postRequest) { (response, error) in
            if let response = response {
                StudentLocation.objectId = response.objectId
                StudentLocation.createdAt = response.createdAt
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getStudentsLocation(completion: @escaping (StudentsResponse?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentsLocation.url, response: StudentsResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getOnlyStudentLocation(completion: @escaping (OnlyStudentResponse?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getOnlyStudentLocation.url, response: OnlyStudentResponse.self) { (response, error) in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}
