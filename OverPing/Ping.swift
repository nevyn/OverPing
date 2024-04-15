//
//  Ping.swift
//  OverPing
//
//  Created by Nevyn Bengtsson on 1/8/17.
//  Copyright © 2017 Nevyn Bengtsson. All rights reserved.
//

import Cocoa

// requires root to do it properly :(
// http://stackoverflow.com/a/15573612/48125
// so let's just fork...

// EXPECTED REPLIES:
// Request timeout for icmp_seq 11815
// ping: cannot resolve 1.1.1.1: Unknown host
// 64 bytes from 1.1.1.1: icmp_seq=0 ttl=53 time=2492.276 ms


class Ping: NSObject {
    weak var delegate : PingDelegate?
    var secs : Double?
    var error : Error?
    
    var task : Process! = Process()
    var standardOut : Pipe! = Pipe()
    var standardErr : Pipe! = Pipe()
    
    func run()
    {
        task.launchPath = "/sbin/ping"
        task.arguments = ["-c", "1", "1.1.1.1"]
        task.standardOutput = standardOut
        task.standardError = standardErr
        task.terminationHandler = terminationHandler
        if let error = task.tc_launchWithoutExceptions() {
            self.error = error
            self.delegate?.ping(self, failedWithError: self.error!)
        }
        
    } // run()
    
    func terminationHandler(task : Process) {
        let out = NSString(data: self.standardOut.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue)!
        let err = NSString(data: self.standardErr.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8.rawValue)!
        
        // release resources
        self.standardOut = nil
        self.standardErr = nil
        self.task = nil
        
        DispatchQueue.main.async {
            self.handleEndOnMain(out: out, err: err)
        }
    }
    func handleEndOnMain(out: NSString, err: NSString)
    {
        guard err.length == 0 else {
            self.error = PingError.unknown(reason: err as String)
            self.delegate?.ping(self, failedWithError: self.error!)
            return
        }
        let lines = out.components(separatedBy: "\n")
        guard lines.count >= 6 else {
            self.error = PingError.unknown(reason: out as String)
            self.delegate?.ping(self, failedWithError: self.error!)
            return
        }
        
        let pingLine = lines[1]
        
        guard !pingLine.hasPrefix("Request timeout") else {
            self.error = PingError.pingTimeout
            self.delegate?.ping(self, failedWithError: self.error!)
            return
        }
        
        let msRegex = try! NSRegularExpression(pattern: "64 bytes from 1.1.1.1: icmp_seq=0 ttl=.+ time=(.+) ms")
        guard let results = msRegex.firstMatch(in: out as String, range: NSRange(location: 0, length: out.length)) else {
            self.error = PingError.unknown(reason: out as String)
            self.delegate?.ping(self, failedWithError: self.error!)
            return
        }
        let msString = out.substring(with: results.range(at: 1)) as NSString
        let secs = msString.doubleValue/1000.0
        
        self.secs = secs
        self.delegate?.ping(self, didFinishWithTime: secs)
    }
}

enum PingError: Error {
    case unknownHost
    case pingTimeout
    case unknown(reason: String)
}


protocol PingDelegate : NSObjectProtocol
{
    func ping(_ ping: Ping, didFinishWithTime time: Double)
    func ping(_ ping: Ping, failedWithError err: Error)
}
