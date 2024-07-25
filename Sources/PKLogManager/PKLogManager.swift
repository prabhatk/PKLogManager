// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import Zip

public class PKLogManager {
    public static let shared = PKLogManager()
    
    private let fileManager = FileManager.default
    private var logDirectory: URL
    private var logFileURL: URL
    private var maxDays: Int
    private let dateFormatter: DateFormatter
    private let logDateFormatter: DateFormatter
    
    private init(maxDays: Int = 7) {
        // Set the default maximum days to 7 if not provided
        self.maxDays = maxDays
        
        // Initialize the date formatter
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        logDateFormatter = DateFormatter()
        logDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        
        // Set up the log directory and file URL
        logDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Logs")
        logFileURL = logDirectory.appendingPathComponent(dateFormatter.string(from: Date())).appendingPathExtension("txt")
        
        // Create the log directory if it doesn't exist
        createLogDirectory()
        
        // Rotate logs if necessary
        rotateLogs()
    }
    
    private func createLogDirectory() {
        if !fileManager.fileExists(atPath: logDirectory.path) {
            do {
                try fileManager.createDirectory(at: logDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating log directory: \(error)")
            }
        }
    }
    
    private func rotateLogs() {
        do {
            let logFiles = try fileManager.contentsOfDirectory(at: logDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            let currentDate = Date()
            for logFile in logFiles {
                if let creationDate = try? logFile.resourceValues(forKeys: [.creationDateKey]).creationDate {
                    let daysOld = Calendar.current.dateComponents([.day], from: creationDate, to: currentDate).day ?? 0
                    if daysOld >= maxDays {
                        try fileManager.removeItem(at: logFile)
                    }
                }
            }
        } catch {
            print("Error rotating logs: \(error)")
        }
    }
    
    public func log(_ topic: String = "Log", message: String) {
        let timestamp = logDateFormatter.string(from: Date())
        let logMessage = "[\(timestamp)] [\(topic)] \(message)\n"
        
        if !fileManager.fileExists(atPath: logFileURL.path) {
            fileManager.createFile(atPath: logFileURL.path, contents: nil, attributes: nil)
        }
        
        if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
            fileHandle.seekToEndOfFile()
            if let data = logMessage.data(using: .utf8) {
                fileHandle.write(data)
            }
            fileHandle.closeFile()
        } else {
            print("Error opening log file for writing.")
        }
    }
    
    public func setMaxDays(_ days: Int) {
        self.maxDays = days
        rotateLogs()
    }
    
    public func zipLogs() -> URL? {
        let zipFileName = "logs.zip"
        let zipFileURL = logDirectory.appendingPathComponent(zipFileName)
        
        do {
            if fileManager.fileExists(atPath: zipFileURL.path) {
                try fileManager.removeItem(at: zipFileURL)
            }
            
            try Zip.zipFiles(paths: [logDirectory], zipFilePath: zipFileURL, password: nil, progress: nil)
            return zipFileURL
        } catch {
            print("Error creating zip file: \(error)")
            return nil
        }
    }
}
