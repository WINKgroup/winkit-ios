//
//  WKLocationHelper.swift
//  CityNews
//
//  Created by Rico Crescenzio on 23/11/16.
//  Copyright © 2016 Wink. All rights reserved.
//

import CoreLocation
import Alamofire

/// The different result returned when calling `getCurrentLocation(completion:)` from `WKLocationHelper`.
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

/// The different error that can occur when calling `getAddress(by:language:completion:)` from `WKLocationHelper`.
public enum WKLocationError: WKError {
    
    /// When GoogleMaps API doesn't return any address, because you passed
    /// coordinates that don't point into any street.
    case noResult
    
    /// An internal error occurred. Please contact developer.
    case unknown
}

/// The closure called when `getCurrentLocation(completion:)` from `WKLocationHelper ends its task.
public typealias LocationCallback = (_ result: LocationResult)->Void

/// The closure called when `getAddress(by:language:completion:)` from `WKLocationHelper ends its task.
public typealias AddressCallback = (Resource<GoogleLocation, WKLocationError>) -> Void

/// This class simplify the usage of the gps to get the user current location or to
/// get an address from a `CLLocation` by using [Google Maps Geocoding API](https://developers.google.com/maps/documentation/geocoding/intro).
/// The picker will also handle for you the permission for the localization usage.
open class WKLocationHelper: NSObject {
    
    fileprivate static let mapsURL = URL(string: "https://maps.googleapis.com/maps/api/geocode/json")!
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var callback: LocationCallback?
    
    // MARK: - Properties
    
    /// The current request of the `getAddress(by:language:completion:)`. Useful if you want to cancel request.
    fileprivate(set) public var currentRequest: DataRequest?
    
    // MARK: - Methods
    
    /// Get your current location only once.
    ///
    /// - Parameter completion: A closure called when a location is found, not found or an error occurred.
    ///                         Check `LocationResult` for all cases.
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
    
    // MARK: - CLLocationManagerDelegate
    
    /// Automatically called from the `CLLocationManager`. You don't have to call it.
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locationManager.location {
            callback?(.found(location))
        } else {
            callback?(.notFound)
        }
        
        locationManager.stopUpdatingLocation()
    }

}
