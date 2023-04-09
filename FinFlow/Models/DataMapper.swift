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
        
        if let allows = user.allows {
            uo.allows.removeAll()
            uo.allows.append(objectsIn: allows.compactMap { $0.rawValue })
        }
        
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
                        allows: uo.allows.compactMap({StorageView(rawValue: $0)}),
                        companyId: uo.companyId,
                        dateOfCreation: Array(uo.dateOfCreation),
                        email: uo.email,
                        role: Roles(rawValue: uo.role)!,
                        phoneNumber: uo.phoneNumber)
        return user
    }
    
    static func mapToProductObject(_ product: Product) -> ProductObject {
        let po = ProductObject()
        po.id = product.id
        po.productName = product.productName
        po.price = product.price
        po.amount = product.amount
        po.category = product.category.rawValue
        po.supplier = product.supplier
        return po
    }
    
    static func mapToProduct(_ po: ProductObject) -> Product {
        let product = Product(id: po.id,
                              productName: po.productName,
                              price: po.price,
                              amount: po.amount,
                              category: Category(rawValue: po.category)!,
                              supplier: po.supplier)
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
