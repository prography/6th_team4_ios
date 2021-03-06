//
//  MoyaAPI.swift
//  uso
//
//  Created by 서재훈 on 2020/06/05.
//  Copyright © 2020 sooyong. All rights reserved.
//

import Foundation
import Moya
import RxSwift

//임시 토큰
class Token {
    static var token = "eyJhbGciOiJIUzM4NCIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjUsImlhdCI6MTU5MTg4MDg3NX0.43cddF2LE7YmhNYAC5uWCNKUgE28RaZ49ZTm9erXhsO_s41cXkHaKUP1OU78jbcn"
}

let moyaProvider = MoyaProvider<MoyaAPI>()

enum MoyaAPI {
    case getHabits(query: Int)
    case fetchRanking
    case fetchSetting
    case postHabit(_ title: String, _  category: String,
        _  description: String?, _  dayOfWeek: String, _  alarmTime: String?)
    case appleLogin(comp: UserComponent)
}

extension MoyaAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://habitbread.com")!
    }
    
    var path: String {
        switch self {
        case .getHabits(let query):
            return "/users/\(query)/habits"
        case .fetchRanking:
            return "/ranking"
        case .fetchSetting:
            return "/users"
        case .postHabit( _, _, _, _, _):
            return "/habits"
        case .appleLogin:
            return "/oauth/apple/verify"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postHabit( _, _, _, _, _):
            return .post
        case .appleLogin:
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Moya.Task {
        switch self {
        case .postHabit(let title, let category, let description, let dayOfWeek, let alarmTime):
            return .requestParameters(parameters: ["title" : title, "category" : category,
                                                   "description" : description, "dayOfWeek" : dayOfWeek, "alarmTime" : alarmTime], encoding: JSONEncoding.default)
        case .appleLogin(let comp):
            return .requestJSONEncodable(comp)
        default:
            return .requestPlain
        }
    }
    
    var validationType: Moya.ValidationType {
            return .successAndRedirectCodes
    }
    
    var headers: [String: String]? {
        switch self {
        case .appleLogin:
            return ["Content-Type": "application/json"]
        default:
            return ["Authorization": "Bearer "+Token.token]
        }
        
    }
}

struct UserComponent: Encodable {
    let code: String
    let user: UserID
}
struct UserID : Encodable {
    let name: UserName
}

struct UserName: Encodable {
    let lastName: String
    let firstName: String
}
