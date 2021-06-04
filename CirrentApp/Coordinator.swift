//
//  Coordinator.swift
//  CirrentApp
//
//  Created by AlexanderKogut on 5/2/19.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController {get set}
    func start()
}

