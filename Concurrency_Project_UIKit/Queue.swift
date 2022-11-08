//
//  Queue.swift
//  Concurrency_Project_UIKit
//
//  Created by Sergei Poluboiarinov on 08/11/2022.
//

import UIKit

class Queue: UIViewController {
    
    let mySerialQueue        = DispatchQueue(label: "mySerialQueque", qos: .background)
    let yourConcurrentDefaultQueue  = DispatchQueue(label: "yourSerialQueue", qos: .default, attributes: [.concurrent, .initiallyInactive])
    
    let myDispatchWorkItem = DispatchWorkItem(qos: .userInteractive, flags: .enforceQoS) {
        print("3 - yourSerialQueue + dispatchWorkItem .userInteractive .enforceQoS")
    }
    
    let stackView = UIStackView()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        DispatchQueue.global(qos: .background).async {
            print("1.1 - backgroundQueue")
            print("1.2 - backgroundQueue")
        }
        
        DispatchQueue.global(qos: .utility).async {
            print("2.1 - utilityQueue")
            print("2.2 - utilityQueue")
        }
        
        yourConcurrentDefaultQueue.async(execute: myDispatchWorkItem)
        
        mySerialQueue.asyncAfter(deadline: .now() + 1.2, qos: .userInteractive) {
            print("4 - mySerialQueue + 1.2")
            DispatchQueue.main.async {
                self.style()
                self.layout()
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            print("5 - userInitiatedQueue")
        }
        
        print("6.1 - mainQueue")
        print("6.2 - mainQueue")
        
        
        yourConcurrentDefaultQueue.activate()
        
//        style()
//        layout()
        
    }
}

extension Queue {
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
    }
    
    func layout() {
        stackView.addArrangedSubview(label)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
