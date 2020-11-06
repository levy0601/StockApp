//
//  Stock.swift
//  StockApp
//
//  Created by Hao Liu on 10/28/20.
//

import Foundation


class Stock {
    var ceo : String = ""
    var price : Double = 0.0
    
    init( ceo : String, price : Double) {
        self.ceo = ceo
        self.price = price
    }
}
