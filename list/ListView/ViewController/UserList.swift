import UIKit


extension ViewController: UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let department = viewModel.sortedDepartments[indexPath.section]
        let usersInSection = viewModel.isSearching
            ? viewModel.filteredUsersByDepartment[department]
            : viewModel.usersByDepartment[department]

        guard let user = usersInSection?[indexPath.row] else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let userVC = storyboard.instantiateViewController(withIdentifier: "userview") as? UserViewController {
            userVC.existingUser = user
            viewModel.groupUsersByDepartment()
            tableView.reloadData()
            navigationController?.pushViewController(userVC, animated: true)
        }
    }
    
}


extension ViewController: UITableViewDataSource {

    //Tells the UITableView how many sections there will be.
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sortedDepartments.count
    }

    //Tells how many rows (users) should be displayed in a particular section (department).
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let department = viewModel.sortedDepartments[section]
//        return viewModel.usersByDepartment[department]?.count ?? 0
        
        let department = viewModel.sortedDepartments[section]
            let usersInSection = viewModel.isSearching
                ? viewModel.filteredUsersByDepartment[department]
                : viewModel.usersByDepartment[department]
            
            return usersInSection?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let department = viewModel.sortedDepartments[indexPath.section]
        let usersInSection = viewModel.isSearching
              ? viewModel.filteredUsersByDepartment[department]
              : viewModel.usersByDepartment[department]
          
        let user = usersInSection?[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = user?.name
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sortedDepartments[section]
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let department = viewModel.sortedDepartments[indexPath.section]
                let usersInSection = viewModel.isSearching
                    ? viewModel.filteredUsersByDepartment[department]
                    : viewModel.usersByDepartment[department]
                
                guard let user = usersInSection?[indexPath.row],
                      let index = viewModel.indexOfUser(matching: user.email) else {
                    return
                }

                // Delete from view model
                viewModel.deleteUser(at: index)

                // Refresh table
                tableView.reloadData()
            }
        }
    
    
    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
}
