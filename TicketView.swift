//
//  TicketView.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 19.09.22.
//

import SwiftUI

struct TicketView: View {
    @ObservedObject var viewModel: ColumnsViewModel
    var model: TicketViewModel
    var body: some View {
        let current = viewModel.currentModel(model: model)
        Text(current?.text ?? "Missing Data")
            .frame(minWidth: model.width, maxWidth: model.width, minHeight: model.height, maxHeight: model.height)
            .background(current == viewModel.selectTicket ? viewModel.selectTicket?.color : current?.color)
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        let ticket = Ticket(id: 0, text: "Here we can see our Task")
        let model = TicketViewModel(type: .ticket, ticket: ticket)
        let col = Column(headline: "headline", id: 1, ticketList: [ticket], wipLimit: 1)
        let viewModel = ColumnsViewModel(columns: [col])
        TicketView(viewModel: viewModel, model: model)
    }
}
