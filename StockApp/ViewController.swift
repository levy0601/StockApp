//
//  ViewController.swift
//  StockApp
//
//  Created by Hao Liu on 10/26/20.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner
import PromiseKit


class ViewController: UIViewController {

    @IBOutlet weak var SymbolTextField: UITextField!
    @IBOutlet weak var CEOTextField: UITextField!
    @IBOutlet weak var PriceTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getValue(_ sender: Any) {
        let symbol = SymbolTextField.text?.uppercased()
        clearTextField()
        
        if(symbol != nil && symbol != ""){
            getStockProfile(symbol: symbol!)
        }
    }
    
    func getStockProfile(symbol :String){
        SwiftSpinner.show("Getting Stock Value for \(String(describing: symbol))")
        
        self.fetchStockProfile(for: symbol).done { (ceo, price) in
            self.CEOTextField.text = ceo
            self.PriceTextField.text = String(price)
        }
        
    }
    
    func fetchStockProfile(for symbol:String) -> Promise<(String,Double)> {
        return Promise<(String,Double)>{ seal -> Void in
            let url = stockProfileURL + symbol + "?apikey=" + apiKey
            AF.request(url).responseJSON { (response) in
                if response.error != nil{
                    seal.reject( response.error!)
                }else{
                    guard let jsonString = response.data else{ return }
                    guard let json : [JSON] = JSON(jsonString).array else { return }
                    
                    if json.count < 1 { return }
                    guard let ceo = json[0]["ceo"].rawString() else { return }
                    guard let price = json[0]["price"].double  else { return }
                    
                    seal.fulfill((ceo, price))
                    
                }
            }
            SwiftSpinner.hide()
        }
    }
    
    func clearTextField(){
        CEOTextField.text = ""
        PriceTextField.text = ""
    }


}

