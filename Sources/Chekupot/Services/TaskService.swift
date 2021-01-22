//
//  TaskService.swift
//  
//
//  Created by Andrew Chersky on 21.01.2021.
//

import Foundation

public final class CpuMonitor {
    
    // Thanks to http://colby.id.au/calculating-cpu-usage-from-proc-stat/
    
    private weak var taskService: TaskService!
    
    private(set) var idle: Int = 0
    private(set) var total: Int = 0
    private(set) var usage: Float = 0
    
    init(taskService: TaskService) {
        self.taskService = taskService
    }
    
    public func loop() {
        let stat = taskService.procStat(qualityOfService: .background)
        guard let cpu = stat
                .range(of:  "cpu[ ]+(\\d+[ ]?)+", options: .regularExpression)
                .map({ String(stat[$0]) })?
                .split(separator: " ")
                .compactMap({ Int($0) }) else { return }
        let idle = cpu[3]
        let total = cpu.reduce(0, +)
        let diffIdle = idle - self.idle
        let diffTotal = Float(total) - Float(self.total)
        self.usage = 100 * (diffTotal - Float(diffIdle)) / diffTotal
        print("Usage: \(usage)")
        self.idle = idle
        self.total = total
        usleep(1000000)
    }
    
}

public final class TaskService {
    
    public func procStat(qualityOfService: QualityOfService = .background) -> String {
        let pipe = Pipe()
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/cat")
        task.arguments = ["/proc/stat"]
        task.standardOutput = pipe
        task.qualityOfService = qualityOfService
        try? task.run()
        return String(
            data: pipe.fileHandleForReading.readDataToEndOfFile(),
            encoding: .utf8
        ) ?? ""
    }
    
    public func lscpu(qualityOfService: QualityOfService = .background) -> String {
        let task = Process()
        let pipe = Pipe()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/lscpu")
        task.standardOutput = pipe
        task.qualityOfService = qualityOfService
        try? task.run()
        return String(
            data: pipe.fileHandleForReading.readDataToEndOfFile(),
            encoding: .utf8
        ) ?? ""
    }
    
    public func gpuTemp(qualityOfService: QualityOfService = .background) -> String {
        let task = Process()
        let pipe = Pipe()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/")
        task.arguments = ["cat", "/sys/class/thermal/thermal_zone0/temp"]
        task.standardOutput = pipe
        task.qualityOfService = qualityOfService
        try? task.run()
        return String(
            data: pipe.fileHandleForReading.readDataToEndOfFile(),
            encoding: .utf8
        ) ?? ""
    }
    
    public func vcgenmd(_ argument: Argument, qualityOfService: QualityOfService = .background) -> String {
        let task = Process()
        let pipe = Pipe()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/vcgencmd")
        task.qualityOfService = qualityOfService
        task.arguments = [argument.argument, argument.subarguments ?? ""]
        task.standardOutput = pipe
        try? task.run()
        return String(
            data: pipe.fileHandleForReading.readDataToEndOfFile(),
            encoding: .utf8
        ) ?? ""
    }
    
}
