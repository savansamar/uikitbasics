import Foundation

@objc(StudentListWrapper)

class UsersListWrapper: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true

    var users: [User]

    init(users: [User]) {
        self.users = users
    }

    required convenience init?(coder: NSCoder) {
        guard let data = coder.decodeObject(forKey: "users") as? Data,
              let decoded = try? JSONDecoder().decode([User].self, from: data) else {
            return nil
        }
        self.init(users: decoded)
    }

    func encode(with coder: NSCoder) {
        let data = try? JSONEncoder().encode(users)
        coder.encode(data, forKey: "users")
    }
}
