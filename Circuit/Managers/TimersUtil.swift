import Foundation
import UserNotifications
import BackgroundTasks

/// Utility for scheduling local notifications and ensuring they fire even if the
/// app is suspended, by registering a `BGProcessingTask`.
/// Heavily inspired by Foqos' implementation – simplified for Circuit.
final class TimersUtil {
    // Identifier used when registering with BGTaskScheduler & UserDefaults.
    private static let backgroundProcessingTaskIdentifier = "app.circuit.backgroundprocessing"
    private static let userDefaultsKey = "app.circuit.backgroundtasks"

    // MARK: - Stored pending tasks
    private var storedTasks: [String: [String: Any]] {
        get {
            UserDefaults.standard.dictionary(forKey: Self.userDefaultsKey) as? [String: [String: Any]] ?? [:]
        }
        set { UserDefaults.standard.set(newValue, forKey: Self.userDefaultsKey) }
    }

    // MARK: - Public registration (call at launch)
    static func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundProcessingTaskIdentifier, using: nil) { task in
            guard let processingTask = task as? BGProcessingTask else {
                task.setTaskCompleted(success: false)
                return
            }
            Self.handle(processingTask)
        }
    }

    // MARK: - Notification scheduling
    @discardableResult
    func scheduleNotification(title: String, message: String, seconds: TimeInterval, identifier: String = UUID().uuidString) -> String {
        // Build notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { print("[TimersUtil] Notification error: \(error)") }
        }

        // Mirror as background task for extra reliability
        scheduleBackgroundTask(id: UUID().uuidString, executionTime: Date().addingTimeInterval(seconds), notificationId: identifier)
        return identifier
    }

    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Self.backgroundProcessingTaskIdentifier)
        storedTasks = [:]
    }

    // MARK: - BGTask handling
    private static func handle(_ task: BGProcessingTask) {
        let util = TimersUtil()
        let now = Date()

        var remaining = util.storedTasks
        for (taskId, info) in util.storedTasks where (info["executionTime"] as? Date ?? .distantFuture) <= now {
            // Fire any custom observers if needed.
            NotificationCenter.default.post(name: Notification.Name("CircuitBackgroundTaskExecuted"), object: nil, userInfo: ["taskId": taskId])
            // Remove executed task.
            remaining.removeValue(forKey: taskId)
        }
        util.storedTasks = remaining

        // Schedule next
        if !remaining.isEmpty { util.scheduleBGProcessing() }
        task.setTaskCompleted(success: true)
    }

    private func scheduleBGProcessing() {
        let request = BGProcessingTaskRequest(identifier: Self.backgroundProcessingTaskIdentifier)
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = false

        // earliest execution = earliest stored task.
        if let earliest = storedTasks.values.compactMap({ $0["executionTime"] as? Date }).min() {
            request.earliestBeginDate = earliest
        }
        do { try BGTaskScheduler.shared.submit(request) } catch {
            print("[TimersUtil] Failed to submit BGProcessingTask: \(error)")
        }
    }

    private func scheduleBackgroundTask(id taskId: String, executionTime: Date, notificationId: String) {
        var tasks = storedTasks
        tasks[taskId] = ["executionTime": executionTime, "notificationId": notificationId]
        storedTasks = tasks
        scheduleBGProcessing()
    }
}