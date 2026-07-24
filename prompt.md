::: PROMPT START :::
# 任务目标
请严格按照下方给定的【架构规范】与【代码实现规则】，开发一个 iOS App。
请直接输出完整的可运行代码，不要省略任何文件。

# 架构规范说明
使用mvvm架构，View 专心画界面，ViewModel 专心写逻辑，Model 专心管数据。
1. 目录结构约定（严格遵循）
- `App/`: 仅存放入口文件，负责环境注入和挂载根视图。
- `Models/`: 数据层。必须使用程序化 Core Data（放弃 .xcdatamodeld 可视化文件），将 Entity 类定义和 PersistenceController 单例放在同一文件内，实现开箱即用。
- `Utils/`: 通用工具。日期格式化、字符串处理等扩展方法。
- `ViewModels/`: 业务逻辑层。每个主要 View 拥有独立的 ViewModel，类名格式为 [功能名]ViewModel。必须继承 ObservableObject，使用 @Published 暴露状态。
- `Views/`: UI 层。按 Tab 功能建立子文件夹。每个 View 尽量保持无状态，所有数据绑定到对应的 ViewModel。

2. 数据流转规则
- View 不直接操作数据库。
- View 通过 @StateObject 持有 ViewModel。
- ViewModel 调用 PersistenceController.shared 的方法进行 CRUD。
- 数据更新后，ViewModel 的 @Published 属性自动驱动 View 刷新。

3. 第三方库引入规则
- 优先使用原生 SwiftUI API。
- 若原生 API 实现成本过高（如日历打点、复杂图表），允许引入 SPM 第三方库。
- 必须使用 UIViewRepresentable 或 UIViewControllerRepresentable 将第三方 UIKit 库封装为 SwiftUI 组件，放置在 `Views/对应功能目录/` 下。

4. CI/CD 构建规则
- 必须配置 GitHub Actions (build.yml)。
- 构建命令必须包含 -resolvePackageDependencies 步骤，处理 SPM 依赖。
- 导出无证书 IPA 时，必须从 xcarchive 中复制 .app 文件，然后打包成 IPA（本质是 zip 文件）。

# 代码实现规则（防踩坑红线）
1. 数据模型与存取
- 实体类属性禁止声明为 Optional（如 `eventDate` 必须是 `Date` 而非 `Date?`），避免取值时大量使用可选链报错。
- 使用 `NSFetchRequest` 时，需注意 Xcode 新版本类型推断问题，必要时使用 `NSFetchRequest<NSFetchRequestResult>(entityName: "EntityName")` 并强转。
2. 交互逻辑
- 关闭键盘、弹窗等交互，必须配置 `@FocusState` 并在最外层添加背景点击手势 `.onTapGesture`，不能依赖系统默认行为。
3. 跨页面数据同步
- 当 Tab2 新增数据，Tab1 需要实时更新（如日历打点、列表刷新）时，必须使用 `NotificationCenter.default` 发送全局广播通知，对应 Tab 的 ViewModel 必须监听该通知并重新拉取数据。
4. UIViewRepresentable 刷新
- 在第三方 UIKit 组件的 `updateUIView` 方法中，必须显式将 `self` 赋值给 `context.coordinator.parent`，并调用 `uiView.reloadData()`，强制 SwiftUI 数据变更时触发原生视图重绘。

# App 需求
请基于以上规范，开发一个包含 3 个 Tab 的 App：
- Tab1 (日历概览): [在此处填写 Tab1 的具体需求，例如：展示日历，下方显示当前系统时间，有事项的日期显示红点，点击日期弹出事项列表]
- Tab2 (新增): [在此处填写 Tab2 的具体需求，例如：包含文本输入框、日期选择器、保存按钮，保存后广播通知其他页面刷新]
- Tab3 (待办列表): [在此处填写 Tab3 的具体需求，例如：展示未来所有事项列表，支持滑动删除]
::: PROMPT END :::
