//
//  ContentView.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 12.09.22.
//

import SwiftUI

struct KanbanBoardView: View {
    @ObservedObject var viewModel = ColumnsViewModel(columns: nil)
//    @State var select: TicketViewModel
    
    var body: some View {
        NavigationView {
            List {
                Grid() {
                    ForEach(viewModel.collectionList, id: \.self) { kanbanrow in
                        GridRow {
                            ForEach(kanbanrow.data, id: \.self) { ticketModel in
                                    TicketView(model: ticketModel)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Board")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let doIt = Column(headline: "Done",     id: 1, ticketList: [Ticket(id: 0, text: "task 0"), Ticket(id: 1, text: "task 1")], wipLimit: 8)
        let done = Column(headline: "Doit",     id: 2, ticketList: [Ticket(id: 2, text: "task 0"), Ticket(id: 3, text: "task 1")], wipLimit: 8)
        let prog = Column(headline: "Progress", id: 3, ticketList: [Ticket(id: 4, text: "task 0"), Ticket(id: 5, text: "task 1")], wipLimit: 8)
        let columns = [doIt, done, prog]
        var model = ColumnsViewModel(columns: columns)
        KanbanBoardView(viewModel: model)
    }
}
