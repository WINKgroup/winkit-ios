//
//  WKLocationHelper.swift
//  CityNews
//
//  Created by Rico Crescenzio on 23/11/16.
//  Copyright © 2016 Wink. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

/// The different result returned when calling `getCurrentLocation(completion:)`.
public enum LocationResult {
    
    /// A location has been found.
    case found(CLLocation)
    
    /// No location found.
    case notFound
    
    /// If localization services are disabled.
    case positionDisabled
    
    /// if user has denied authorization.
    case denied
}

/// The different error that can occur when calling `getAddress(by:language:completion:)`.
public enum WKLocationError: WKError {
    
    /// When GoogleMaps API doesn't return any address, because you passed
    /// coordinates that don't point into any street.
    case noResult
    
    /// An internal error occurred. Please contact developer.
    case unknown
}

public typealias LocationCallback = (_ result: LocationResult)->Void
public typealias AddressCallback = (Resource<GoogleLocation, WKLocationError>) -> Void

open class WKLocationHelper: NSObject {
    
    public static let mapsURL = URL(string: "https://maps.googleapis.com/maps/api/geocode/json")!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var callback: LocationCallback?
    
    fileprivate(set) public var currentRequest: DataRequest?
    
    open func getCurrentLocation(completion: @escaping LocationCallback) {
        self.callback = completion
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() != .authorizedWhenInUse && CLLocationManager.authorizationStatus() != .authorizedAlways {
                completion(.denied)
            }

            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        } else {
            completion(.positionDisabled)
        }
    }

    /// This method call the GoogleMaps API to retrieve an address from a `CLLocation` object.
    /// You can specify the language in which the result will be translated.
    ///
    /// - Parameters:
    ///     - location: The `CLLocation` used to get the `GoogleLocation` object.
    ///     - localization: The language in which the result will be translated; if `nil`
    ///                  it will be automatically used the one given by the system, for this
    ///                  reason you tipically don't need to specify this argument.
    ///     - completion: Since this perform a network reqeust, the call is asynchronusly and the completion
    ///                   is called when a result has been retrieved or an error occurred.
    ///
    /// A typycal usage could be:
    ///
    ///     WKLocationHelper().getAddress(by: aLocation) { result in
    ///         switch result {
    ///         case .found(let address):
    ///             // do your stuff with the address
    ///
    ///         case .notFound(let err):
    ///             switch err {
    ///             case .noResult:
    ///                 // no address found
    ///             case .unknown:
    ///                 // internal error
    ///             }
    ///         }
    ///     }
    ///
    open func getAddress(by location: CLLocation, localization: String? = nil, completion: @escaping AddressCallback) {
        var urlRequest = URLRequest(url: WKLocationHelper.mapsURL)
        urlRequest.httpMethod = "GET"
        
        var parameters: [String: Any] = ["latlng" : "\(location.coordinate.latitude),\(location.coordinate.longitude)"]
        
        if let localization = localization {
            parameters["language"] = localization
        } else if let languageCode = (Locale.current as NSLocale).object(forKey: .languageCode) as? String, let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            parameters["language"] = "\(languageCode)-\(countryCode)"
        }
        
        do {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
            if let currentRequest = currentRequest {
                currentRequest.cancel()
            }
            
            currentRequest = SessionManager.default.request(urlRequest).responseCollection(arrayName: "results") { (response: DataResponse<[GoogleLocation]>) in
                switch(response.result) {
                case .success(let addresses):
                    guard let address = addresses.first else {
                        completion(.notFound(.noResult))
                        return
                    }
                    
                    completion(.found(address))
                    
                case .failure(let error):
                    if let error = error as? WKWebError {
                        switch error.errorType {
                        case .jsonSerializingError, .clientError, .serverError:
                            completion(.notFound(.unknown))
                        }
                    }
                    completion(.notFound(.unknown))
                }
            }
            
        } catch {
            print("error in econding parameters")
            completion(.notFound(.unknown))
        }
    }
    
}

extension WKLocationHelper: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locationManager.location {
            callback?(.found(location))
        } else {
            callback?(.notFound)
        }
        
        locationManager.stopUpdatingLocation()
    }

}
