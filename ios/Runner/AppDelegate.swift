import Flutter
import UIKit
import workmanager
import home_widget

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // WorkManager initialization
    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
      GeneratedPluginRegistrant.register(with: registry)
    }

    // HomeWidget initialization
    if #available(iOS 17.0, *) {
      HomeWidgetPlugin.setAppGroupId("group.com.example.cryptowidget")
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
