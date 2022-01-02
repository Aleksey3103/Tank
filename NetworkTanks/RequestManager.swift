//
//  RequestManager.swift
//  NetworkTanks
//
//  Created by Aleksey on 27.12.2021.
//

import Foundation
import UIKit

class RequestManager {
    
    var tankListDataSuccsesClosure: ((ModelTanks) -> ())?
    var tankListData = ModelTanks(data: [:])
    
    var tankDataError:((String) -> ())?
    
    var appid = "8597d726286d88724d624cd07e8aed4f"
    var path = "https://api.worldoftanks.ru"
    
    
    func getDataTanks() {
        let session = URLSession.shared
        let urlOptional = URL(string: "\(path)/wot/encyclopedia/vehicles/?application_id=\(appid)")
        if let url = urlOptional {
            let task = session.dataTask(with: url) { [self] (data, responce, error) in
                if let error = error {
                    print("DataTask error\(String(describing: error.localizedDescription))")
                    tankDataError?(error.localizedDescription)
                    return
                }
                do {
                    if let data = data {
                        self.tankListData = try JSONDecoder().decode(ModelTanks.self, from: data)
                        print("Tank DATA \(tankListData)")
                        tankListDataSuccsesClosure?(tankListData)
                    }
                } catch {
                    print("CATCH ERROR \(error.localizedDescription)")
                    tankDataError?(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
}
