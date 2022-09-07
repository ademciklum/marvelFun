//
//  RequestError.swift
//  MarvelFun
//
//  Created by Artem Demchenko on 07.09.2022.
//

import Foundation

public enum RequestError: Error {
    case defaultError(error: Error)
    case searchError(error: Error)
    
    var userFriendlyMessage: String {
        switch self {
        case .defaultError:
            return "Something went wrong"
        case .searchError:
            return "Searching error"
        }
    }
}
