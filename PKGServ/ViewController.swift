//
//  ViewController.swift
//  PKGServ
//
//  Created by Kevin Fosse on 04/01/2019.
//  Copyright © 2019 Kevin Fosse. All rights reserved.
//
// Cocoa : https://github.com/httpswift/swifter

// Tool made with the help of FivePixel
// https://github.com/FivePixels

import Cocoa
import Swifter


class ViewController: NSViewController {


    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let server = HttpServer()
    var localIP :String = ""
    var port :String = "80"
    var serverStarted = true
    var selectedPath:String = ""
    // let selectedPathURL = selectedPath
    
    let url = URL(fileURLWithPath: "" , isDirectory: true)
    
    @IBOutlet weak var makeListforHan: NSButton!
    @IBOutlet weak var serverLblStat: NSTextField!
    @IBOutlet weak var localIPTextField: NSTextField!
    @IBOutlet weak var portTextField: NSTextField!
    @IBOutlet weak var test: NSTextField!
    @IBOutlet weak var selectedPathLabel: NSTextField!
    
    func openPanel() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.title = "Select PKG folder"
        
        openPanel.beginSheetModal(for:self.view.window!) { (response) in
            if response.rawValue == NSFileHandlingPanelOKButton {
                self.selectedPath = openPanel.url!.path
                // do whatever you what with the file path
                self.selectedPathLabel.stringValue = self.selectedPath
                print("User has selected : \(self.selectedPath)")
                
                
            }
            openPanel.close()
            
        }
    }
    

    func showFilewpkg(){
        
            
        
        

    }
    
    @IBAction func openFolder(_ sender: NSButton) {
        openPanel()
    }
    
 
    
    
    // Open Network preference
    @IBAction func openNetworkBtn(_ sender: Any) {NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Network.prefPane"))}
    
    // open kevxxf Git
    @IBAction func openGitHub(_ sender: NSButton) {NSWorkspace.shared.open(URL(string: "https://github.com/qBor/PKGServ")!)}
    
    // open 5PX Git
    @IBAction func fivepxGit(_ sender: Any) {NSWorkspace.shared.open(URL(string: "https://github.com/FivePixels")!)}
    
    // Button to start/stop server
    @IBAction func whenSrvBtnPressed(_ sender: NSButton) {
         let portInt = UInt16(port)
        
        if serverStarted == true {
            
            if(selectedPath == "") {
                let alert = NSAlert()
                alert.alertStyle = .critical
                alert.messageText = "No selected folder"
                alert.informativeText = "Before starting the server, you must choose the folder containing the PKG."
                alert.runModal()
                openPanel()
                
            }
            else {
            server["/PKG/:path"] = shareFilesFromDirectory(selectedPath)
            server["/"] = scopes {
                html {
                    body {
                        center {
                            img { src = "http://www.psx-place.com/styles/nerva/xenforo/logo.png" }
                            h1 {
                                inner="Welcome to the PS3 PKGServer"
                            }
                            p {inner="Made by @kevxxf with help of @FivePixel"}
                            
                        }
                    }
                }
            }
            server["/files/:path"] = directoryBrowser("/")
            
            
            do {
                try server.start(portInt!, forceIPv4: true)
                print("Server has started ( port = \(try server.port()) ). Try to connect now...")
                
            } catch {
                print("Server start error: \(error)")
            }
                // -----
                sender.title = "Stop server"
                serverLblStat.textColor = NSColor.green
                serverLblStat.stringValue = "Server running on port \(port)"
                serverStarted = !serverStarted;
            }

            
         
        }
        
        else {
            
            server.stop()
            

            // -----------
            sender.title = "Start server"
            serverLblStat.textColor = NSColor.red
            serverLblStat.stringValue = "Server stopped"
            serverStarted = !serverStarted;
        }
    }
    
    @IBAction func serverSettingsSaveBtn(_ sender: NSButton) {
           if serverStarted != true {test.stringValue = " You can't change PORT when the server has started"}
         else if localIPTextField.stringValue != "" && portTextField.stringValue != "" {
            localIP = localIPTextField.stringValue
            port = portTextField.stringValue
        test.stringValue = "Local IP set to \(localIP) and port to \(port)"
            
        makeListforHan.isEnabled = true}
        
      
            
        else {test.stringValue = "Error ! Both fields must be filled in ! "
            makeListforHan.isEnabled = false
        }
    }
   

    
    @IBAction func helpButtonOnSettings(_ sender: NSButton) {
        let Alert = NSAlert()
        Alert.alertStyle = .informational
        Alert.messageText = "How to obtain my local IP?"
        Alert.informativeText = "To obtain your Local IP address, you must go to the system > network preferences and it will be displayed under 'Status'."
        
        Alert.runModal()
        
    }
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        
        
        // ...
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

