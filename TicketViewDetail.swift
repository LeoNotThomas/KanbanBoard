//
//  TicketViewDetail.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 19.09.22.
//

import SwiftUI

struct TicketViewDetail: View {
    @ObservedObject var viewModel: ColumnsViewModel
    private var cols = Kanban.shared.columns
    var model: TicketViewModel? {
        didSet {
            text = "blabla"
        }
    }
    
    @State var text: String = ""
    let bottonColor = Color.gray
    @Environment(\.dismiss) var dismiss

    var body: some View {
        if let model = viewModel.selectTicket, let current = viewModel.currentModel(model: model) {
            Text(current.text)
            TextEditor(text: $text)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .onAppear{
                    self.text = current.text
                }
            Button("Save") {
                if var ticket = model.ticket, let col = cols?.column(of: ticket) {
                    ticket.text = text
                    let result = Kanban.shared.columns.add(ticket, to: col.column)
                    if result == .success {
                        Kanban.shared.save(ticket: ticket)
                    }
                }
            }
            .background(bottonColor)
            Spacer()
            Button("Close") {
                dismiss()
            }
            .background(bottonColor)
            Spacer()
        } else {
            Text("Missing the Model")
            Spacer()
            Button("Close") {
                dismiss()
            }
            .background(bottonColor)
            Spacer()
        }
    }
    
    init(viewModel: ColumnsViewModel) {
        self.viewModel = viewModel
        self.model = viewModel.selectTicket
    }
}

struct TicketViewDetail_Previews: PreviewProvider {
    static var previews: some View {
        let ticket = Ticket(id: 0, text: "Here we can see our Task")
        let model = TicketViewModel(type: .ticket, ticket: ticket)
        let col = Column(headline: "headline", id: 1, ticketList: [ticket], wipLimit: 1)
        let viewModel = ColumnsViewModel(columns: [col])
        TicketViewDetail(viewModel: viewModel)
        
        TicketView(viewModel: viewModel, model: model)
    }
}
