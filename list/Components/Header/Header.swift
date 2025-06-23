////
////  Header.swift
////  list
////
////  Created by MACM72 on 20/06/25.
////
//
//import UIKit
//
//class Header: UIView {
//
//    @IBOutlet weak var continerView: UIView!
//    @IBOutlet weak var labelTitle: UILabel!
//    @IBOutlet weak var onAdd: UIButton!
//    @IBOutlet weak var goBack: UIButton!
//}


import UIKit

class Header: UIView {


    
    // MARK: - Closure
        var onAddTapped: (() -> Void)?
    
    @IBOutlet weak var continerView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var showAddButton: UIButton!
    @IBOutlet weak var showBackButton: UIButton!

    
    @IBAction func onAdd(_ sender: UIButton) {
        print("🟢 Add tapped")
                onAddTapped?()  // Trigger closure
    }
    
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    
    private func commonInit() {
        let nib = UINib(nibName: "Header", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)

        guard let content = continerView else { return }

        // Set background color for the whole header and container
        self.backgroundColor = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1.0) // Dark Orange
        content.backgroundColor = .clear // Optional if you want transparent inside

        content.frame = bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(content)

        content.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: leadingAnchor),
            content.trailingAnchor.constraint(equalTo: trailingAnchor),
            content.bottomAnchor.constraint(equalTo: bottomAnchor),
            content.topAnchor.constraint(greaterThanOrEqualTo: topAnchor)
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        labelTitle.textColor = .white // Title text in white
    }

    // MARK: - Configure Method (Optional)
    func configure(title: String, showAdd: Bool = true, showBack: Bool = true) {
        labelTitle.text = title
        showAddButton.isHidden = !showAdd
        showBackButton.isHidden = !showBack
    }
}
