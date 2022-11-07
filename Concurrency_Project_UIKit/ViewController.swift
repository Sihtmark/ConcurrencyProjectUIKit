//
//  ViewController.swift
//  Concurrency_Project_UIKit
//
//  Created by Sergei Poluboiarinov on 07/11/2022.
//

import UIKit

class ViewController: UIViewController {
    
    let imageURL = URL(string: "https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!
    
    let eifelView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
//        fetchImage()
//        fetchImage1()
//        fetchImage2()
        fetchImage3()
    }
    
    
}

extension ViewController {
    func style() {
        eifelView.translatesAutoresizingMaskIntoConstraints = false
        eifelView.backgroundColor = .systemBlue
        eifelView.contentMode = .scaleAspectFit
    }
    
    func layout() {
        view.addSubview(eifelView)
        
        NSLayoutConstraint.activate([
            eifelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eifelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eifelView.topAnchor.constraint(equalTo: view.topAnchor),
            eifelView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController {
    
    //MARK: - classic mode
    func fetchImage() {
        let queue = DispatchQueue.global(qos: .utility)
        queue.async {
            if let data = try? Data(contentsOf: self.imageURL) {
                DispatchQueue.main.async {
                    self.eifelView.image = UIImage(data: data)
                }
            }
        }
    }
    
    //MARK: - async func URLSession
    func fetchImage1() {
//        let task = URLSession.shared.dataTask(with: imageURL){data, response, error} in
//        if let imageData = data {
//            DispatchQueue.main.async {
//                eifelView.image = UIImage(data: imageData)
//            }
//        }
//        task.resume()
    }
    
    //MARK: - DispatchWorkItem
    func fetchImage2() {
        var data: Data?
        let queue = DispatchQueue.global(qos: .utility)
        let workItem = DispatchWorkItem(qos: .userInteractive) {
            data = try? Data(contentsOf: self.imageURL)
        }
        queue.async(execute: workItem)
        workItem.notify(queue: DispatchQueue.main) {
            if let imageData = data {
                self.eifelView.image = UIImage(data: imageData)
            }
        }
    }
    
    //MARK: -
    func asyncLoadImage(
        imageURL: URL,
        runQueue: DispatchQueue,
        completionQueue: DispatchQueue,
        completion: @escaping (UIImage?, Error?) -> () ) {
            runQueue.async {
                do {
                    let data = try Data(contentsOf: imageURL)
                    completionQueue.async { completion(UIImage(data: data), nil) }
                } catch let error {
                    completionQueue.async { completion(nil, error) }
                }
            }
        }
    
    //MARK: -
    func fetchImage3() {
        asyncLoadImage(
            imageURL: imageURL,
            runQueue: DispatchQueue.global(),
            completionQueue: DispatchQueue.main) { result, error in
                guard let image = result else { return }
                self.eifelView.image = image
            }
    }
}
