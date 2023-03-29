//
//  FFEndpoint.swift
//  FinFlow
//
//  Created by Vlad Todorov on 25.03.23.
//

import Foundation

@frozen enum FFEndpoint: String {
    //MARK: - Unauthenticated endpoints
    case register = "/auth/regis"
    case login = "/auth/login"
    case forgotPassword = "/auth/forgotPassword"
    case resetPassword = "/auth/resetPassword/"
    case info = "/auth/info"
    case refreshToken = "/auth/token/refresh"

    //MARK: - Endpoints requiring JWT token
    case changePassword = "/user/changePassword"
    case changeUserSettings = "/user/changeUserSettings"
    case getMe = "/user/getMe"
    case uploadUserPhoto = "/user/uploadUserPhoto"
//    case getPhoto = "/user/photo/**"
    case createCompany = "/company/createCompany"
    case removeCompany = "/company/removeCompany"
    case joinByCode = "/company/joinByCode"
    case deleteUser = "/company/deleteUser"
    case changeAllows = "/company/changeAllows"
    case inviteBySpecification = "/company/inviteBySpecification"
    case getData = "/company/getData"
    case leaveCompany = "/company/leaveCompany"
    case addProduct = "/res/addProduct"
    case editProduct = "/res/editProduct"
    case deleteProduct = "/res/deleteProduct"
    case addDiscount = "/res/addDiscount"
    case editDiscount = "/res/editDiscount"
    case deleteDiscount = "/res/deleteDiscount"

}
