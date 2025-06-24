import UIKit


extension UserViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 2
        let spacing: CGFloat = 8
        let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        let totalSpacing = sectionInsets.left + sectionInsets.right + (spacing * (itemsPerRow - 1))
        let itemWidth = (collectionView.bounds.width - totalSpacing) / itemsPerRow

        return CGSize(width: floor(itemWidth), height: floor(itemWidth)) // square cell
    }
}




extension UserViewController : UICollectionViewDelegate ,UICollectionViewDataSource {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.userGalleryArray.count // or the number of items you want in each section
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        
        let data = viewModel.userGalleryArray[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! GalleryCollectionViewCell
            cell.configure(with: data)
            cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.userGalleryArray[indexPath.item]
          guard !(data.showAdd && data.url.isEmpty) else {
              showImagePicker()
              return
          }
    }

}


