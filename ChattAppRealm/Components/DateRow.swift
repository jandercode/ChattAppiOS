//
//  DateRow.swift
//  ChattAppRealm
//
//  Created by Joanne Yager on 2022-04-22.
//

import SwiftUI

struct DateRow: View {
    var timestampFormatter = TimestampFormatter()
    @State var timestamp: Date
    @State var dateString = ""
    
    var body: some View {
        Text(dateString)
            .foregroundColor(.gray)
            .font(.system(size: 13))
            .padding()
            .onAppear {
                dateString = timestampFormatter.formatDateString(timestamp: timestamp)
            }
    }
}

struct DateRow_Previews: PreviewProvider {
    static var previews: some View {
        DateRow(timestamp: Date())
    }
}
