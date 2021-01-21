import Foundation
import SwiftyGPIO

struct Platform {

    private let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPiPlusZero)
    private let service = MonitoringService()

}

while true {
    Thread.sleep(forTimeInterval: 2)
}
