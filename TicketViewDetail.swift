//
//  TicketViewDetail.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 19.09.22.
//

import SwiftUI

struct TicketViewDetail: View {
    private var model: TicketViewModel?
    private var cols = Kanban.shared.columns
    @State private var text: String

    var body: some View {
        if let model = model {
            Text(model.text)
            TextEditor(text: $text)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            Button("Save") {
                print("Save the shit")
                if var ticket = model.ticket, let col = cols?.column(of: ticket) {
                    ticket.text = text
                    let result = Kanban.shared.columns.add(ticket, to: col.column)
                    if result == .success {
                        Kanban.shared.save(ticket: ticket)
                    }
                }
            }
        } else {
            Text("Missing the Model")
        }
    }
    
    init(model: TicketViewModel?) {
        self.model = model
        _text = State(initialValue: model?.text ?? "")
    }
}

struct TicketViewDetail_Previews: PreviewProvider {
    static var previews: some View {
        let ticket = Ticket(id: 0, text: "Here comes the card")
        let model = TicketViewModel(type: .ticket, ticket: ticket)
        TicketViewDetail(model: model)
    }
}
