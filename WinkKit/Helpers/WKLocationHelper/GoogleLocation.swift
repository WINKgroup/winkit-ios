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
public enum AddressComponentType: String {
    case streetNumber = "street_number"
    case route = "route"
    case city = "locality"
    case province = "administrative_area_level_2"
    case region = "administrative_area_level_1"
    case country = "country"
    case postalCode = "postal_code"
    
    public static var rawValues: [String] {
        return [streetNumber.rawValue, route.rawValue, city.rawValue, province.rawValue, region.rawValue, country.rawValue, postalCode.rawValue]
    }
}

/// The `AddressComponent` is a piece of the whole address information given by google.
/// An address component can have multiple `AddressComponentType`.
open class AddressComponent {
    open let longName: String
    open let shortName: String
    open let types: [AddressComponentType]
    
    public init(longName: String?, shortName: String?, types: [String]) {
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
extension AddressComponent: Decodable {
    public static func decode(_ j: JSON) -> Decoded<AddressComponent> {
        return curry(AddressComponent.init)
            <^> j <|? "long_name"
            <*> j <|? "short_name"
            <*> j <|| "types"
    }
}

/// The full object that maps the GoogleMaps API json result.
open class GoogleLocation {
    
    /// The Place ID of the location.
    open let placeId: String
    
    /// A string that return an address in the following form: "Via Tor de' Schiavi, 222, 00171 Roma, Italy"
    open let formattedAddress: String
    
    private(set) open var route: String?
    private(set) open var city: String?
    private(set) open var province: String?
    private(set) open var region: String?
    private(set) open var country: String?
    private(set) open var postalCode: String?
    private(set) open var streetNumber: String?
    
    public init(placeId: String, formattedAddress: String, addressComponents: [AddressComponent]) {
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

extension GoogleLocation: Decodable {
    public static func decode(_ j: JSON) -> Decoded<GoogleLocation> {
        return curry(GoogleLocation.init)
            <^> j <| "place_id"
            <*> j <| "formatted_address"
            <*> j <|| "address_components"

    }

}
