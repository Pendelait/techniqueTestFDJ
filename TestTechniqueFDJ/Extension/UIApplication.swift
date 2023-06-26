//
//  UIApplication.swift
//  TestTechniqueFDJ
//
//  Created by Vahe Avetissian on 24/06/2023.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
