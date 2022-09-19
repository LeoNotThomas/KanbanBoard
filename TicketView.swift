//
//  TicketView.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 19.09.22.
//

import SwiftUI

struct TicketView: View {
    @State var model: TicketViewModel
    
    let width:  CGFloat = 100
    let height: CGFloat = 100
    
    var body: some View {
        Text(model.text)
            .frame(minWidth: width, maxWidth: width, minHeight: height, maxHeight: height)
            .background(.red)
            
    }
}

struct TicketView_Previews: PreviewProvider {
    static var previews: some View {
        let ticket = Ticket(id: 0, text: "Here we can see our Task")
        let model = TicketViewModel(type: .ticket, ticket: ticket)
        TicketView(model: model)
    }
}
