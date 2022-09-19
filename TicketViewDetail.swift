//
//  TicketViewDetail.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 19.09.22.
//

import SwiftUI

struct TicketViewDetail: View {
    @State private var ticketText: String
    private var model: TicketViewModel

    var body: some View {
        TextEditor(text: $ticketText)
            .foregroundColor(.secondary)
            .padding(.horizontal)
    }
    
    init(model: TicketViewModel) {
        self.model = model
        self.ticketText = model.text
    }
}

struct TicketViewDetail_Previews: PreviewProvider {
    static var previews: some View {
        let ticket = Ticket(id: 0, text: "Here comes the card")
        let model = TicketViewModel(type: .ticket, ticket: ticket)
        TicketViewDetail(model: model)
    }
}
