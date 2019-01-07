//
//  ViewController.swift
//  PKGServ
//
//  Created by Kevin Fosse on 04/01/2019.
//  Copyright © 2019 Kevin Fosse. All rights reserved.
//
// Cocoa : https://github.com/httpswift/swifter

// Tool made with the help of FivePixels
// https://github.com/FivePixels

import Cocoa
import Swifter



class ViewController: NSViewController {


    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let server = HttpServer()
    var localIP :String = ""
    var port :String = "80"
    var serverStarted = false
    var selectedPath:String = ""
    // let selectedPathURL = selectedPath
    
    let url = URL(fileURLWithPath: "" , isDirectory: true)
    
    @IBOutlet weak var makeListforHan: NSButton!
    @IBOutlet weak var serverLblStat: NSTextField!
    @IBOutlet weak var localIPTextField: NSTextField!
    @IBOutlet weak var portTextField: NSTextField!
    @IBOutlet weak var test: NSTextField!
    @IBOutlet weak var selectedPathLabel: NSTextField!
    
    
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            //if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {  // **ipv6 committed
            if addrFamily == UInt8(AF_INET){
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }

    
    func presentFolderSelection() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canCreateDirectories = false
        panel.title = "Select folder containing PKG file"
        
        panel.beginSheetModal(for:self.view.window!) { (response) in
            if response.rawValue == NSFileHandlingPanelOKButton {
                self.selectedPath = panel.url!.path
                // do whatever you what with the file path
                self.selectedPathLabel.stringValue = self.selectedPath
                print("User has selected : \(self.selectedPath)")
            }
            panel.close()
    }
    }
    
    func openPanel() {
        if serverStarted == true {
            let alert = NSAlert()
            alert.alertStyle = .critical
            alert.messageText = "Server running"
            alert.informativeText = "You cannot change the folder when the server is started"
            alert.runModal()
        } else {
            presentFolderSelection()
        }
    }
    

    func showFilewpkg(){
        //?
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
            if(selectedPath == "") { // if the user hasn't defined a path, make them do so.
                let alert = NSAlert()
                alert.alertStyle = .critical
                alert.messageText = "No selected folder"
                alert.informativeText = "Before starting the server, you must choose the folder containing the PKG."
                alert.runModal()
                presentFolderSelection()
            } else if serverStarted == false && selectedPath != "" { // if the server isn't started and the path has been defined, go ahead and start the server.
                serverStarted = !serverStarted
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
                    print("Server is live on port \(try server.port()).")
                    
                } catch {
                    print("Server start error: \(error)")
                }
                sender.title = "Stop Server"
                serverLblStat.textColor = NSColor.green
                serverLblStat.stringValue = "Server running on port \(port)"
            } else if serverStarted { // if the server is already running when the button is pressed, stop the server.
                serverStarted = !serverStarted
                server.stop()
                print("Server succesfully stopped.")
                sender.title = "Start Server"
                serverLblStat.textColor = NSColor.red
                serverLblStat.stringValue = "Server stopped"
        }
    }
    
    @IBAction func serverSettingsSaveBtn(_ sender: NSButton) {
           if serverStarted == true {test.stringValue = " You can't change PORT when the server has started"}
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
        if let addr = getWiFiAddress() {
            print(addr)
            localIPTextField.stringValue = addr
        } else {
            print("No WiFi address")
        }

        
        // ...
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

