# TodoReminder - 未来事项待办提醒 App

一款基于 SwiftUI 和 Core Data 开发的 iOS 待办事项提醒应用，专注于帮助用户记录并追踪未来的计划与安排。

## 功能特性

- **日历概览 (Tab 1)**：实时显示当前系统时间，通过图形化日历查看整体计划。有记录的日期会显示圆点标记，点击特定日期可弹出该日的所有待办详情。
- **新增记录 (Tab 2)**：提供简洁的表单页面，支持输入备注事项，并通过原生 DatePicker 选择未来日期进行绑定保存。
- **未来事项 (Tab 3)**：按时间升序展示当前及未来的所有待办事项，支持左滑快速删除已取消或已完成的事项。
- **本地持久化**：基于 Core Data 实现全离线数据存储，保障数据安全与响应速度。

## 技术栈与架构

- **最低支持版本**：iOS 16.2
- **架构模式**：MVVM (Model-View-ViewModel)
- **UI 框架**：SwiftUI
- **数据持久化**：Core Data
- **第三方依赖**：[FSCalendar](https://github.com/WenchaoD/FSCalendar) (用于日历视图的圆点打点渲染)

### 目录结构说明
项目采用功能分层结构管理代码：
- `App/`: 应用入口与全局环境配置。
- `Models/`: Core Data 实体定义与数据库操作控制层。
- `ViewModels/`: 承载业务逻辑，连接 View 和 Model。
- `Views/`: 纯 UI 渲染层，按 Tab 页面功能划分子目录。
- `Utils/`: 通用工具类与扩展方法。

## GitHub Actions 自动化构建
本项目配置了基于 GitHub Actions 的持续集成工作流。
- **触发条件**：代码推送到 `main` 分支。
- **功能**：自动执行 Xcode 构建，导出无签名的 `.ipa` 文件，并上传至 GitHub Artifacts 供测试下载。

## 本地运行指南

1. 克隆仓库到本地。
2. 打开 `TodoReminder.xcodeproj`。
3. 由于使用了 FSCalendar，请确保已安装 CocoaPods 或 Swift Package Manager (SPM) 并拉取依赖。
4. 在 Xcode 中选中模拟器或真机，点击运行 (Cmd + R)。


```
TodoReminder/
├── App/
│   └── TodoReminderApp.swift          # App 入口，初始化全局环境
├── Models/
│   ├── Model.xcdatamodeld             # Core Data 数据模型定义文件
│   └── PersistenceController.swift    # 数据库单例、CRUD 操作封装
├── ViewModels/
│   ├── CalendarViewModel.swift        # 处理日历打点数据及点击交互逻辑
│   ├── AddRecordViewModel.swift       # 处理表单输入与保存逻辑
│   └── FutureListViewModel.swift      # 处理未来事项列表的拉取与删除
├── Views/
│   ├── MainTabView.swift              # 底部 3 个 Tab 的主容器
│   ├── Calendar/
│   │   ├── CalendarView.swift         # Tab1 主页面 (包含时间显示与日历)
│   │   ├── FSCalendarWrapper.swift    # utils: FSCalendar 的 SwiftUI 封装
│   │   └── EventDetailSheet.swift     # utils: 点击日历弹出的详情 Sheet
│   ├── AddRecord/
│   │   └── AddRecordView.swift       # Tab2 新增记录表单页面
│   └── FutureList/
│       └── FutureListView.swift       # Tab3 未来事项列表页面
└── Utils/
    └── DateExtensions.swift           # utils: 日期处理的通用扩展方法
```
