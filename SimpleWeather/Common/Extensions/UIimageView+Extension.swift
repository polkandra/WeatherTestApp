//
//  UIimageView+Extension.swift
//  SimpleWeather
//
//  Created by Michael Kozlyukov on 15.05.2025.
//

import UIKit

private let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func setImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            print("❌ Неверный URL: \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("❌ Ошибка загрузки изображения: \(error.localizedDescription)")
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                print("❌ Не удалось создать изображение из данных")
                return
            }
            
            imageCache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                self?.image = image
            }
            
        }.resume()
    }
}
