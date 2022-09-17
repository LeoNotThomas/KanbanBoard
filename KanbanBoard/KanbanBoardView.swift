//
//  ContentView.swift
//  KanbanBoard
//
//  Created by Thomas Leonhardt on 12.09.22.
//

import SwiftUI

struct KanbanBoardView: View {
    
    @ObservedObject var viewModel = ColumnsViewModel(columns: nil)
    
    var body: some View {
        Text("Hello World")
//        Grid() {
//            GridRow {
//                Text("Col 1")
//                Text("Col 2")
//                Text("Col 3")
//            }
//            Divider()
//            GridRow {
//                Text("C 1 R 1")
//                Text("C 2 R 1")
//                Text("C 3 R 1")
//            }
//            Divider()
//            GridRow {
//                Text("C 1 R 2")
//                Text("C 2 R 2")
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        KanbanBoardView()
    }
}
