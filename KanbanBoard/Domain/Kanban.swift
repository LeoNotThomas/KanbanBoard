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
    
    var columns: Columns!
    
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
            } else {
                print("Error occured loading: \(error)")
            }
        }
        database.observe(.childChanged) { snapshot, arg  in
            if let data = try? JSONSerialization.data(withJSONObject: snapshot.value) {
                let decoder = JSONDecoder()
                self.columns.columns = try! decoder.decode([Column].self, from: data)
                let userInfo = [Constant.UserInfoKey.colums: self.columns.columns]
                NotificationCenter.default.post(Notification(name: .kanbanUpdate, userInfo: userInfo))
            }
        }
    }
    
    func save(ticket: Ticket) {
        if let col = columns.column(of: ticket) {
            database.ref.child("columns/\(col.indexColumn)/ticketList/\(col.indexTicket)/text").setValue(ticket.text)
        }
    }
    
}
