//
//  FFBestSellersVM.swift
//  FinFlow
//
//  Created by User Account on 26/05/2023.
//

import Foundation

final class FFBestSellersVM {
    
    // MARK: - Variables
    private var coordinator: FFStorageCoordinator
    
    var cellDataSource: Binder<[FFProductCellVM?]> = Binder([])
    
    var dataSource: [Product] = [Product]() {
        didSet {
            mapCellData()
        }
    }
    
    var realmDataSource: [Product] = [Product]() {
        didSet {
            self.dataSource = self.realmDataSource
        }
    }
    
    // MARK: - Life cycle
    init(coordinator: FFStorageCoordinator) {
        self.coordinator = coordinator
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let companyObject = FFRealmManager.shared.fetch(CompanyObject.self) else { return }
            let productObjects = companyObject.products
            let company = DataMapper.mapToCompany(companyObject)
            var revenues = company.revenues
            revenues = revenues.sorted(by: { $0.sold > $1.sold })
            let products = Array(productObjects.map { DataMapper.mapToProduct($0) })
            var innerArray = [Product]()
            for i in 0..<revenues.count {
                if let product = products.first(where: {$0.id == revenues[i].id}) {
                    innerArray.append(product)
                }
            }
            innerArray += products
            self.realmDataSource = innerArray
        }
    }
    
    // MARK: - Methods
    public func popViewController() {
        coordinator.trigger(.pop)
    }
    
    public func cellDidTap(with vm: FFStorageCellDetailVM) {
        coordinator.trigger(.detail(vm))
    }
    
    private func mapCellData() {
       self.cellDataSource.value = self.dataSource.compactMap({FFProductCellVM(product: $0)})
    }
}
