//
//  UIImageView+Kingfisher.swift
//  NEUGELB Movies
//
//  Created by Raj S on 07/04/23.
//

import Kingfisher
import UIKit

typealias ImageLoadCompletion = (Result<UIImage, UIImageView.LoadingError>) -> Void

extension UIImageView {
    
    func setImage(for path: String,
                  placeholderImage: UIImage? = nil,
                  completion: ImageLoadCompletion? = nil) {
        guard let url = URL(string: path) else {
            completion?(.failure(.invalidUrl))
            return
        }
        
        kf.setImage(with: ImageResource(downloadURL: url)) { result in
            switch result {
            case .success(let value):
                completion?(.success(value.image))
            case .failure(let error):
                completion?(.failure(.kingfisherError(error)))
            }
        }
    }
    
    enum LoadingError: Error {
        case invalidUrl
        case kingfisherError(KingfisherError)
    }
}
