//
//  ContentView.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 12.09.22.
//

import SwiftUI

struct KanbanBoardView: View {
    @ObservedObject var viewModel = ColumnsViewModel(columns: nil)
    @State var selected: TicketViewModel? = nil
    @State var isSelected = false
    
    var body: some View {
        List {
            ForEach(viewModel.collectionList, id: \.self) { kanbanrow in
                VStack {
                    HStack(spacing: 1) {
                        ForEach(kanbanrow.data, id: \.self) { model in
                            TicketView(model: modelWithState(model: model))
                                .gesture(TapGesture()
                                    .onEnded({ _ in
                                        if model.type != .placeholder && model.type != .headline {
                                            selected = model
                                            test()
                                            isSelected.toggle()
                                        }
                                    }))
                        }
                    }
                    .background(.clear)
                    .sheet(isPresented: $isSelected) {
                        TicketViewDetail(model: selected)
                    }
                }
            }
        }
    }
    
    private func test() {
        isSelected = false
    }
    
    func modelWithState(model: TicketViewModel) -> TicketViewModel {
        var newModel = TicketViewModel(model: model)
        newModel.isSelected = model == selected
        return newModel
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let doIt = Column(headline: "Done",     id: 1, ticketList: [Ticket(id: 0, text: "task 0"), Ticket(id: 1, text: "task 1")], wipLimit: 8)
        let done = Column(headline: "Doit",     id: 2, ticketList: [Ticket(id: 2, text: "task 0"), Ticket(id: 3, text: "task 1")], wipLimit: 8)
        let prog = Column(headline: "Progress", id: 3, ticketList: [Ticket(id: 4, text: "task 0"), Ticket(id: 5, text: "task 1")], wipLimit: 8)
        let columns = [doIt, done, prog]
        let model = ColumnsViewModel(columns: columns)
        KanbanBoardView(viewModel: model)
    }
}
