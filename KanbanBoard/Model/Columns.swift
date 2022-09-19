//
//  Columns.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 15.09.22.
//

import Foundation

enum ActionResult: String {
    case success
    case columnNotEmpty
    case columnNotFound
    case ticketNotFound
    case columnExist
}

// MARK: - Columns
struct Columns: Codable {
    var columns: [Column]
    
    func nextTicketId() -> Int {
        var identifier: Int = 0
        for column in columns {
            for ticket in column.ticketList {
                identifier = identifier > ticket.id ? identifier : ticket.id
            }
        }
        return identifier + 1
    }
    
    mutating func add(_ ticket: Ticket, to: Column, ticketIndex: Int? = nil) -> ActionResult {
        if let idx = self.index(of: to) {
            var currentIndex: Int?
            let column = column(of: ticket)
            if let column = column {
                var newColumn = column.column
                var list = newColumn.ticketList
                currentIndex = column.indexTicket
                list.removeAll(where: { $0 == ticket })
                newColumn.ticketList = list
                let index = column.indexColumn
                columns[index] = newColumn
            }
            var newColumn = columns[idx]
            var list = newColumn.ticketList
            let index: Int = currentIndex == nil || column?.column != newColumn ? ticketIndex ?? list.count : currentIndex!
            if index >= list.count {
                list.append(ticket)
            } else {
                list.insert(ticket, at: index)
            }
            newColumn.ticketList = list
            columns[idx] = newColumn
            return .success
        }
        return .columnNotFound
    }
    
    mutating func add(_ column: Column, index: Int? = nil) -> ActionResult {
        if let _ = self.index(of: column) {
            return .columnExist
        }
        if let index = index, index < columns.count {
            columns.insert(column, at: index)
            return .success
        }
        columns.append(column)
        return .success
    }
    
    mutating func delete(_ ticket: Ticket) -> ActionResult {
        if let columnIndex = column(of: ticket) {
            var newColumn = columnIndex.column
            var list = newColumn.ticketList
            list.removeAll(where: { $0 == ticket })
            newColumn.ticketList = list
            columns[columnIndex.indexColumn] = newColumn
            return .success
        }
        return .ticketNotFound
    }
    
    mutating func delete(_ column: Column) -> ActionResult {
        if let columnIndex = self.index(of: column) {
            if !columns[columnIndex].ticketList.isEmpty { return .columnNotEmpty}
            columns.removeAll(where: { $0 == column })
            return .success
        }
        return .columnNotFound
    }
    
    typealias ColumnTicketIndex = (column: Column, indexColumn: Int, indexTicket: Int)
    
    private func index(of: Column) -> Int? {
        return columns.firstIndex(where: { $0 == of })
    }
    
    private func column(of: Ticket) -> ColumnTicketIndex? {
        for (idx, column) in columns.enumerated() {
            if let index = column.ticketList.firstIndex(where: { $0 == of }) {
                return (column: column, indexColumn: idx, indexTicket: index)
            }
        }
        return nil
    }
}

// MARK: - Column
struct Column: Codable, Equatable {
    static func == (lhs: Column, rhs: Column) -> Bool {
        lhs.id == rhs.id
    }
    
    let headline: String
    let id: Int
    fileprivate (set) var ticketList: [Ticket]
    let wipLimit: Int

    enum CodingKeys: String, CodingKey {
        case headline, id, ticketList
        case wipLimit = "wip_limit"
    }
}

// MARK: - TicketList
struct Ticket: Codable, Hashable {
    
    static func == (lhs: Ticket, rhs: Ticket) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int
    let text: String
}
