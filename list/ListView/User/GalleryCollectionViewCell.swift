//
//  GalleryCollectionViewCell.swift
//  list
//
//  Created by MACM72 on 24/06/25.
//

import UIKit

protocol GalleryCollectionViewCellDelegate: AnyObject {
    func didTapClose(in cell: GalleryCollectionViewCell)
}


class GalleryCollectionViewCell: UICollectionViewCell {
    
    
    weak var delegate: GalleryCollectionViewCellDelegate?
 
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var addImageView: UIButton!
    @IBOutlet weak var closeButtonView: UIButton!
    
    
    @IBAction func onAddImage(_ sender: UIButton) {
    }
    
    @IBAction func onTapClose(_ sender: UIButton) {
        delegate?.didTapClose(in: self)
    }
    
//    var onCloseTapped: (() -> Void)?
//    
//    
    override public func layoutSubviews() {
        super.layoutSubviews()
        super.layoutIfNeeded()
    }
    
    // Run when collection view cell is initialized by storyboard
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configure(with data: UserGallery) {
        addImageView.isUserInteractionEnabled = false
           if data.showAdd && data.url.isEmpty {
               addImageView.isHidden = false
               closeButtonView.isHidden = true
//               image.image = UIImage(systemName: "plus.circle")
               image.contentMode = .scaleAspectFit
           } else {
               closeButtonView.isHidden = false
               addImageView.isHidden = true
              
               ///
               // Prefer fileName path
                       let pathURL: URL
                       if !data.fileName.isEmpty {
                           pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                               .appendingPathComponent(data.fileName)
                       } else if let fallbackURL = URL(string: data.url) {
                           pathURL = fallbackURL
                       } else {
                           image.image = UIImage(systemName: "photo")
                           image.contentMode = .scaleAspectFit
                           return
                       }

                       if let imageData = try? Data(contentsOf: pathURL) {
                           image.image = UIImage(data: imageData)
                           image.contentMode = .scaleAspectFill
                       } else {
                           print("⚠️ Image not found at: \(pathURL)")
                           image.image = UIImage(systemName: "photo")
                           image.contentMode = .scaleAspectFit
                       }
               ///
           }
       }

//    When using UICollectionView, cells are reused for performance — instead of creating a new cell every time, UIKit recycles old ones.
//    So if a cell had a + icon or hidden button earlier, those old properties may still exist when reused for another index.
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil                   // Reset image
        addImageView.isHidden = true       // Hide add button (safety)
    }
}
