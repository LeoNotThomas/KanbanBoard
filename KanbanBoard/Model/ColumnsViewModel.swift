//
//  ColumnsViewModel.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 16.09.22.
//

import Foundation
import SwiftUI

final class ColumnsViewModel: ObservableObject {
    
    @Published private (set) var collectionList = [KanbanRow]()
    
    private var columns: [Column]? {
        didSet {
            update()
        }
    }
    
    private func setup(columns: [Column]?) {
        self.columns = columns
    }
    
    init(columns: [Column]?) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(notification:)), name: .kanbanUpdate, object: nil)
        setup(columns: columns)
    }
    
    private func update() {
        var list = [KanbanRow]()
        if let columns = columns {
            let headline = createHeads(columns: columns)
            var i = 1
            repeat {
                for (_, _) in headline.data.enumerated() {
                    var data = [TicketViewModel]()
                    for column in columns {
                        let idx = list.count
                        if idx >= column.ticketList.count {
                            let model = TicketViewModel(type: .placeholder)
                            data.append(model)
                            continue
                        }
                        let ticket = column.ticketList[idx]
                        let model = TicketViewModel(type: .ticket, ticket: ticket)
                        data.append(model)
                    }
                    let row = KanbanRow(data: data)
                    if !emptyRow(row: row) {
                        list.append(row)
                    }
                }
                i += 1
            } while ( i < maxColCount)
            list.insert(headline, at: 0)
        }
        collectionList = list
    }
    
    private func emptyRow(row: KanbanRow) -> Bool {
        for entry in row.data {
            if entry.ticket != nil {
                return false
            }
        }
        return true
    }
    
    var maxColCount: Int {
        var count = 0
        for column in columns! {
            count = max(count, column.ticketList.count)
        }
        return count
    }
    
    private func createHeads(columns: [Column]) -> KanbanRow {
        var data = [TicketViewModel]()
        for column in columns {
            let headline = TicketViewModel(type: .headline, ticket: Ticket(id: column.id, text: column.headline))
            data.append(headline)
        }
        return KanbanRow(data: data)
    }
    
    @objc
    private func updateData(notification: Notification) {
        if let columns = notification.userInfo?[Constant.UserInfoKey.colums] as? [Column] {
            self.columns = columns
        }
    }
}

struct KanbanRow: Hashable {
    
    static func == (lhs: KanbanRow, rhs: KanbanRow) -> Bool {
        if lhs.data.count != rhs.data.count {
            return false
        }
        for (index, row) in lhs.data.enumerated() {
            if let rhsIdx = rhs.data.firstIndex(where: { $0 == row } ), index == rhsIdx {
                continue
            }
            return false
        }
        return true
    }
    
    var data: [TicketViewModel]
    
    init(data: [TicketViewModel]) {
        self.data = data
    }
}

enum TicketViewModelType {
    case placeholder
    case ticket
    case headline
}

struct TicketViewModel: Hashable {
    
    static func == (lhs: TicketViewModel, rhs: TicketViewModel) -> Bool {
        return lhs.ticket == rhs.ticket
    }
    
    var type: TicketViewModelType
    var color: Color {
        if type == .placeholder {
            return Color.clear
        }
        if type == .headline {
            return Color.blue
        }
        return Color.red
    }
    
    fileprivate (set) var ticket: Ticket?
    
    var text: String {
        if let ticket = ticket {
            return ticket.text
        }
        return ""
    }
    
    var width: CGFloat {
        return 100
    }
    
    var height: CGFloat {
        if type == .headline {
            return 50
        }
        return 100
    }
}
