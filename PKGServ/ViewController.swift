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
    
    
    let server = HttpServer()
    var localIP :String = ""
    var port :String = "80"
    var serverStarted = true
    
    
    @IBOutlet weak var makeListforHan: NSButton!
    @IBOutlet weak var serverLblStat: NSTextField!
    @IBOutlet weak var localIPTextField: NSTextField!
    @IBOutlet weak var portTextField: NSTextField!
    @IBOutlet weak var test: NSTextField!



    
    @IBAction func openNetworkBtn(_ sender: Any) {NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Network.prefPane"))}
    @IBAction func openGitHub(_ sender: NSButton) {NSWorkspace.shared.open(URL(string: "https://github.com/qBor/PKGServ")!)}
    
@IBAction func fivepxGit(_ sender: Any) {NSWorkspace.shared.open(URL(string: "https://github.com/FivePixels")!)}
    @IBAction func whenSrvBtnPressed(_ sender: NSButton) {
         let portInt = UInt16(port)
        
        if serverStarted == true {
            
            
            
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
        
        else {
            
            do {
                try server.stop()
                print("Server has stopped.")
                
            } catch {
                print("Server stop error: \(error)")
            }
            

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

