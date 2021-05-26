//
//  ViewController.swift
//  BitcoinCurrency
//
//  Created by Cassia Franco on 18/05/21.
//  Copyright © 2021 Cassia Franco. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
     //MARK: - Outlets
    @IBOutlet weak var bitcoinLabelValue: UILabel!
   
    @IBOutlet weak var pickerViewNumber: UIPickerView!
    
    
    //MARK: - Variables and Constants
    
    let apiKey = "MDlkYTA0Y2ZjMDA5NDRiMTkzOTRjNjRhMzQyNzhiNzY"
    let curruncies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pickerViewNumber.delegate = self
        pickerViewNumber.dataSource = self
        fatchDate(url: baseUrl)
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // retorno o numero de moedas para fazer a conversao.
           return curruncies.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         // retorna o titulo para a selacao
         return curruncies[row]
      }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
        fatchDate(url: url)
        
    }
    
    func fatchDate(url: String){
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField:"x-ba-key")
   
        let task = URLSession.shared.dataTask(with: request){(data, response,error) in
            
            if let data = data{
                self.parseJSON(json: data)
                //let dataString = String(data: data, encoding: .utf8)
               // print(dataString!)
                
            }else{
                print("error")
                
            }
        }
        task.resume()
    
    }
    func parseJSON(json: Data){
   
    do {
        if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                   print(json)
        if let askValue = json["ask"] as? NSNumber {
            print(askValue)
             //.currency
            
        let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale(identifier: "pt_BR")
            numberFormatter.minimumFractionDigits = 2
            //numberFormatter.positiveFormat = "#0.000,00"
            numberFormatter.numberStyle = .decimal
        
        //let askvalueString = "\(askValue)"
            DispatchQueue.main.async {
                
                let price = numberFormatter.string(from: askValue)
                self.bitcoinLabelValue.text = price
                
                //self.bitcoinLabelValue.text = askvalueString
        }
            print("success")
                    } else {
            
                        print("error")
                    }
                }
            } catch {

                print("error parsing json: \(error)")
            }
    }
    
}
