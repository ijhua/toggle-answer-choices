//
//  ContentView.swift
//  ControllertoLetter
//
//  Created by Isabelle Hua on 10/10/24.
//
import SwiftUI
import AppKit

struct ContentView: View {
    var letters = ["A", "B", "C", "D", "E", "F", "G"]
    @State private var currentIndex = 0
    @State private var selectedLetter = ""
    @State private var lastPressedKey = "" // Store last pressed key

    var body: some View {
        VStack {
            Text("Selected: \(selectedLetter)")
                .font(.largeTitle)
                .padding()
            
            Text("Last pressed: \(lastPressedKey)")
                .font(.headline)
                .padding()

            List {
                ForEach(letters.indices, id: \.self) { index in
                    Text(letters[index])
                        .font(.largeTitle)
                        .foregroundColor(index == currentIndex ? .white : .black)
                        .background(index == currentIndex ? Color.blue : Color.clear)
                }
            }
            .frame(height: 200)

            HStack {
                Button(action: {
                    if currentIndex > 0 {
                        currentIndex -= 1
                    }
                }) {
                    Text("1. Up")
                }
                .frame(width: 100, height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .keyboardShortcut("1", modifiers: [])

                Button(action: {
                    if currentIndex < letters.count - 1 {
                        currentIndex += 1
                    }
                }) {
                    Text("2. Down")
                }
                .frame(width: 100, height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .keyboardShortcut("2", modifiers: [])

                Button(action: {
                    selectedLetter = letters[currentIndex]
                    print("Selected letter: \(selectedLetter)")
                }) {
                    Text("4. Submit")
                }
                .frame(width: 100, height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .keyboardShortcut("4", modifiers: [])
            }
            .padding()
        }
        .onAppear {
            startGlobalKeyPressObserver()
        }
    }

    func startGlobalKeyPressObserver() {
        // Capture all key presses globally (even when app is not focused)
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            if let characters = event.charactersIgnoringModifiers {
                DispatchQueue.main.async {
                    lastPressedKey = characters // Update the last pressed key
                }

                // You can choose to perform actions for specific keys if needed
                switch characters {
                case "1":
                    if currentIndex > 0 {
                        currentIndex -= 1
                    }
                case "2":
                    if currentIndex < letters.count - 1 {
                        currentIndex += 1
                    }
                case "4":
                    selectedLetter = letters[currentIndex]
                    print("Selected letter: \(selectedLetter)")
                default:
                    break
                }
            }
        }
    }
    private func checkPermissions() -> Bool {
            if (AXIsProcessTrusted() == false) {
                print("Need accessibility permissions!")
                let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
                AXIsProcessTrustedWithOptions(options)
                
                return false;
            } else {
                print("Accessibility permissions active")
                return true;
            }
        }
}
