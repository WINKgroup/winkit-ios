//
//  GoogleLocation.swift
//  CityNews
//
//  Created by Rico Crescenzio on 23/11/16.
//  Copyright © 2016 Wink. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

/// This enum maps the Address component names given as json by Google.
enum AddressComponentType: String {
    
    case streetNumber = "street_number"
    case route = "route"
    case city = "locality"
    case province = "administrative_area_level_2"
    case region = "administrative_area_level_1"
    case country = "country"
    case postalCode = "postal_code"
    
    static var rawValues: [String] {
        return [streetNumber.rawValue, route.rawValue, city.rawValue, province.rawValue, region.rawValue, country.rawValue, postalCode.rawValue]
    }
}

/// The `AddressComponent` is a piece of the whole address information given by google.
/// An address component can have multiple `AddressComponentType`.
class AddressComponent {
    let longName: String
    let shortName: String
    let types: [AddressComponentType]
    
    init(longName: String?, shortName: String?, types: [String]) {
        self.longName = longName ?? ""
        self.shortName = shortName ?? ""
        
        var componentTypes = [AddressComponentType]()
        for type in types {
            if AddressComponentType.rawValues.contains(type) {
                componentTypes.append(AddressComponentType(rawValue: type)!)
            }
        }
        
        self.types = componentTypes
    }
}
extension AddressComponent: Argo.Decodable {
    public static func decode(_ j: JSON) -> Decoded<AddressComponent> {
        return curry(AddressComponent.init)
            <^> j <|? "long_name"
            <*> j <|? "short_name"
            <*> j <|| "types"
    }
}

/// The full object that maps the GoogleMaps API json result.
/// Properties map the Google address components. 
///
/// For more information see [Google Maps geocoding APIs](https://developers.google.com/maps/documentation/geocoding/intro)
open class GoogleLocation {
    
    // MARK: - Properties
    
    /// The Place ID of the location.
    open let placeId: String
    
    /// A string that return an address in the following form: "Via Tor de' Schiavi, 222, 00171 Roma, Italy"
    open let formattedAddress: String
    
    /// The route of the location. i.e: "Via Tor De' Schiavi"
    /// Match the Google key: `route`.
    private(set) open var route: String?
    
    /// The city of the location. i.e: "Rome". 
    /// Match the Google key: `locality`.
    private(set) open var city: String?
    
    /// The province of the location. i.e: "RM"
    /// Match the Google key: `administrative_area_level_2`
    private(set) open var province: String?
    
    /// Match the Google key: `administrative_area_level_1`
    private(set) open var region: String?
    
    /// The country of the location. i.e: "Italy".
    /// Match the Google key: `country`
    private(set) open var country: String?
    
    /// The postal code of the location. i.e: "00171"
    /// Match the Google key: `postal_code`
    private(set) open var postalCode: String?
    
    /// The street number of the location. i.e: "222"
    /// Match the Google key: `street_number`
    private(set) open var streetNumber: String?
    
    init(placeId: String, formattedAddress: String, addressComponents: [AddressComponent]) {
        self.placeId = placeId
        self.formattedAddress = formattedAddress
        
        for component in addressComponents {
            guard let type = component.types.first else { continue }
            
            switch type {
            case .city:
                self.city = component.shortName
            case .country:
                self.country = component.longName
            case .postalCode:
                self.postalCode = component.longName
            case .province:
                self.province = component.shortName
            case .region:
                self.region = component.longName
            case .route:
                self.route = component.longName
            case .streetNumber:
                self.streetNumber = component.longName
            }
        }
    }
    
}

extension GoogleLocation: Argo.Decodable {
    
    // MARK: - Decodable Implementation
    
    public static func decode(_ j: JSON) -> Decoded<GoogleLocation> {
        return curry(GoogleLocation.init)
            <^> j <| "place_id"
            <*> j <| "formatted_address"
            <*> j <|| "address_components"

    }

}
