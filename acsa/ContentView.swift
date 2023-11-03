//
//  ContentView.swift
//  acsa
//
//  Created by Denzel Nyatsanza on 10/31/23.
//

import SwiftUI

struct ExecutiveMember: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var role: String
    var soldTickets: Int = 0
    var cashOut: Int = 0
    var timestamp: Double = 0
    var timestampApproval: Double?
}

struct ContentView: View {
    @State var text: Int = 0
    @State var amount: Int = 0

    @StateObject var viewModel = ViewModel()
    @State var selectedExec: ExecutiveMember?
    
    var executives: [ExecutiveMember] {
        return viewModel.executives
    }
  
    
    
    var body: some View {

        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("ACSA")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.linearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                        Text("AKN Ticket Manager")
                            .font(.subheadline)
                    }
                    Spacer()
                    Menu {
                        ForEach(executives) { exec in
                            Button(exec.name) {
                                withAnimation(.spring()) {
                                    selectedExec = exec
                                }
                            }
                        }
                    } label: {
                        
                        Text(selectedExec == nil ? "Select Name":selectedExec!.name)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(10)
                            .padding(.horizontal)
                            .background(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .clipShape(.rect(cornerRadius: 10, style: .continuous))
                    }
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Overview")
                        .bold()
                        .foregroundStyle(.secondary)
                    HStack {
                        
                        VStack(alignment: .leading) {
                            Text("210")
                                .font(.title.bold())
                            Text("Sold")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("$4200")
                                .font(.title.bold())
                            Text("Expected")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(.horizontal)
                VStack(alignment: .leading) {
                    if let selectedExec {
                        Divider()
                            .padding(.vertical)
                        
                        Text("\(selectedExec.name) - You")
                            .bold()
                            .foregroundStyle(.secondary)
                        HStack {
                            Text("I have sold")
                                .font(.title3)
                            Spacer()
                            TextField("No. of Tickets", value: $text, formatter: NumberFormatter())
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .frame(width: 80)
                                .padding(.vertical, 7)
                                .background(Color.secondary.opacity(0.3))
                                .clipShape(.rect(cornerRadius: 12, style: .continuous))
                                .onChange(of: text) { value in
                                    viewModel.updateSold(selectedExec.id, value)
                                }
                        }
                        HStack {
                            Text("I have cashed out")
                                .font(.title3)
                            Spacer()
                            TextField("Amount", value: $amount, formatter: NumberFormatter())
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .frame(width: 80)
                                .padding(.vertical, 7)
                                .background(Color.secondary.opacity(0.3))
                                .clipShape(.rect(cornerRadius: 12, style: .continuous))
                                .onChange(of: text) { value in
                                    viewModel.updateSold(selectedExec.id, value)
                                }
                        }
                        HStack {
                            Text("You have contributed")
                                .font(.subheadline)
                                .italic()
                            Spacer()
                            Text("$290")
                                .font(.subheadline)
                                .italic()
                        }
                    } else {
                        Text("Please Select Your Name top right to make changes for yourself:)")
                            .foregroundStyle(.gray)
                            .padding(.vertical)
                    }
                    
                }
                .padding()
                .background(Color.background)
                .clipShape(.rect(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.2), radius: 30, x: 0, y: 8)
                VStack {
                    
                    HStack {
                        Text("Exec")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                        Spacer()
                        HStack {
                            Text("Sold")
                                .font(.subheadline.bold())
                                .foregroundStyle(.secondary)
                            Divider()
                                .frame(height: 10)
                                .padding(.horizontal)
                            Text("$ Out")
                                .font(.subheadline.bold())
                                .foregroundStyle(.secondary)
                        }
                            
                    }
                    
                    ForEach(executives) { exec in
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(exec.name)
                                        .font(.title3)
                                    Text(exec.role)
                                        .font(.headline)
                                }
                                Spacer()
                                HStack {
                                    Text("\(exec.soldTickets)")
                                        .font(.title2)
                                    Divider()
                                        .frame(height: 10)
                                        .padding(.horizontal)
                                    Text("\(exec.cashOut)")
                                        .font(.title2)
                                }
                            }
                            HStack {
                                if let time = exec.timestampApproval {
                                    Text("Approved by Brenda \(time.formattedTimestamp())")
                                        .font(.caption)
                                        .foregroundStyle(.green)
                                }
                                Spacer()
                                Text(exec.timestamp == 0 ? "No updates yet":"Last Updated \(exec.timestamp.formattedTimestamp())")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)

                            }
                            Divider()
                        }
                    }
                }
                .padding(.horizontal)
                
            }
            .padding()
        }
        .background(Color.background)
        .scrollDismissesKeyboard(.immediately)
    }
}


extension Double {
    func formattedTimestamp() -> String {
        let date = Date(timeIntervalSince1970: self)
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(date) {
            return "today"
        } else if calendar.isDateInYesterday(date) {
            return "yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            return dateFormatter.string(from: date)
        }
    }
}
