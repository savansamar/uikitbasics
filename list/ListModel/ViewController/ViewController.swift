
import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView : UITableView!
    
    @IBOutlet weak var header: Header!
    @IBOutlet weak var addButtonView: UIButton!
    @IBOutlet weak var search: UISearchBar!
    
    let viewModel = UserViewModel.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        header.showAddButton.isHidden = true
        updateUIBasedOnUsers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUIBasedOnUsers()
        tableView.reloadData()
    }
    
    private func updateUIBasedOnUsers() {
        UserViewModel.shared.loadUsersFromCoreData()
        
        let hasUsers = !viewModel.users.isEmpty
        view.backgroundColor = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)
        
        search.searchBarStyle = .minimal
        search.backgroundImage = UIImage()
        search.backgroundColor = .clear
        search.barTintColor = .clear
        
        // Customize the input field inside
        if let textField = search.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.textColor = .black
            textField.tintColor = .white
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search...",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            textField.layer.cornerRadius = 8
            textField.clipsToBounds = true
        }
        
        header.labelTitle.text = "Users"
        header.showAddButton.backgroundColor = .red
        header.showBackButton.backgroundColor = .white
        header.showAddButton.clipsToBounds = true 
        header.showAddButton.layer.cornerRadius = 8
        header.showBackButton.tintColor = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)
        header.showBackButton.isHidden = !hasUsers
        addButtonView.isHidden = hasUsers
           header.onAddTapped = { [weak self] in
               self?.navigate()
           }
        
        tableView.isHidden = !hasUsers
        viewModel.groupUsersByDepartment()
        tableView.reloadData()
    }
    
    @IBAction func onAdd(_ sender: UIButton) {
        navigate()
    }

    @objc func navigate(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let userVC = storyboard.instantiateViewController(withIdentifier: "userview") as? UserViewController {
            navigationController?.pushViewController(userVC, animated: true)
        }
    }

}

