//
//  ViewModel.swift
//  acsa
//
//  Created by Denzel Nyatsanza on 11/3/23.
//

import SwiftUI
import FirebaseFirestore

class ViewModel: ObservableObject {
    @Published var executives: [ExecutiveMember] = []
    
    let db = Firestore.firestore()

    init() {
        listenToChanges()
    }
    
    func updateSold(_ id: String, _ amount: Int) {
        let executivesCollection = db.collection("executives")
        executivesCollection.document(id).updateData(["soldCount":amount])
    }
    
    func updateCashOut(_ id: String, _ amount: Int) {
        let executivesCollection = db.collection("executives")
        executivesCollection.document(id).updateData(["cashOut":amount])
    }
    
    func listenToChanges() {
        // Get a reference to the Firestore database
        let db = Firestore.firestore()

        // Reference to the "executives" collection
        let executivesCollection = db.collection("executives")

        // Add a snapshot listener to the collection
        let listener = executivesCollection.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error listening for Firestore changes: \(error.localizedDescription)")
                return
            }

            if let snapshot {
                self.executives = snapshot.documents.map { $0.data().parseExecutive($0.documentID) }
            }
        }

    }
    
}

extension [String: Any] {
    func parseExecutive(_ id: String? = nil) -> ExecutiveMember {
        var _id = self["id"] as? String ?? UUID().uuidString
        if let id {
            _id = id
        }
        let name = self["name"] as? String ?? "Unknown Name"
        let role = self["role"] as? String ?? "Unknown Role"
        let soldTickets = self["soldTickets"] as? Int ?? 0
        let cashOut = self["cashOut"] as? Int ?? 0
        let timestamp = self["timestamp"] as? Double ?? 0
        let timestampApproval = self["timestampApproval"] as? Double
        
        return .init(id: _id, name: name, role: role, soldTickets: soldTickets, cashOut: cashOut, timestamp: timestamp, timestampApproval: timestampApproval)
    }
}
