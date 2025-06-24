import Foundation
import UIKit


class UserViewModel {

    static let shared = UserViewModel()
    var usersByDepartment: [String: [User]] = [:]
    var sortedDepartments: [String] = []
    var filteredUsersByDepartment: [String: [User]] = [:]
    var isSearching: Bool = false
    

    private init() { }

    let departments = ["Android", "IOS", "React Native"]
    var selectedDepartmentIndex: Int = 0

    private(set) var users: [User] = []

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

    func addUser(name: String, email: String, dob: String, age: Int, department: String) {
        let user = User(name: name, email: email, dob: dob, age: age, department: department)
        users.append(user)
    }

    func getAllUsers() -> [User] {
        return users
    }
    
    func isFormValid(name: String, email: String, dob: String, department: String) -> Bool {
        return !name.isEmpty && !email.isEmpty && !dob.isEmpty && !department.isEmpty
    }
    
    
    
    func groupUsersByDepartment() {
        let allUsers = getAllUsers()
        
        // Group users by department
        usersByDepartment = Dictionary(grouping: allUsers, by: { $0.department })
        
        // Remove departments that have no users
        usersByDepartment = usersByDepartment.filter { !$0.value.isEmpty }

        // Keep the sorted department list that only has available departments
        sortedDepartments = departments.filter { usersByDepartment.keys.contains($0) }
    }
   
    func updateUser(at index: Int, with updatedUser: User) {
        guard index >= 0 && index < users.count else {
            print("⚠️ Invalid index")
            return
        }
        
        let oldUser = users[index]
        
        // Update user in main list
        users[index] = updatedUser
        
        // Re-group users to reflect changes in department
        groupUsersByDepartment()
    }
    
    func indexOfUser(matching email: String) -> Int? {
        return users.firstIndex { $0.email.lowercased() == email.lowercased() }
    }
    
    func searchUsers(with keyword: String) {
        let trimmedKeyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard !trimmedKeyword.isEmpty else {
            isSearching = false
            groupUsersByDepartment()  // Reset to full list
            return
        }

        isSearching = true

        let filtered = users.filter {
            $0.name.lowercased().contains(trimmedKeyword) ||
            $0.email.lowercased().contains(trimmedKeyword)
        }

        filteredUsersByDepartment = Dictionary(grouping: filtered, by: { $0.department })
        filteredUsersByDepartment = filteredUsersByDepartment.filter { !$0.value.isEmpty }

        sortedDepartments = departments.filter { filteredUsersByDepartment.keys.contains($0) }
    }
}
