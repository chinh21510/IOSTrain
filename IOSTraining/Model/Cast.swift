//
//  CastRootClass.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on January 16, 2021

import Foundation
import SwiftyJSON


class Cast : NSObject, NSCoding{

    var adult : Bool!
    var castId : Int!
    var character : String!
    var creditId : String!
    var gender : Int!
    var id : Int!
    var knownForDepartment : String!
    var name : String!
    var order : Int!
    var originalName : String!
    var popularity : Float!
    var profilePath : String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        adult = json["adult"].boolValue
        castId = json["cast_id"].intValue
        character = json["character"].stringValue
        creditId = json["credit_id"].stringValue
        gender = json["gender"].intValue
        id = json["id"].intValue
        knownForDepartment = json["known_for_department"].stringValue
        name = json["name"].stringValue
        order = json["order"].intValue
        originalName = json["original_name"].stringValue
        popularity = json["popularity"].floatValue
        profilePath = json["profile_path"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adult != nil{
            dictionary["adult"] = adult
        }
        if castId != nil{
            dictionary["cast_id"] = castId
        }
        if character != nil{
            dictionary["character"] = character
        }
        if creditId != nil{
            dictionary["credit_id"] = creditId
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if id != nil{
            dictionary["id"] = id
        }
        if knownForDepartment != nil{
            dictionary["known_for_department"] = knownForDepartment
        }
        if name != nil{
            dictionary["name"] = name
        }
        if order != nil{
            dictionary["order"] = order
        }
        if originalName != nil{
            dictionary["original_name"] = originalName
        }
        if popularity != nil{
            dictionary["popularity"] = popularity
        }
        if profilePath != nil{
            dictionary["profile_path"] = profilePath
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
        adult = aDecoder.decodeObject(forKey: "adult") as? Bool
        castId = aDecoder.decodeObject(forKey: "cast_id") as? Int
        character = aDecoder.decodeObject(forKey: "character") as? String
        creditId = aDecoder.decodeObject(forKey: "credit_id") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? Int
        id = aDecoder.decodeObject(forKey: "id") as? Int
        knownForDepartment = aDecoder.decodeObject(forKey: "known_for_department") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        order = aDecoder.decodeObject(forKey: "order") as? Int
        originalName = aDecoder.decodeObject(forKey: "original_name") as? String
        popularity = aDecoder.decodeObject(forKey: "popularity") as? Float
        profilePath = aDecoder.decodeObject(forKey: "profile_path") as? String
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if adult != nil{
            aCoder.encode(adult, forKey: "adult")
        }
        if castId != nil{
            aCoder.encode(castId, forKey: "cast_id")
        }
        if character != nil{
            aCoder.encode(character, forKey: "character")
        }
        if creditId != nil{
            aCoder.encode(creditId, forKey: "credit_id")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if knownForDepartment != nil{
            aCoder.encode(knownForDepartment, forKey: "known_for_department")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if order != nil{
            aCoder.encode(order, forKey: "order")
        }
        if originalName != nil{
            aCoder.encode(originalName, forKey: "original_name")
        }
        if popularity != nil{
            aCoder.encode(popularity, forKey: "popularity")
        }
        if profilePath != nil{
            aCoder.encode(profilePath, forKey: "profile_path")
        }

    }

}

