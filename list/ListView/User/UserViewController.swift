

import UIKit
import PhotosUI

class UserViewController: UIViewController {
    
    //Props
    var existingUser: User?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userAge: UITextField!
    @IBOutlet weak var userDOB: UITextField!
    @IBOutlet weak var userDepartment: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitStyle: UIButton!
    @IBOutlet weak var gallery: UICollectionView!
    
    
    private let datePicker = UIDatePicker()
    private let departmentPicker = UIPickerView()
  
    let viewModel = UserViewModel.shared
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad()
    }
    
    
    @IBAction func onSubmit(_ sender: Any) {
        onSubmit()
    }
    
    
}

extension UserViewController {
    
    private func configureHeaderLabel() {
        label.text = "Registered and Track User With Us"
           label.font = UIFont.boldSystemFont(ofSize: 28)
           label.textColor = .white
           label.numberOfLines = 2
           label.lineBreakMode = .byWordWrapping
           label.translatesAutoresizingMaskIntoConstraints = false
        
    }

    private func setupHeaderConstraints() {
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6)
            ])
    }
    
    
    private func configureTextFields() {
        [userName, userEmail, userAge, userDOB].forEach {
            $0?.font = .systemFont(ofSize: 16)
            $0?.textColor = .darkGray
            $0?.borderStyle = .roundedRect
            $0?.adjustsFontSizeToFitWidth = true
            $0?.clearButtonMode = .whileEditing
        }
        
        userName.placeholder = "Enter Name"
        userName.textContentType = .name
        
        userEmail.placeholder = "Enter Email"
        userEmail.textContentType = .emailAddress
        userEmail.keyboardType = .emailAddress
        
        userAge.placeholder = "Enter Age"
        userAge.keyboardType = .numberPad
        userAge.isUserInteractionEnabled = false
        
        userDOB.placeholder = "Enter Date of Birth"
        userDOB.tintColor = .clear
        
        userDepartment.placeholder = "Select Department"
        userDepartment.tintColor = .clear
        
        submitStyle.isEnabled = false
        submitStyle.alpha = 0.5
        submitStyle.layer.cornerRadius = 8
        submitStyle.clipsToBounds = true
        
        submitStyle.backgroundColor = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0)
        submitStyle.setTitleColor(.white, for: .normal) // White text
        
    }
    
    private func setupDOBField() {
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        userDOB.inputView = datePicker
        userDOB.inputAccessoryView = createToolbar()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let isValid = viewModel.isFormValid(
            name: userName.text ?? "",
            email: userEmail.text ?? "",
            dob: userDOB.text ?? "",
            department: userDepartment.text ?? ""
        )

        submitStyle.isEnabled = isValid
        submitStyle.alpha = isValid ? 1.0 : 0.5
    }
    
    func onViewDidLoad(){
        gallery.delegate = self
        gallery.dataSource = self
        
        configureTextFields()
        setupDOBField()
        configureHeaderLabel()
        setupHeaderConstraints()
        setupDepartmentPicker()
        handelParams()
        
        if existingUser != nil {
               handelParams() // Load old images for editing
           } else {
               viewModel.loadGalleryItems() // 👈 Reset for new user
           }
        
        [userName, userEmail, userDOB, userDepartment].forEach {
            $0?.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    
    func handelParams(){
        if let user = existingUser {
            userName.text = user.name
            userEmail.text = user.email
            userDOB.text = user.dob
            userAge.text = "\(user.age)"
            userDepartment.text = user.department
            viewModel.userGalleryArray = user.gallery ?? []
            viewModel.userGalleryArray.insert(UserGallery(url: "", showAdd: true,fileName: ""), at: 0)
            
            gallery.reloadData()

            // Enable the button since form is already valid
            submitStyle.isEnabled = true
            submitStyle.alpha = 1.0
        }
    }
    
    @objc private func confirmDateSelection() {
        if userDOB.isFirstResponder {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            userDOB.text = formatter.string(from: datePicker.date)
            textFieldDidChange(userDOB)

            let age = Calendar.current.dateComponents([.year], from: datePicker.date, to: Date()).year ?? 0
            userAge.text = "\(age)"
            
        } else if userDepartment.isFirstResponder {
            let selectedRow = departmentPicker.selectedRow(inComponent: 0)
            userDepartment.text = viewModel.departments[selectedRow]
            textFieldDidChange(userDepartment)
        }

        view.endEditing(true)
    }
    
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDateSelection))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(confirmDateSelection))
        
        toolbar.setItems([cancel, flexible, done], animated: false)
        return toolbar
    }
    
    @objc private func cancelDateSelection() {
        userDOB.resignFirstResponder()
    }
    
  
    
    private func setupDepartmentPicker() {
        departmentPicker.dataSource = self
        departmentPicker.delegate = self

        userDepartment.inputView = departmentPicker
        userDepartment.inputAccessoryView = createToolbar()
    }
    
    
    func showImagePicker() {
        var config = PHPickerConfiguration()
           config.selectionLimit = 5 
           config.filter = .images

           let picker = PHPickerViewController(configuration: config)
           picker.delegate = self
           present(picker, animated: true)
    }
    
    
    
    func onSubmit() {
        guard
            let name = userName.text, !name.isEmpty,
            let email = userEmail.text, !email.isEmpty,
            let dobString = userDOB.text, !dobString.isEmpty,
            let department = userDepartment.text, !department.isEmpty
        else {
            print("Form incomplete")
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        guard let dobDate = formatter.date(from: dobString) else {
            print("⚠️ Invalid DOB format")
            return
        }
        
        let age = viewModel.calculateAge(from: dobDate)
        let validGallery = viewModel.userGalleryArray.filter { !$0.url.isEmpty && !$0.showAdd }
        let newUser = User(
            name: name,
            email: email,
            dob: dobString,
            age: age,
            department: department,
            gallery: validGallery
        )

       
        if let index = viewModel.indexOfUser(matching: email) {
            viewModel.updateUser(at: index, with: newUser)
            print("✏️ User updated with images: \(validGallery.count)")
        } else {
            viewModel.addUser(
                name: name,
                email: email,
                dob: dobString,
                age: age,
                department: department,
                gallery: validGallery
            )
            print("✅ New user added with images: \(validGallery.count)")
        }
        viewModel.loadGalleryItems()
        navigationController?.popViewController(animated: true)
    }
    
    
}

