//
//  APIResponseValidatorTests.swift
//  RadagastTests
//
//  Created by Jasper Valdivia on 11/04/2021.
//

import XCTest
@testable import Radagast

class APIStructureValidatorTests: XCTestCase {

    var sut: APIStructureValidator!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = APIStructureValidator()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testAPIStructureValidator_WhenCarbonForecastResponseIsValid_ShouldReturnTrue() {
        // Arrange
        let carbonResponse = CarbonForecastResponse(data: [CarbonForecast(from: Date(),
                                                                          to: Date(),
                                                                          intensity: CarbonIntensityForecast(forecast: 0,
                                                                                                             actual: 0,
                                                                                                             index: .low))])
        // Act
        let isResponseValid = sut.isCarbonForecastResponseValid(carbonResponse)
        
        // Assert
        XCTAssertTrue(isResponseValid, "The isResponseValid() should have returned TRUE for an valid response but returned FALSE")
    }
    
    func testAPIStructureValidator_WhenCarbonForecastResponseDataIsEmpty_ShouldReturnFalse() {
        // Arrange
        let carbonResponse = CarbonForecastResponse(data: [])
        
        let isResponseValid = sut.isCarbonForecastResponseValid(carbonResponse)
        
        XCTAssertFalse(isResponseValid, "The isResponseValid() should have returned FALSE for an empty data field in response but returned TRUE")
    }
    
    func testAPIStructureValidator_WhenCarbonForecastDatesAnachronous_ShouldReturnFalse() {
        // Arrange
        let carbonForecast = CarbonForecast(from: Date().addingTimeInterval(5000),
                                            to: Date(),
                                            intensity: .init(forecast: 0,
                                                             actual: 0,
                                                             index: .low))
        
        let isStructureValid = sut.isCarbonForecastValid(carbonForecast)
        
        XCTAssertFalse(isStructureValid, "The isStructureValid() should have returned FALSE for anachronous timeframes but returned TRUE")
    }
    
    func testAPIStructureValidator_WhenCarbonForecastAttemptsToForecastPastAPIRecomendations_ShouldReturnFalse() {
        let carbonForecast = CarbonForecast(from: Date(),
                                            to: Date().addingTimeInterval(174600),
                                            intensity: .init(forecast: 0,
                                                             actual: 0,
                                                             index: .low))
        
        let isStructureValid = sut.isCarbonForecastValid(carbonForecast)
        
        XCTAssertFalse(isStructureValid, "The isStructureValid() should have returned FALSE for greedy and malformed response from API but returned TRUE")
    }
    
    func testAPIStructureValidator_WhenCarbonForecastTimeframeIsTooShort_ShouldReturnFalse() {
        
        let carbonForecast = CarbonForecast(from: Date(),
                                            to: Date().addingTimeInterval(700),
                                            intensity: .init(forecast: 0,
                                                             actual: 0,
                                                             index: .low))
        
        let isStructureValid = sut.isCarbonForecastValid(carbonForecast)
        
        XCTAssertFalse(isStructureValid, "The isStructureValid() should have returned FALSE for timeframe shorter than 30 minutes but returned TRUE")
    }
    
    
    func testAPIStructureValidator_WhenCarbonForecastTimeframeIsTooLong_ShouldReturnFalse() {
        
        let carbonForecast = CarbonForecast(from: Date(),
                                            to: Date().addingTimeInterval(1900),
                                            intensity: .init(forecast: 0,
                                                             actual: 0,
                                                             index: .low))
        
        let isStructureValid = sut.isCarbonForecastValid(carbonForecast)
        
        XCTAssertFalse(isStructureValid, "The isStructureValid() should have returned FALSE for timeframe longer than 30 minutes but returned TRUE")
    }


}
