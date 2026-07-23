import SwiftUI

struct AddRecordView: View {
    @StateObject private var viewModel = AddRecordViewModel()
    @State private var showSavedAlert = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("备注")
                    .font(.headline)
                    .padding(.leading)
                
                TextEditor(text: $viewModel.content)
                    .frame(minHeight: 150)
                    .padding(8)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("选择日期")
                        .font(.headline)
                    DatePicker("日期", selection: $viewModel.eventDate, displayedComponents: [.date])
                        .datePickerStyle(.compact)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    viewModel.saveEvent()
                    showSavedAlert = true
                }) {
                    Text("保存记录")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .alert("保存成功", isPresented: $showSavedAlert) {
                    Button("好的", role: .cancel) { }
                }
            }
            .navigationTitle("新增待办")
        }
    }
}
