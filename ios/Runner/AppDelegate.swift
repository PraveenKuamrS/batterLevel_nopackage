import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(name: "com.example.batterylevel_nopackage",
                                                  binaryMessenger: controller.binaryMessenger)

        batteryChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "getBatteryLevel" {
                self.receiveBatteryLevel(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func receiveBatteryLevel(result: FlutterResult) {
        // Enable battery monitoring
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true

        // Check if battery information is available
        if device.batteryState == .unknown {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Battery level not available.",
                                details: nil))
        } else {
            // Get the battery level as a percentage
            let batteryLevel = Int(device.batteryLevel * 100)
            result(batteryLevel)
        }
    }
}
