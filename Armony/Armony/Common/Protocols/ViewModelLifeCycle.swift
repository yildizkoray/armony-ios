//
//  ViewModelLifeCycle.swift
//  Armony
//
//  Created by Koray Yıldız on 18.11.2021.
//

import Foundation

protocol ViewModelLifeCycle {

    func viewDidLoad()
    func viewWillAppear()
    func viewDidAppear()
}

extension ViewModelLifeCycle {

    func viewDidLoad() { }
    func viewWillAppear() { }
    func viewDidAppear() { }
}
