import Foundation

class UnitConverterSpeed: UnitConverter
{
    
    private let coefficient: Double
    
    init(coefficient: Double)
    {
        self.coefficient = coefficient
    }
    
    override func baseUnitValue(fromValue value: Double) -> Double
    {
        return reciprocal(value * coefficient)
    }
    
    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double
    {
        return reciprocal(baseUnitValue * coefficient)
    }
    
    private func reciprocal(_ value: Double) -> Double
    {
        guard value != 0 else { return 0 }
        return 1.0 / value
    }
}

//NOT GOOD 

extension UnitSpeed
{
    class var nauticalMiles: UnitSpeed
    {
        return UnitSpeed(symbol: "nm", converter: UnitConverterSpeed(coefficient: 1.0 / 1.66)) //TEST
    }
    
}
