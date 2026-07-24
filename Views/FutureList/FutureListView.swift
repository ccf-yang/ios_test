import SwiftUI

struct FutureListView: View {
    @StateObject private var viewModel = FutureListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.futureEvents, id: \.id) { event in
                    VStack(alignment: .leading) {
                        Text(event.eventDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(event.content ?? "")
                            .font(.body)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: viewModel.deleteEvent)
            }
            .navigationTitle("未来事项")
        }
        .onAppear {
            viewModel.fetchFutureEvents()
        }
    }
}
