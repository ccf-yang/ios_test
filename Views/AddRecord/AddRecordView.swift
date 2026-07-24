import SwiftUI

struct AddRecordView: View {
    @StateObject private var viewModel = AddRecordViewModel()
    @State private var showSavedAlert = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("备注")
                    .font(.headline)
                    .padding(.horizontal)
                
                // 1. 修复 TextEditor：使用固定高度 + 添加边框
                TextEditor(text: $viewModel.content)
                    .focused($isFocused)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1) // 明确添加可见边框
                    )
                    .padding(.horizontal)
                
                Text("选择日期")
                    .font(.headline)
                    .padding(.horizontal)
                
                // 2. 修复 DatePicker：移除默认内边距，与 TextEditor 宽度对齐
                DatePicker("", selection: $viewModel.eventDate, displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .environment(\.locale, Locale(identifier: "zh_CN"))
                    .frame(maxWidth: .infinity, alignment: .leading) // 撑满宽度左对齐
                    .padding(8) // 与 TextEditor 保持相同的内边距
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1) // 同样添加边框统一风格
                    )
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    isFocused = false
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
            // 点击空白区域收起键盘
            .background(
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isFocused = false
                    }
            )
            .navigationTitle("新增待办")
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
