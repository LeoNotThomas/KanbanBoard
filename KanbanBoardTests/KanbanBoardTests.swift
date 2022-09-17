//
//  KanbanBoardTests.swift
//  KanbanBoardTests
//
//  Created by Thomas Leonhardt on 12.09.22.
//

import XCTest
@testable import KanbanBoard

class KanbanBoardTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReadData() throws {
        guard let path = Bundle(for: type(of: self)).path(forResource: "KanbanData", ofType: "json") else {
            fatalError()
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            guard let decodedData = try? decoder.decode(Columns.self, from: data) else {
                XCTAssertTrue(false, "Can't decode data")
                return
            }
            XCTAssertFalse(decodedData.columns.isEmpty, "No entries found")
        } catch {
            XCTAssertTrue(false, "Can't read data")
        }

    }
    
    func testNextTicketId() {
        
        let doIt = Column(headline: "Do It", id: 1, ticketList: [Ticket(id: 1, text: "task 1"), Ticket(id: 2, text: "task 2"), Ticket(id: 6, text: "task 6")], wipLimit: 8)
        let done = Column(headline: "Done", id: 2, ticketList: [Ticket(id: 0, text: "task 0"), Ticket(id: 3, text: "task 3"), Ticket(id: 4, text: "task 4")], wipLimit: 8)
        
        let columns = Columns(columns: [doIt, done])
        
        XCTAssertTrue(columns.nextTicketId() == 7, "Next Ticket ID is wrong")
        
    }
    
    func testAddTicket() {
        let moveTicket = Ticket(id: 0, text: "task 0")
        
        let doIt = Column(headline: "Do It", id: 1, ticketList: [Ticket(id: 1, text: "task 1"), Ticket(id: 2, text: "task 2"), Ticket(id: 6, text: "task 6")], wipLimit: 8)
        let done = Column(headline: "Done", id: 2, ticketList: [Ticket(id: 3, text: "task 3"), Ticket(id: 4, text: "task 4")], wipLimit: 8)
    
        var columns = Columns(columns: [doIt, done])
    
        XCTAssertTrue(columns.add(moveTicket, to: doIt, ticketIndex: 2) == .success, "Unexpected Result while adding new ticket")
        XCTAssertTrue(columns.columns[0].ticketList[2] == moveTicket && columns.columns[0].ticketList.contains(where: { $0 == moveTicket }), "Error while add a new ticket")
    }
    
    func testMoveTicket() {
        let moveTicket = Ticket(id: 0, text: "task 0")
        
        let doIt = Column(headline: "Do It", id: 1, ticketList: [Ticket(id: 1, text: "task 1"), Ticket(id: 2, text: "task 2"), Ticket(id: 6, text: "task 6")], wipLimit: 8)
        let done = Column(headline: "Done", id: 2, ticketList: [moveTicket, Ticket(id: 3, text: "task 3"), Ticket(id: 4, text: "task 4")], wipLimit: 8)
    
        var columns = Columns(columns: [doIt, done])
    
        XCTAssertTrue(columns.add(moveTicket, to: doIt) == .success, "Unexpected Result while moving ticket")
        XCTAssertTrue(columns.columns[0].ticketList.last == moveTicket && columns.columns[0].ticketList.contains(where: { $0 == moveTicket }), "Error while move ticket")
    }
    
    func testUdateTicket() {
        let moveTicket = Ticket(id: 0, text: "task new 0")
        
        let doIt = Column(headline: "Do It", id: 1, ticketList: [Ticket(id: 0, text: "task 0"), Ticket(id: 1, text: "task 1"), Ticket(id: 2, text: "task 2"), Ticket(id: 6, text: "task 6")], wipLimit: 8)
        let done = Column(headline: "Done", id: 2, ticketList: [Ticket(id: 3, text: "task 3"), Ticket(id: 4, text: "task 4")], wipLimit: 8)
    
        var columns = Columns(columns: [doIt, done])
    
        XCTAssertTrue(columns.add(moveTicket, to: doIt) == .success, "Unexpected Result while updating ticket")
        XCTAssertTrue(columns.columns[0].ticketList.first == moveTicket && columns.columns[0].ticketList.contains(where: { $0 == moveTicket }), "Error while Updating")
    }
    
    func testDeleteExistingTicket() {
        let moveTicket = Ticket(id: 0, text: "task new 0")
        
        let doIt = Column(headline: "Do It", id: 1, ticketList: [Ticket(id: 0, text: "task 0"), Ticket(id: 1, text: "task 1"), Ticket(id: 2, text: "task 2"), Ticket(id: 6, text: "task 6")], wipLimit: 8)
        let done = Column(headline: "Done", id: 2, ticketList: [Ticket(id: 3, text: "task 3"), Ticket(id: 4, text: "task 4")], wipLimit: 8)
    
        var columns = Columns(columns: [doIt, done])
    
        XCTAssertTrue(columns.delete(moveTicket) == .success, "Wrong result while deleting ticket")
        XCTAssertTrue(!columns.columns[0].ticketList.contains(where: { $0 == moveTicket }), "Error while deleting ticket")
    }
    
    func testDeleteNonExistingTicket() {
        let moveTicket = Ticket(id: 0, text: "task new 0")
        
        let doIt = Column(headline: "Do It", id: 1, ticketList: [Ticket(id: 1, text: "task 1"), Ticket(id: 2, text: "task 2"), Ticket(id: 6, text: "task 6")], wipLimit: 8)
        let done = Column(headline: "Done", id: 2, ticketList: [Ticket(id: 3, text: "task 3"), Ticket(id: 4, text: "task 4")], wipLimit: 8)
    
        var columns = Columns(columns: [doIt, done])
    
        XCTAssertTrue(columns.delete(moveTicket) == .ticketNotFound, "Wrong result while deleting ticket")
    }
    
    func testDeleteExistingEmptyColumn() {

        let doIt = Column(headline: "Do It", id: 1, ticketList: [Ticket(id: 0, text: "task 0"), Ticket(id: 1, text: "task 1"), Ticket(id: 2, text: "task 2"), Ticket(id: 6, text: "task 6")], wipLimit: 8)
        let done = Column(headline: "Done", id: 2, ticketList: [], wipLimit: 8)
        
        let delete = Column(headline: "Done", id: 2, ticketList: [Ticket(id: 3, text: "task 3"), Ticket(id: 4, text: "task 4")], wipLimit: 8)
    
        var columns = Columns(columns: [doIt, done])
    
        XCTAssertTrue(columns.delete(delete) == .success, "Wrong result while deleting existing empty column")
        XCTAssertTrue(!columns.columns.contains(where: { $0 == delete }), "Error while existing empty column")
    }
    
    func testDeleteExistingNonEmptyColumn() {

        let doIt = Column(headline: "Do It", id: 1, ticketList: [Ticket(id: 0, text: "task 0"), Ticket(id: 1, text: "task 1"), Ticket(id: 2, text: "task 2"), Ticket(id: 6, text: "task 6")], wipLimit: 8)
        let done = Column(headline: "Done", id: 2, ticketList: [Ticket(id: 3, text: "task 3"), Ticket(id: 4, text: "task 4")], wipLimit: 8)
        
        let delete = Column(headline: "Done", id: 2, ticketList: [Ticket(id: 3, text: "task 3"), Ticket(id: 4, text: "task 4")], wipLimit: 8)
    
        var columns = Columns(columns: [doIt, done])
    
        XCTAssertTrue(columns.delete(delete) == .columnNotEmpty, "Wrong result while deleting existing non empty column")
        XCTAssertTrue(columns.columns.contains(where: { $0 == delete }), "Error while existing non empty column")
    }
    
    func testDeleteNonExistingColumn() {
        let doIt = Column(headline: "Do It", id: 1, ticketList: [Ticket(id: 0, text: "task 0"), Ticket(id: 1, text: "task 1"), Ticket(id: 2, text: "task 2"), Ticket(id: 6, text: "task 6")], wipLimit: 8)
        let done = Column(headline: "Done", id: 2, ticketList: [Ticket(id: 3, text: "task 3"), Ticket(id: 4, text: "task 4")], wipLimit: 8)

        var columns = Columns(columns: [doIt, done])
        
        let delete = Column(headline: "Done", id: 3, ticketList: [Ticket(id: 3, text: "task 3"), Ticket(id: 4, text: "task 4")], wipLimit: 8)

        XCTAssertTrue(columns.delete(delete) == .columnNotFound, "Unexpected result while deleting a non existing column")
        
    }
    
    func testMaxCount() {
        let doIt = Column(headline: "Doit", id: 1, ticketList: [Ticket(id: 0, text: "task 0"), Ticket(id: 1, text: "task 1"), Ticket(id: 2, text: "task 2"), Ticket(id: 6, text: "task 6")], wipLimit: 8)
        let done = Column(headline: "Done", id: 2, ticketList: [Ticket(id: 3, text: "task 0"), Ticket(id: 4, text: "task 1")], wipLimit: 8)
        
        let model = ColumnsViewModel(columns: [doIt, done])
        
        XCTAssertTrue(model.maxColCount == 4, "Unexpected maxColCount")
    }
    
    func testViewModel() {
        let doIt = Column(headline: "Done", id: 1, ticketList: [Ticket(id: 0, text: "task 0"), Ticket(id: 1, text: "task 1"), Ticket(id: 2, text: "task 2"), Ticket(id: 6, text: "task 6")], wipLimit: 8)
        let done = Column(headline: "Doit", id: 2, ticketList: [Ticket(id: 3, text: "task 0"), Ticket(id: 4, text: "task 1")], wipLimit: 8)
        
        let model = ColumnsViewModel(columns: [doIt, done])
        
        let data_0 = model.collectionList[0].data
        let data_1 = model.collectionList[1].data
        let data_2 = model.collectionList[2].data
        let data_3 = model.collectionList[3].data
        let data_4 = model.collectionList[4].data
        
        XCTAssertTrue(model.collectionList.count == 5, "Unexpected count")
        
        XCTAssertTrue(data_0[0].text == "Done", "wrong text")
        XCTAssertTrue(data_0[1].text == "Doit", "wrong text")
        
        XCTAssertTrue(data_1[0].text == "task 0", "wrong text")
        XCTAssertTrue(data_1[1].text == "task 0", "wrong text")
        
        XCTAssertTrue(data_2[0].text == "task 1", "wrong text")
        XCTAssertTrue(data_2[1].text == "task 1", "wrong text")
        
        XCTAssertTrue(data_3[0].text == "task 2", "wrong text")
        XCTAssertTrue(data_3[1].text == nil, "wrong text")
        
        XCTAssertTrue(data_4[0].text == "task 6", "wrong text")
        XCTAssertTrue(data_4[1].text == nil, "wrong text")
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
