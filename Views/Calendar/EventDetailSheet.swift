import SwiftUI
import CoreData

struct EventDetailSheet: View {
    let events: [EventItem]
    let date: Date
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(events, id: \.id) { event in
                VStack(alignment: .leading) {
                    // 修改点：去掉 eventDate 后面的 ?
                    Text(event.eventDate.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(event.content)
                        .font(.body)
                }
            }
            .navigationTitle("\(date.formatted(date: .abbreviated, time: .omitted)) 备注")
            .toolbar {
                Button("关闭") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
