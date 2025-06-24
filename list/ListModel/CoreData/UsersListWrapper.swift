import Foundation

@objc(StudentListWrapper)


class UsersListWrapper: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    var users: [User]

    init(users: [User]) {
        self.users = users
    }

    func encode(with coder: NSCoder) {
        do {
            let encodedData = try JSONEncoder().encode(users)
            coder.encode(encodedData, forKey: "users")
        } catch {
            print("❌ Failed to encode users: \(error)")
        }
    }

    required init?(coder: NSCoder) {
        do {
            if let data = coder.decodeObject(forKey: "users") as? Data {
                self.users = try JSONDecoder().decode([User].self, from: data)
            } else {
                self.users = []
            }
        } catch {
            print("❌ Failed to decode users: \(error)")
            self.users = []
        }
    }
}

//class UsersListWrapper: NSObject, NSSecureCoding {
//    static var supportsSecureCoding: Bool = true
//
//    var users: [User]
//
//    init(users: [User]) {
//        self.users = users
//    }
//
//    required convenience init?(coder: NSCoder) {
//        guard let data = coder.decodeObject(forKey: "users") as? Data,
//              let decoded = try? JSONDecoder().decode([User].self, from: data) else {
//            return nil
//        }
//        self.init(users: decoded)
//    }
//
//    func encode(with coder: NSCoder) {
//        let data = try? JSONEncoder().encode(users)
//        coder.encode(data, forKey: "users")
//    }
//}
