//
//  CustomerTests.swift
//  wirk
//
//  Created by Edward on 2/10/17.
//  Copyright © 2017 Edward. All rights reserved.
//

import XCTest
@testable import wirk

class CustomerTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testAttributes() {
        let currentDate = Int(Date.timeIntervalSinceReferenceDate)
        let customer = Customer(
            first: "John",
            middle: "D",
            last: "Happy",
            address: "1 Apple Dr Cupertino Ca 95104",
            phone: "415-999-5555",
            email: "dummy@example.com",
            dateCreated: currentDate)
        
        XCTAssertEqual(customer.first, "John")
        XCTAssertEqual(customer.middle, "D")
        XCTAssertEqual(customer.last, "Happy")
        XCTAssertEqual(customer.address, "1 Apple Dr Cupertino Ca 95104")
        XCTAssertEqual(customer.phone, "415-999-5555")
        XCTAssertEqual(customer.email, "dummy@example.com")
        XCTAssertEqual(customer.dateCreated, currentDate)
    }
    
}
