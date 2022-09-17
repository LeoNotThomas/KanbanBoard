//
//  Kanban.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 15.09.22.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

final class Kanban {
    
    private (set) var columns: Columns!
    
    private var rawData: Any! {
        didSet {
            if let data = try? JSONSerialization.data(withJSONObject: rawData!) {
                let decoder = JSONDecoder()
                columns = try? decoder.decode(Columns.self, from: data)
                let userInfo = [Constant.UserInfoKey.colums: columns.columns]
                NotificationCenter.default.post(Notification(name: .kanbanUpdate, userInfo: userInfo))
            }
        }
    }
    
    private let database = Database.database().reference()
    
    static let shared = Kanban()
    
    static func configure() {
        FirebaseApp.configure()
    }
    
    func initData() {
        database.getData { error, data in
            if error == nil, let data = data?.value as? Any {
                self.rawData = data
            }
        }
        database.child("columns").getData { error, data in
            if error == nil, let data = data?.value as? Any {
                self.rawData = data
            }
        }
    }
}
