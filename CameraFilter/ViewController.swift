//
//  ViewController.swift
//  CameraFilter
//
//  Created by Myron Dulay on 4/14/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

  // MARK: - Properties
  
  @IBOutlet weak var filterButton: UIButton!
  @IBOutlet weak var photoImageView: UIImageView!
  
  let disposeBag = DisposeBag()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.title = "CameraFilter"
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let navC = segue.destination as? UINavigationController,
          let photosCVC = navC.viewControllers.first as? PhotosCollectionViewController else {
      fatalError()
    }
    
    photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
      DispatchQueue.main.async {
        self?.updateUI(with: photo)
      }
    }).disposed(by: disposeBag)
    
  }
  
  private func updateUI(with image: UIImage) {
    photoImageView.image = image
    filterButton.isHidden = false
  }
  
  // MARK: - Actions
  
  @IBAction func applyFilterButtonPressed() {
    guard let sourceImage = photoImageView.image else { return }
    
    
    FilterService().applyFilter(to: sourceImage).subscribe(onNext: { filteredImage in
      DispatchQueue.main.async {
        self.photoImageView.image = filteredImage
      }
    }).disposed(by: disposeBag)
    

    
  }
  
}

