import Foundation
import SwiftyGPIO

class Platform {

    private let gpios = SwiftyGPIO.GPIOs(for: .RaspberryPiPlusZero)
    let taskService: TaskService
    let cpuMonitor: CpuMonitor
    
    init() {
        self.taskService = TaskService()
        self.cpuMonitor = CpuMonitor(taskService: taskService)
    }

}

let platform = Platform()
let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
    platform.cpuMonitor.loop()
}
RunLoop.main.add(timer, forMode: .default)
RunLoop.main.run()
