//
//  DebouncedViewModel.swift
//  TikTokTutorial
//
//  Created by Bobby Guerra on 9/14/24.
//

import Combine
import SwiftUI

// !!!: Uses combine to set up debounce implementation
class DebounceViewModel: ObservableObject {
    @Published private(set) var isButtonDisabled: Bool = true
    private var currentEntries: [String: String] = [
        MediaPickerTextFields.title.rawValue: "",
        MediaPickerTextFields.caption.rawValue: ""]

    private var cancellables: Set<AnyCancellable> = []
    private var fieldSubjects: [String: PassthroughSubject<String, Never>] = [:]
    private let debounceTime: Double = 1
        
    init(initialFields: [String: String] = [:]) {
        self.currentEntries = initialFields
        for key in initialFields.keys {
            fieldSubjects[key] = PassthroughSubject<String, Never>()
            setupDebounce(for: key)
        }
        // Set initial field values
        for (key, value) in initialFields {
            fieldSubjects[key]?.send(value)
        }
    }
    
    private func setupDebounce(for key: String) {
        fieldSubjects[key]?
            .debounce(for: .seconds(debounceTime), scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self = self else { return }

                if value != currentEntries[key] {
                    currentEntries[key] = value
                    checkButtonState()
                    print("CURRENT ENTRIES: ", currentEntries as Any)
                }
            }
            .store(in: &cancellables)
    }
    
    private func checkButtonState() {
        print("Checking button state")
        // Evaluate the current state of all fields
        isButtonDisabled = currentEntries.values.allSatisfy { $0.isEmpty }
        print("Button disabled: \(isButtonDisabled)")
    }
    
    func updateField(_ key: String, value: String) {
        fieldSubjects[key]?.send(value)
    }
}
