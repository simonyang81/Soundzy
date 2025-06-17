# Soundzy

## 项目简介

Soundzy 是一个基于鸿蒙操作系统（HarmonyOS）开发的原生应用项目。该项目使用 ArkTS（TypeScript的鸿蒙扩展）语言开发，遵循鸿蒙应用开发规范。

## 项目结构

```
Soundzy/
├── 📁 .hvigor/              # Hvigor构建工具缓存目录
├── 📁 .idea/                # IDE配置文件目录
├── 📁 hvigor/               # Hvigor构建工具相关文件
├── 📁 oh_modules/           # 项目依赖包目录
├── 📁 AppScope/             # 应用全局配置目录
│   ├── 📄 app.json5         # 应用全局配置文件
│   └── 📁 resources/        # 应用级全局资源文件
│       └── 📁 base/         # 基础资源
│           ├── 📁 element/  # 资源元素定义
│           │   └── 📄 string.json    # 全局字符串资源
│           └── 📁 media/    # 媒体资源
│               ├── 📄 layered_image.json   # 分层图片配置
│               ├── 📄 foreground.png       # 前景图片
│               └── 📄 background.png       # 背景图片
├── 📁 entry/                # 主模块目录
│   ├── 📄 build-profile.json5    # 模块构建配置
│   ├── 📄 obfuscation-rules.txt  # 代码混淆规则
│   ├── 📄 hvigorfile.ts          # 模块构建脚本
│   ├── 📄 oh-package.json5       # 模块依赖配置
│   ├── 📄 .gitignore             # 模块Git忽略配置
│   └── 📁 src/                    # 源代码目录
│       ├── 📁 main/               # 主要源代码
│       │   ├── 📄 module.json5    # 模块配置文件
│       │   ├── 📁 ets/            # ArkTS源代码
│       │   │   ├── 📁 entryability/         # 应用入口能力
│       │   │   │   └── 📄 EntryAbility.ets  # 应用入口能力实现
│       │   │   ├── 📁 entrybackupability/   # 数据备份恢复能力
│       │   │   │   └── 📄 EntryBackupAbility.ets # 备份能力实现
│       │   │   └── 📁 pages/                # 页面组件
│       │   │       └── 📄 Index.ets         # 应用主页面组件
│       │   └── 📁 resources/      # 模块资源文件
│       │       ├── 📁 base/       # 基础资源(字符串、颜色、图片等)
│       │       │   ├── 📁 element/          # 资源元素定义
│       │       │   │   ├── 📄 string.json  # 字符串资源定义
│       │       │   │   ├── 📄 color.json   # 颜色资源定义
│       │       │   │   └── 📄 float.json   # 浮点数资源定义
│       │       │   ├── 📁 profile/          # 配置文件
│       │       │   │   ├── 📄 main_pages.json    # 主页面路由配置
│       │       │   │   └── 📄 backup_config.json # 备份配置
│       │       │   └── 📁 media/            # 媒体资源
│       │       │       ├── 📄 startIcon.png      # 启动图标
│       │       │       ├── 📄 layered_image.json # 分层图片配置
│       │       │       ├── 📄 background.png     # 背景图片
│       │       │       └── 📄 foreground.png     # 前景图片
│       │       ├── 📁 dark/       # 深色主题资源
│       │       │   └── 📁 element/          # 深色主题元素
│       │       │       └── 📄 color.json   # 深色主题颜色定义
│       │       └── 📁 rawfile/    # 原始文件资源(音频、视频等)
│       ├── 📁 ohosTest/           # 鸿蒙平台测试文件
│       │   ├── 📄 module.json5    # 测试模块配置
│       │   └── 📁 ets/            # 测试源代码
│       │       └── 📁 test/       # 测试用例
│       │           ├── 📄 Ability.test.ets      # 能力测试用例
│       │           └── 📄 List.test.ets         # 列表测试用例
│       ├── 📁 test/               # 通用单元测试文件
│       │   ├── 📄 List.test.ets          # 列表单元测试
│       │   └── 📄 LocalUnit.test.ets     # 本地单元测试
│       └── 📁 mock/               # Mock数据和模拟服务
│           └── 📄 mock-config.json5      # Mock配置文件
├── 📄 .clang-format         # C/C++代码格式化配置
├── 📄 .gitignore            # Git忽略文件配置
├── 📄 build-profile.json5   # 项目构建配置
├── 📄 code-linter.json5     # 代码质量检查规则
├── 📄 hvigorfile.ts         # Hvigor构建工具入口脚本
├── 📄 local.properties      # 本地开发环境配置
├── 📄 oh-package.json5      # 项目依赖管理文件
├── 📄 oh-package-lock.json5 # 依赖包版本锁定文件
└── 📄 README.md             # 项目说明文档
```

## 目录详细说明

### 根目录配置文件

- **`oh-package.json5`** - 项目依赖管理文件，定义项目依赖和开发依赖
- **`build-profile.json5`** - 项目构建配置，包含签名配置、构建模式、目标SDK版本等
- **`hvigorfile.ts`** - Hvigor构建工具的入口脚本
- **`local.properties`** - 本地开发环境配置（SDK路径等）
- **`code-linter.json5`** - 代码质量检查规则配置

### AppScope - 应用全局配置

- **`app.json5`** - 应用全局配置文件
  - 应用包名：`com.smn.soundzy`
  - 应用版本信息
  - 应用图标和名称配置
- **`resources/`** - 应用级别的全局资源文件

### entry - 主模块

这是应用的主要功能模块，包含核心业务逻辑。

#### src/main - 主要源代码

- **`ets/`** - ArkTS源代码目录
  - `entryability/` - 应用入口能力，处理应用生命周期
  - `entrybackupability/` - 数据备份恢复能力
  - `pages/` - 页面组件目录
    - `Index.ets` - 应用主页面组件
- **`resources/`** - 模块资源文件
  - `base/` - 基础资源文件（字符串、颜色、图片等）
  - `dark/` - 深色主题资源文件
  - `rawfile/` - 原始文件资源（音频、视频等）
- **`module.json5`** - 模块配置文件，定义模块能力、权限、页面路由等

#### src/test - 测试相关

- **`ohosTest/`** - 鸿蒙平台特定的测试文件
- **`test/`** - 通用单元测试文件
- **`mock/`** - Mock数据和模拟服务

## 技术栈

- **开发语言**: ArkTS (TypeScript for HarmonyOS)
- **UI框架**: ArkUI (鸿蒙原生UI框架)
- **构建工具**: Hvigor
- **测试框架**: Hypium, Hamock
- **目标平台**: HarmonyOS 5.0.5(17)

## 开发环境要求

- **HarmonyOS SDK**: 5.0.5(17) 或更高版本
- **DevEco Studio**: 最新版本
- **Node.js**: 建议使用LTS版本

## 快速开始

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd Soundzy
   ```

2. **安装依赖**
   ```bash
   ohpm install
   ```

3. **运行项目**
   - 使用DevEco Studio打开项目
   - 连接HarmonyOS设备或使用模拟器
   - 点击运行按钮启动应用

## 项目特色

- 🎵 **音频应用** - 专注于音频处理和播放功能
- 🏗️ **分层架构** - 清晰的代码结构，易于维护和扩展
- 🎨 **主题适配** - 支持深色和浅色主题
- 📱 **原生性能** - 使用鸿蒙原生框架，性能优异
- 🧪 **完整测试** - 包含单元测试和集成测试

## 开发规范

- 使用JSDoc格式编写代码注释
- 遵循鸿蒙应用开发规范
- 注重应用性能优化
- 敏感信息不在配置文件中明文存储
- 所有依赖在项目目录内安装，不使用全局依赖

## 贡献指南

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/新功能`)
3. 提交更改 (`git commit -am '添加新功能'`)
4. 推送到分支 (`git push origin feature/新功能`)
5. 创建 Pull Request

## 许可证

本项目采用 [MIT License](LICENSE) 许可证。

## 联系方式

如有问题或建议，请通过以下方式联系：
- 创建 Issue
- 发送邮件至项目维护者 