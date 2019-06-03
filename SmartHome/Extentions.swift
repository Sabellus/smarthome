//
//  Extentions.swift
//  SmartHome
//
//  Created by Савелий Вепрев on 31/05/2019.
//  Copyright © 2019 Савелий Вепрев. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    internal func relayout()  {
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
        setNeedsLayout()
        layoutIfNeeded()
    }
}
extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
