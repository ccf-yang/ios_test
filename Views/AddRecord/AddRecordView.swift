import SwiftUI

struct AddRecordView: View {
    @StateObject private var viewModel = AddRecordViewModel()
    @State private var showSavedAlert = false
    @FocusState private var isFocused: Bool // 用于管理输入框焦点
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("备注")
                    .font(.headline)
                    .padding(.leading)
                
                TextEditor(text: $viewModel.content)
                    .focused($isFocused)
                    .frame(height: 100) // 1. 限制固定高度，避免过大
                    .scrollContentBackground(.hidden) // 隐藏默认背景，方便自定义圆角
                    .padding(8)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("选择日期")
                        .font(.headline)
                    
                    // 2. 隐藏 DatePicker 默认占位文字，并让它充满宽度
                    DatePicker("", selection: $viewModel.eventDate, displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .environment(\.locale, Locale(identifier: "zh_CN")) // 确保显示中文格式
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
                
                Button(action: {
                    isFocused = false // 保存时收起键盘
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
            // 3. 添加点击空白区域收起键盘的手势
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

// 扩展：如果通过聚焦状态收起键盘不生效，可使用 UIApplication
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
