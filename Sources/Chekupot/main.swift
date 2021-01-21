import Foundation
import SwiftyGPIO

struct Platform {

    private let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPiPlusZero)
    let service = MonitoringService()

}

let platform = Platform()

while true {
    let string = platform.service.execute(.measureTemp)
    print(string)
    Thread.sleep(forTimeInterval: 2)
}
