//
//  SourceDocs.swift
//  SourceDocs
//
//  Created by Eneko Alonso on 10/5/17.
//

import Foundation
import Commandant
import Rainbow
import Curry
import SourceKittenFramework

public struct SourceDocs {
    static let version = "0.7.2"
    static let defaultOutputPath = "Documentation/Reference"
    static let defaultLinkEnding = ".md"
    static let defaultLinkBeginning = ""

    public init() {
        // this space for rent
    }
    public func run() {
        let registry = CommandRegistry<SourceDocsError>()
        registry.register(CleanCommand())
        registry.register(GenerateCommand())
        registry.register(VersionCommand())
        registry.register(HelpCommand(registry: registry))

        registry.main(defaultVerb: "help") { error in
            fputs("\(error.localizedDescription)\n)".red, stderr)
        }
    }
    
    public func runOnSPM(moduleName: String, outputDirectory: String) throws -> Result<(), SourceDocsError>{
        let options = GenerateCommandOptions(spmModule: moduleName, moduleName: nil, linkBeginningText: SourceDocs.defaultLinkBeginning, linkEndingText: SourceDocs.defaultLinkEnding, inputFolder: FileManager.default.currentDirectoryPath, outputFolder: outputDirectory, minimumAccessLevel: AccessLevel.private.rawValue, includeModuleNameInPath: true, clean: true, collapsibleBlocks: false, tableOfContents: true, xcodeArguments: [])
        
        if !FileManager.default.fileExists(atPath: "./.build/debug.yaml") {
            return .failure(SourceDocsError.internalError(message: "Please build the package first with `swift build`"))
        }
        
        return GenerateCommand().run(options)
    }
}
