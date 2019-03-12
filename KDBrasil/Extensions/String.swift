//
//  String.swift
//  KDBrasil
//
//  Created by Leandro Oliveira on 2019-03-12.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import Foundation

extension String {
    
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
}
