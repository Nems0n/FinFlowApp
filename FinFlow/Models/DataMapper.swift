//
//  CompanyDataMapper.swift
//  FinFlow
//
//  Created by Vlad Todorov on 9.04.23.
//

import Foundation

class DataMapper {
    
    static func mapToUserObject(_ user: User) -> UserObject {
        let uo = UserObject()
        uo.id = user.id
        uo.allows.removeAll()
        uo.allows.append(objectsIn: user.allows.compactMap { $0.rawValue })
        uo.companyId = user.companyId
        
        if let dateOfCreation = user.dateOfCreation {
            uo.dateOfCreation.append(objectsIn: dateOfCreation)
        }
        
        uo.email = user.email
        uo.role = user.role.rawValue
        uo.phoneNumber = user.phoneNumber
        
        return uo
    }
    
    static func mapToUser(_ uo: UserObject) -> User {
        let user = User(id: uo.id,
                        name: uo.name,
                        allows: uo.allows.compactMap({StorageView(rawValue: $0)}),
                        companyId: uo.companyId,
                        dateOfCreation: Array(uo.dateOfCreation),
                        email: uo.email,
                        role: Roles(rawValue: uo.role)!,
                        phoneNumber: uo.phoneNumber,
                        company: uo.company,
                        photos: uo.photos)
        return user
    }
    
    static func mapToDiscoutObject(_ discount: Discount?) -> DiscountObject? {
        guard let dis = discount else { return nil }
        let dObject = DiscountObject()
        dObject.startDate.removeAll()
        dObject.startDate.append(objectsIn: dis.startDate)
        dObject.endDate.removeAll()
        dObject.endDate.append(objectsIn: dis.endDate)
        dObject.discountProperty = dis.discountProperty
        return dObject
    }
    
    static func mapToDiscount(_ dObject: DiscountObject?) -> Discount? {
        guard let dis = dObject else { return nil }
        let discount = Discount(startDate: dis.startDate.map {$0},
                                endDate: dis.endDate.map {$0},
                                discountProperty: dis.discountProperty)
        
        return discount
    }
    
    static func mapToProductObject(_ product: Product) -> ProductObject {
        let po = ProductObject()
        po.id = product.id
        po.productName = product.productName
        po.price = product.price
        po.amount = product.amount
        po.category = product.category.rawValue
        po.supplier = product.supplier
        po.discount = DataMapper.mapToDiscoutObject(product.discount)
        return po
    }
    
    static func mapToProduct(_ po: ProductObject) -> Product {
        let product = Product(id: po.id,
                              productName: po.productName,
                              price: po.price,
                              amount: po.amount,
                              category: Category(rawValue: po.category)!,
                              supplier: po.supplier,
                              discount: DataMapper.mapToDiscount(po.discount))
        return product
    }
    
    static func mapToCompanyObject(_ company: Company) -> CompanyObject {
        let co = CompanyObject()
        co.id = company.id
        co.name = company.name
        co.dateOfCreation.removeAll()
        co.dateOfCreation.append(objectsIn: company.dateOfCreation)
        co.inviteLink = company.inviteLink
        co.revenues.removeAll()
        co.revenues.append(objectsIn: company.revenues)
        let userObjects = company.users.map { DataMapper.mapToUserObject($0) }
        co.users.append(objectsIn: userObjects)
        let productObjects = company.products.map { DataMapper.mapToProductObject($0) }
        co.products.append(objectsIn: productObjects)
        return co
    }
    
    static func mapToCompany(_ co: CompanyObject) -> Company {
        let company = Company(id: co.id,
                              name: co.name,
                              dateOfCreation: co.dateOfCreation.map { $0 },
                              inviteLink: co.inviteLink,
                              revenues: co.revenues.map { $0 },
                              users: co.users.map { DataMapper.mapToUser($0) },
                              products: co.products.map { DataMapper.mapToProduct($0)})
        return company
    }
}
