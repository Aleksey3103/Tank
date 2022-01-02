//
//  TanksViewModel.swift
//  NetworkTanks
//
//  Created by Aleksey on 27.12.2021.
//

import Foundation
import UIKit

class TanksViewModel {
    var data = ModelTanks(data: [:])
    var apiClient = RequestManager()
    var reloadInfo: (()->())?
    var showError: (()->())?
    private var cellViewModels: [DataListCellViewModel] = [DataListCellViewModel]()
    
    
    func getData() {
        clouserSetUp()
        self.apiClient.getDataTanks()
    }
    
    func clouserSetUp() {
        apiClient.tankListDataSuccsesClosure = { [weak self] data in
            self?.createCell(datas: data)
        }
        apiClient.tankDataError = { [weak self] data in
            self?.showError?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> DataListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCell(datas: ModelTanks) {
        var modelCell = [DataListCellViewModel]()
        for key in datas.data.keys {
            if let value = datas.data[key] {
                guard let imgurl = value.images.imageUrl else {
                    return
                }
                modelCell.append(DataListCellViewModel(tankImage: imgurl, tankLabel: value.name, desc: value.description))
            }
        }
        
        cellViewModels = modelCell
        self.reloadInfo?()
    }
    
    struct DataListCellViewModel {
        let tankImage: URL
        let tankLabel: String
        let desc: String
    }
}
