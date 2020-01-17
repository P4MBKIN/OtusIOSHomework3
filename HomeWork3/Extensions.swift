//
//  Extensions.swift
//  HomeWork3
//
//  Created by Pavel Antonov on 16.01.2020.
//  Copyright © 2020 OtusHomework. All rights reserved.
//

import Foundation
import OtusNewsAPI
import OtusGithubAPI

extension Date {
    func string(format: String) -> String {
        let formater = DateFormatter()
        formater.dateFormat = format
        return formater.string(from: self)
    }
}

protocol RequestResultCounter {
    typealias LabelValue = (String, Double)
    typealias QueryTitle = (String, String)
    static func getCountRequestResult(queries: QueryTitle...) -> [LabelValue]
}

extension ArticlesAPI: RequestResultCounter {
    static func getCountRequestResult(queries: QueryTitle...) -> [LabelValue] {
        let group = DispatchGroup()
        var result: [LabelValue] = []
        for query in queries {
            group.enter()
            ArticlesAPI.everythingGet(q: query.0, from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!.string(format: "yyyy-MM-dd"), sortBy: "publishedAt", apiKey: "428cdc3ea75045248447b7f8c444d298") { list, error in
                if error == nil {
                    result.append((query.1, Double(list!.totalResults!)))
                }
                group.leave()
            }
        }
        group.wait()
        return result
    }
}

extension SearchAPI: RequestResultCounter {
    static func getCountRequestResult(queries: QueryTitle...) -> [LabelValue] {
        let group = DispatchGroup()
        var result: [LabelValue] = []
        for query in queries {
            group.enter()
            SearchAPI.searchReposGet(q: query.0, order: Order.desc) { list, error in
                if error == nil {
                    result.append((query.1, Double(list!.totalCount!)))
                }
                group.leave()
            }
        }
        group.wait()
        return result
    }
}
