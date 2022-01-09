//
//  TanksViewModel.swift
//  NetworkTanks
//
//  Created by Aleksey on 27.12.2021.
//

import Foundation
//import UIKit

class TanksViewModel {
    private var data = ModelTanks(data: [:])
    private var datum = [Datum]()
    var apiClient = RequestManager()
    var reloadInfo: (()->())?
    var showError: (()->())?
    
    private var cellViewModels: [DataListCellViewModel] = [DataListCellViewModel]()
    
    func getData() {
        clouserSetUp()
        self.apiClient.getDataTanks()
    }
    
    private func clouserSetUp() {
        apiClient.tankListDataSuccsesClosure = { [weak self] data in
            var datum = [Datum]()
            for key in data.data.keys {
                if let value = data.data[key] {
                    datum.append(value)
                }
            }
            self?.datum = datum
            self?.createCell(datas: datum)
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
    
    private func createCell(datas: [Datum]) {
        var modelCell = [DataListCellViewModel]()
        for value in datas {
            guard let imgurl = value.images.imageUrl else {
                return
            }
            modelCell.append(DataListCellViewModel(tankImage: imgurl, tankLabel: value.name, desc: value.description))
        }
        cellViewModels = modelCell
        self.reloadInfo?()
    }
    
    func filterTanks(for searchText: String) {
        let filterArray = datum.filter { tank in
            return tank.name.lowercased().contains(searchText.lowercased())
        }
        self.createCell(datas: filterArray)
    }
    
    func endSearching() {
        self.createCell(datas: datum)
    }
    
    struct DataListCellViewModel {
        let tankImage: URL
        let tankLabel: String
        let desc: String
    }
}
