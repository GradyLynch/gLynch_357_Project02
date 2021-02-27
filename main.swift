//
//  main.swift
//  gLynch_Project2
//
//  Created by cpsc on 2/26/21.
//  Copyright © 2021 cpsc. All rights reserved.
//
// using one late day

import Foundation

class Program
{
    init()
    {
        let file = FileIO()
        file.Read()
        
        var reply = ""
        var keepRunning = true
        
        while keepRunning
        {
            reply = Ask.AskQuestion(questionText: "Would you like to view all password names, view a password, add a password, or delete a password? (enter 'exit' to exit the application)", acceptableReplies: ["view all password names", "view a password", "add a password", "delete a password", "exit"])
            
            if reply.lowercased() == "exit"
            {
                keepRunning = false
            }
            
            if reply.lowercased() == "view all password names"
            {
                print(Array(file.dictionary.keys))
            }
            if reply.lowercased() == "add a password"
            {
                let tempName = Ask.AskQuestion(questionText: "What is the name that you want associated with this password?", acceptableReplies: [])
                let tempPassword = Ask.AskQuestion(questionText: "Please enter the password.", acceptableReplies: [])
                let tempPassphrase = Ask.AskQuestion(questionText: "Please enter your passphrase.", acceptableReplies: [])
                
                let scrambledPassword = Scramble(password: tempPassword, passphrase: tempPassphrase)
                file.dictionary[tempName] = scrambledPassword
                
                print("Your password for '" + tempName + "' has been saved.")
                print("")
                
                file.Write()
            }
            if reply.lowercased() == "delete a password"
            {
                let tempName = Ask.AskQuestion(questionText: "What is the name that the password you would like to delete is stored under? (case sensitive)", acceptableReplies: [])
                if let password = file.dictionary.removeValue(forKey: tempName)
                {
                    print("The password has been deleted.")
                    print("")
                }
                else
                {
                    print("There was no password found for " + tempName + ".")
                    print ("")
                }
                
                file.Write()
            }
            if reply.lowercased() == "view a password"
            {
                let tempName = Ask.AskQuestion(questionText: "What is the name that the password you want to view is stored under?", acceptableReplies: [])
                if let password = file.dictionary[tempName]
                {
                    let tempPassphrase = Ask.AskQuestion(questionText: "Please enter your passphrase.", acceptableReplies: [])
                    let descrambledPassword = Descramble(scrambledPassword: file.dictionary[tempName]!, passphrase: tempPassphrase)
                    print("The password that was saved under '" + tempName + "' and decoded with the passphrase '" + tempPassphrase + "' is '" + descrambledPassword + "'.")
                    print("")
                }
                else
                {
                    print("There was no password saved for " + tempName + ".")
                    print ("")
                }
            }
        }
    }
    
    func CeaserCipher(input: String) -> String
    {
        var alphabetLower: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        var alphabetUpper: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        var inputArray = Array(input)
        var counter = 0
        
        for character in input
        {
            for x in 0..<(alphabetLower.count - 1)
            {
                if character == alphabetLower[x]{
                    inputArray[counter] = alphabetLower[x+1]
                }
            }
            for y in 0..<(alphabetUpper.count - 1)
            {
                if character == alphabetUpper[y]{
                    inputArray[counter] = alphabetUpper[y+1]
                }
            }
            if character == alphabetLower[25]{
                inputArray[counter] = alphabetLower[0]
            }
            if character == alphabetUpper[25]{
                inputArray[counter] = alphabetUpper[0]
            }
            counter += 1
        }
        return String(inputArray)
    }
    
    func CeaserCipherInverse(input: String) -> String
    {
        var alphabetLower: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        var alphabetUpper: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        var inputArray = Array(input)
        var counter = 0
        
        for character in input
        {
            for x in 1..<(alphabetLower.count)
            {
                if character == alphabetLower[x]{
                    inputArray[counter] = alphabetLower[x-1]
                }
            }
            for y in 1..<(alphabetUpper.count)
            {
                if character == alphabetUpper[y]{
                    inputArray[counter] = alphabetUpper[y-1]
                }
            }
            if character == alphabetLower[0]{
                inputArray[counter] = alphabetLower[25]
            }
            if character == alphabetUpper[0]{
                inputArray[counter] = alphabetUpper[25]
            }
            counter += 1
        }
        return String(inputArray)
    }
    
    func Scramble(password: String, passphrase: String) -> String
    {
        var tempPassword = password
        tempPassword.append(passphrase)
        return CeaserCipher(input: String(tempPassword.reversed()))
    }
    
    func Descramble(scrambledPassword: String, passphrase: String) -> String
    {
        let tempPassword = String(scrambledPassword.reversed())
        let passwordLength = scrambledPassword.count - passphrase.count
        let tempSubstring = tempPassword.prefix(passwordLength)
        return CeaserCipherInverse(input: String(tempSubstring))
    }
    
}

let p = Program()

class Ask
{
    static func AskQuestion(questionText output: String, acceptableReplies inputArr: [String], caseSensitive: Bool = false) -> String
    {
        print(output)
        
        guard let response = readLine() else {
            print("Invalid input")
            return
                AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
        if (inputArr.contains(response) || inputArr.isEmpty)
        {
            return response
        }
        else
        {
            print("Invalid input")
            return
                AskQuestion(questionText: output, acceptableReplies: inputArr)
        }
        
    }
}

class FileIO
{
    public var dictionary: [String: String] = [:]
    
    func Write()
    {
        do{
            let fileURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("project2_passwords.json")
            
            try JSONSerialization.data(withJSONObject: dictionary).write(to: fileURL)
        } catch {
            print(error)
        }
    }
    func Read()
    {
        do{
            let fileURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("project2_passwords.json")
            
            let data = try Data(contentsOf: fileURL)
            let jsonResult = try JSONSerialization.jsonObject(with: data)
            if let jsonResult = jsonResult as? Dictionary<String, String>
            {
                dictionary = jsonResult
            }
        } catch {
            print(error)
        }
    }
}



