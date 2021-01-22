//
//  TaskService+Argument.swift
//  Chekupot
//
//  Created by Andrew Chersky on 22.01.2021.
//

import Foundation

public extension TaskService {
    
    /// https://www.raspberrypi.org/documentation/raspbian/applications/vcgencmd.md
    
    enum Argument {
        
        /*
         
         Displays the enabled and detected state of the official camera.
         1 means yes, 0 means no.
         Whilst all firmware (except cutdown versions) will support the camera, this support needs to be enabled by using raspi-config.
         
         */
        case getCamera
        
        /*
         Returns the throttled state of the system. This is a bit pattern - a bit being set indicates the following meanings:
         
         
         *********************************************************
         * Bit * Hex Value *              Meaning                *
         *********************************************************
         *  0  *     1     * Under-voltage detected              *
         *  1  *     2     * Arm frequency capped                *
         *  2  *     4     * Currently throttled                 *
         *  3  *     8     * Soft temperature limit active       *
         *  16 *   10000   * Under-voltage has occurred          *
         *  17 *   20000   * Arm frequency capping has occurred  *
         *  18 *   40000   * Throttling has occurred             *
         *  19 *   80000   * Soft temperature limit has occurred *
         *********************************************************
         
         A value of zero indicates that none of the above conditions is true.

         To find if one of these bits has been set, convert the value returned to binary, then number each bit along the top. You can then see which bits are set. For example:

         0x50000 = 0101 0000 0000 0000 0000

         Adding the bit numbers along the top we get:

         19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
          0  1  0  1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0
         From this we can see that bits 18 and 16 are set, indicating that the Pi has previously been throttled due to under-voltage, but is not currently throttled for any reason.

         Alternately, the values can be derived using the hex values above, by successively subtracting the largest value:

         0x50000 = 40000 + 10000
         
         */
        case getThrottled
        
        /*
         
         Returns the temperature of the SoC as measured by the on-board temperature sensor.
         
         */
        case measureTemp
        
        /*
         Displays the current voltages used by the specific block.

         * * * * * * * * * * * * * * * * *
         *   Block  *     Description    *
         * * * * * * * * * * * * * * * * *
         * core     * VC4 core voltage   *
         * sdram_c  * SDRAM Core Voltage *
         * sdram_i  * SDRAM I/O voltage  *
         * sdram_p  * SDRAM Phy Voltage  *
         * * * * * * * * * * * * * * * * *
         */
        
        case measureVolts(MVArgument)
        
        /*
         Reports on the amount of memory allocated to the ARM cores vcgencmd get_mem arm and the VC4 vcgencmd get_mem gpu.
         */
        case getMemory(GMArgument)
        
        /*
         Displays the resolution and colour depth of any attached display.
         */
        case getLcdInfo
        
        /*
         This returns the current frequency of the specified clock. The options are:
         
        * * * * * * * * * * * * * * * * * * * * * * * * *
        *  clock  *             Description             *
        * * * * * * * * * * * * * * * * * * * * * * * * *
        *  arm   *  ARM cores                           *
        *  core  *  VC4 scaler cores                    *
        *  H264  *  H264 block                          *
        *  isp   *  Image Signal Processor              *
        *  v3d   *  3D block                            *
        *  uart  *  UART                                *
        *  pwm   *  PWM block (analogue audio output)   *
        *  emmc  *  SD card interface                   *
        *  pixel *  Pixel valve                         *
        *  vec   *  Analogue video encoder              *
        *  hdmi  *  HDMI                                *
        *  dpi   *  Display Peripheral Interface        *
        * * * * * * * * * * * * * * * * * * * * * * * * *
         */
        case measureClock
        
    }
    
}

extension TaskService.Argument {
    
    var argument: String {
        switch self {
        case .getCamera: return "get_camera"
        case .getThrottled: return "get_throttled"
        case .measureTemp: return "measure_temp"
        case .measureVolts: return "measure_volts"
        case .getMemory: return "get_mem"
        case .getLcdInfo: return "get_lcd_info"
        case .measureClock: return "measure_clock"
        }
    }
    
    var subarguments: String? {
        switch self {
        case .getMemory(let subargument): return subargument.rawValue
        case .measureVolts(let subargument): return subargument.rawValue
        default: return nil
        }
    }
    
}

public extension TaskService.Argument {
    
    // Measure Volts Arguments
    enum MVArgument: String {
        case core
        case sdram_c
        case sdram_i
        case sdram_p
    }
    
    enum GMArgument: String {
        case arm
        case gpu
    }
    
    enum MCArgument: String {
        case arm
        case core
        case H264
        case isp
        case v3d
        case uart
        case pwm
        case emmc
        case pixel
        case vec
        case hdmi
        case dpi
    }
    
}
