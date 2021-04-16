//
//  FilterService.swift
//  CameraFilter
//
//  Created by Myron Dulay on 4/14/21.
//

import UIKit
import CoreImage
import RxSwift

class FilterService {
  
  private var context: CIContext
  
  init() {
    context = CIContext()
  }
  
  
  func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
    return Observable<UIImage>.create { observer in
      self.applyFilter(to: inputImage) { filteredImage in
        observer.onNext(filteredImage)
      }
      return Disposables.create()
    }
  }
  
  
  private func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
    let filter = CIFilter(name: "CICMYKHalftone")!
    filter.setValue(5.0, forKey: kCIInputWidthKey) // intensity of the filter
    
    if let sourceImage = CIImage(image: inputImage) {
      filter.setValue(sourceImage, forKey: kCIInputImageKey)
      
      // creating the cg image and get the output that we want
      if let cgimg = context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
        let processedImage = UIImage(cgImage: cgimg, scale: inputImage.scale, orientation: inputImage.imageOrientation)
        completion(processedImage)
      }
      
      
      
    }
    
    
    
  }
  
  
}
