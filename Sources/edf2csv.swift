// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import Foundation
import ArgumentParser
import EDF

@main
struct edf2csv: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "edf2csv",
        abstract: "Convert an EDF file to a CSV file.",
        version: "0.1.0"
    )

    @Argument(help: "Path to the input EDF file.")
    var inputPath: String

    @Option(name: [.short, .long], help: "Path to the output CSV file.")
    var output: String?

    @Option(name: .long, help: "Aggregation method: mean, mode, max, min.")
    var aggregate: AggregateMethod = .mean

    @Option(name: .long, help: "CSV delimiter character.")
    var delimiter: String = ","

    @Flag(name: .long, help: "Do not include a header row.")
    var noHeader: Bool = false

    var fileManager: FileManager { .default }

    mutating func run() throws {
        let url = URL(fileURLWithPath: inputPath)
        let edf = try EDFFile(url: url)

        let outputURL = try createOutputFile()
        guard let outputStream = OutputStream(url: outputURL, append: true) else {
            return
        }
        outputStream.open()
        defer { outputStream.close() }

        let signalInfos = try edf.signalInfos

        if !noHeader {
            let labels = ["timestamp"] + signalInfos.filter({ !$0.isAnnotation }).map(\.label)
            let line = labels.joined(separator: delimiter) + "\n"
            outputStream.writeString(line)
        }

        for row  in 0 ..< edf.header.numberOfRecords {
            var components: [String] = ["\(try edf.timestamp(for: row))"]
            for column in 0 ..< edf.header.numberOfSignals {
                if signalInfos[column].isAnnotation { continue }
                if let values = try edf.record(for: column, at: row), !values.isEmpty,
                   let value = values.aggregate(with: aggregate) {
                    components.append("\(value)")
                } else {
                    components.append("")
                }
            }
            let line = components.joined(separator: delimiter) + "\n"
            outputStream.writeString(line)
        }
    }
}

extension edf2csv {
    private func createOutputFile() throws -> URL {
        let inputURL = URL(fileURLWithPath: inputPath)
        let outputURL = if let output {
            URL(fileURLWithPath: output)
        } else {
            inputURL.deletingPathExtension().appendingPathExtension("csv")
        }

        fileManager.createFile(atPath: outputURL.path, contents: nil)

        return outputURL
    }
}

extension OutputStream {
    func writeString(_ string: String) {
        guard let data = string.data(using: .utf8) else {
            fatalError("Couldn't convert string to Data")
        }
        data.withUnsafeBytes {
            guard let baseAddress = $0.baseAddress else { return }
            write(baseAddress, maxLength: data.count)
        }
    }
}

extension EDFFile {
    func timestamp(for row: Int) throws -> Double {
        if let annotation = try annotation(at: row),
           let timestamp = annotation.timestamp {
            return timestamp
        }
        return header.durationOfRecord * Double(row)
    }
}

extension Array where Element: FixedWidthInteger {
    func aggregate(with method: AggregateMethod) -> Element? {
        switch method {
        case _ where count == 1: self[0]
        case .mean: mean
        case .mode: mode
        case .max: max
        case .min: min
        }
    }

    var mean: Element? {
        guard !isEmpty else { return nil }
        let sum = reduce(0, { $0 + Int64($1)  }) // avoid overflow
        return Element(
            round(
                Double(sum) / Double(count)
            )
        )
    }

    var mode: Element? {
        guard !isEmpty else { return nil }
        let frequency = Dictionary(grouping: self, by: { $0 }).mapValues { $0.count }
        let maxFrequency = frequency.values.max()
        return frequency.first(where: { $0.value == maxFrequency })?.key
    }

    var max: Element? {
        return self.max()
    }

    var min: Element? {
        return self.min()
    }
}
