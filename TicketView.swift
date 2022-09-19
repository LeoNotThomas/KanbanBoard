//
//  TicketView.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 19.09.22.
//

import SwiftUI

struct TicketView: View {
    @State var model: TicketViewModel
    
    var body: some View {
        Text(model.text)
            .frame(minWidth: model.width, maxWidth: model.width, minHeight: model.height, maxHeight: model.height)
            .background(model.color)
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        let ticket = Ticket(id: 0, text: "Here we can see our Task")
        let model = TicketViewModel(type: .ticket, ticket: ticket)
        TicketView(model: model)
    }
}
