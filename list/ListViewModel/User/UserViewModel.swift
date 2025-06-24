import Foundation
import UIKit
import CoreData
//
//
//class UserViewModel {
//
//    static let shared = UserViewModel()
//
//    var usersByDepartment: [String: [User]] = [:]
//    var sortedDepartments: [String] = []
//    var filteredUsersByDepartment: [String: [User]] = [:]
//    var isSearching: Bool = false
//    
//    var userGalleryArray: [UserGallery] = []
//        
//
//    let departments = ["Android", "IOS", "React Native"]
//    var selectedDepartmentIndex: Int = 0
//
//    private(set) var users: [User] = []
//
//    private init() {
//        
//        loadGalleryItems()
//    }
//
//    // MARK: - Helpers
//    
//    
//    func loadGalleryItems() {
//       
//        userGalleryArray = [UserGallery(url: "", showAdd: true)]
//    }
//
//    func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: date)
//    }
//
//    func calculateAge(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
//    }
//
//    func departmentName(for index: Int) -> String {
//        return departments[index]
//    }
//
//    func isFormValid(name: String, email: String, dob: String, department: String) -> Bool {
//        return !name.isEmpty && !email.isEmpty && !dob.isEmpty && !department.isEmpty
//    }
//
//
//    func addUser(name: String, email: String, dob: String, age: Int, department: String) {
//        let user = User(name: name, email: email, dob: dob, age: age, department: department)
//        users.append(user)
//        groupUsersByDepartment()
//        saveUsersToCoreData()
//    }
//
//    func updateUser(at index: Int, with updatedUser: User) {
//        guard index >= 0 && index < users.count else {
//            print("⚠️ Invalid index")
//            return
//        }
//        users[index] = updatedUser
//        groupUsersByDepartment()
//        saveUsersToCoreData()
//    }
//
//    func deleteUser(at index: Int) {
//        guard index >= 0 && index < users.count else {
//            print("⚠️ Invalid index")
//            return
//        }
//        users.remove(at: index)
//        groupUsersByDepartment()
//        saveUsersToCoreData()
//    }
//
//    func indexOfUser(matching email: String) -> Int? {
//        return users.firstIndex { $0.email.lowercased() == email.lowercased() }
//    }
//
//    func groupUsersByDepartment() {
//        usersByDepartment = Dictionary(grouping: users, by: { $0.department })
//        usersByDepartment = usersByDepartment.filter { !$0.value.isEmpty }
//        sortedDepartments = departments.filter { usersByDepartment.keys.contains($0) }
//    }
//
//    func searchUsers(with keyword: String) {
//        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
//        guard !trimmed.isEmpty else {
//            isSearching = false
//            groupUsersByDepartment()
//            return
//        }
//
//        isSearching = true
//        let filtered = users.filter {
//            $0.name.lowercased().contains(trimmed) || $0.email.lowercased().contains(trimmed)
//        }
//
//        filteredUsersByDepartment = Dictionary(grouping: filtered, by: { $0.department })
//        filteredUsersByDepartment = filteredUsersByDepartment.filter { !$0.value.isEmpty }
//        sortedDepartments = departments.filter { filteredUsersByDepartment.keys.contains($0) }
//    }
//
// 
//}
//
//
//extension UserViewModel {
//    
//    func loadUsersFromCoreData() {
//        let context = CoreDataManager.shared.context
//        let fetchRequest: NSFetchRequest<UsersDB> = UsersDB.fetchRequest()
//        do {
//            if let result = try context.fetch(fetchRequest).first,
//               let wrapper = result.usersList {
//                self.users = wrapper.users
//                groupUsersByDepartment()
//                print("✅ Loaded users from Core Data")
//            }
//        } catch {
//            print("❌ Load Error:", error)
//        }
//    }
//
//    func saveUsersToCoreData() {
//        let context = CoreDataManager.shared.context
//        let fetchRequest: NSFetchRequest<UsersDB> = UsersDB.fetchRequest()
//        do {
//            let usersWrapper = UsersListWrapper(users: self.users)
//            let usersDB = try context.fetch(fetchRequest).first ?? UsersDB(context: context)
//            usersDB.usersList = usersWrapper
//            CoreDataManager.shared.saveContext()
//            print("✅ Saved users to Core Data")
//        } catch {
//            print("❌ Save Error:", error)
//        }
//    }
//
//    func clearUsersFromCoreData() {
//        let context = CoreDataManager.shared.context
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UsersDB.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        do {
//            try context.execute(deleteRequest)
//            CoreDataManager.shared.saveContext()
//            users.removeAll()
//            groupUsersByDepartment()
//            print("🗑️ Cleared users from Core Data")
//        } catch {
//            print("❌ Clear Error:", error)
//        }
//    }
//
//    
//}


class UserViewModel {

    static let shared = UserViewModel()
    
    var usersByDepartment: [String: [User]] = [:]
    var sortedDepartments: [String] = []
    var filteredUsersByDepartment: [String: [User]] = [:]
    var isSearching: Bool = false
    
    var userGalleryArray: [UserGallery] = []
    let departments = ["Android", "IOS", "React Native"]
    var selectedDepartmentIndex: Int = 0

    private(set) var users: [User] = []

    private init() {
        loadGalleryItems()
        loadUsersFromCoreData()
    }

    // ✅ MARK: - Public Methods
    func loadGalleryItems() {
        userGalleryArray = [UserGallery(url: "", showAdd: true,fileName: "")]
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func calculateAge(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
    }

    func departmentName(for index: Int) -> String {
        return departments[index]
    }

    func isFormValid(name: String, email: String, dob: String, department: String) -> Bool {
        return !name.isEmpty && !email.isEmpty && !dob.isEmpty && !department.isEmpty
    }

    
    func addUser(
        name: String,
        email: String,
        dob: String,
        age: Int,
        department: String,
        gallery: [UserGallery]? = nil // 👈 default value
    ) {
        let validGallery = gallery?.filter { !$0.url.isEmpty } ?? []
        let user = User(
            name: name,
            email: email,
            dob: dob,
            age: age,
            department: department,
            gallery: validGallery
        )
        users.append(user)
        groupUsersByDepartment()
        saveUsersToCoreData()
    }

    func updateUser(at index: Int, with updatedUser: User) {
        guard index >= 0 && index < users.count else { return }

        let validGallery = updatedUser.gallery?.filter { !$0.url.isEmpty } ?? []
        
        let user = User(
            name: updatedUser.name,
            email: updatedUser.email,
            dob: updatedUser.dob,
            age: updatedUser.age,
            department: updatedUser.department,
            gallery: validGallery
        )
        users[index] = user
        groupUsersByDepartment()
        saveUsersToCoreData()
    }
    
    func deleteUser(at index: Int) {
        guard index >= 0 && index < users.count else { return }
        users.remove(at: index)
        groupUsersByDepartment()
        saveUsersToCoreData()
    }

    func indexOfUser(matching email: String) -> Int? {
        return users.firstIndex { $0.email.lowercased() == email.lowercased() }
    }

    func groupUsersByDepartment() {
        usersByDepartment = Dictionary(grouping: users, by: { $0.department })
        sortedDepartments = departments.filter { usersByDepartment.keys.contains($0) }
    }

    func searchUsers(with keyword: String) {
        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else {
            isSearching = false
            groupUsersByDepartment()
            return
        }

        isSearching = true
        let filtered = users.filter {
            $0.name.lowercased().contains(trimmed) || $0.email.lowercased().contains(trimmed)
        }

        filteredUsersByDepartment = Dictionary(grouping: filtered, by: { $0.department })
        sortedDepartments = departments.filter { filteredUsersByDepartment.keys.contains($0) }
    }

    // ✅ MARK: - Core Data
    func loadUsersFromCoreData() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<UsersDB> = UsersDB.fetchRequest()
        do {
            if let result = try context.fetch(fetchRequest).first,
               let wrapper = result.usersList {
                self.users = wrapper.users
                groupUsersByDepartment()
                print("✅ Loaded users from Core Data : \(self.users)")
            }
        } catch {
            print("❌ Load Error:", error)
        }
    }

    func saveUsersToCoreData() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<UsersDB> = UsersDB.fetchRequest()
        do {
            print("users:=====")
            print("users:=====")
            print("users:=====",self.users)
            print("users:=====")
            print("users:=====")
            let usersWrapper = UsersListWrapper(users: self.users)
            let usersDB = try context.fetch(fetchRequest).first ?? UsersDB(context: context)
            usersDB.usersList = usersWrapper
            CoreDataManager.shared.saveContext()
            print("✅ Saved users to Core Data")
        } catch {
            print("❌ Save Error:", error)
        }
    }

    func clearUsersFromCoreData() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UsersDB.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            CoreDataManager.shared.saveContext()
            users.removeAll()
            groupUsersByDepartment()
            print("🗑️ Cleared users from Core Data")
        } catch {
            print("❌ Clear Error:", error)
        }
    }
}
