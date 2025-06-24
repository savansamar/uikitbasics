import Foundation

//Codable : it allows your object to be encoded into Data and later decoded back,
//typealias Codable = Encodable & Decodable
//•    Encodable – lets you convert your object into JSON or Data
//•    Decodable – lets you convert JSON or Data into your object

struct User:Codable {
    let name: String
    let email: String
    let dob: String
    let age: Int
    let department: String
    var gallery: [UserGallery]? = nil
}

struct UserGallery:Codable {
    var url: String
    var showAdd: Bool
    var fileName:String
}
