---
title: flowchart_javaweb文档
icon: circle-info
---
# 流程图编辑器项目介绍与技术文档（手动部署版）

## 项目地址

https://github.com/shenyuzi8/flowchart-editor-javaweb

一个基于 mxGraph、Java、JSP、MySQL 开发的可视化流程图编辑器，支持图形绘制、图形连接、本地保存，用户登录，用户注册等核心功能，采用 CC-BY-NC 开源协议。

## 🎈 在线体验

本地开发体验：http://localhost:8080/实际项目部署名（本地Tomcat启动后访问）

## 📋 项目简介

这是一个功能完善、交互流畅的可视化流程图编辑器，支持多种图形绘制、图形连接、本地自动保存等核心功能，适配 JDK25、Tomcat11、MySQL9 运行环境，专为个人学习、本地办公场景设计，操作简单、高效便捷。

## ⚡ 主要功能

### 🏠 用户管理

- 用户登录、注册、退出功能

- 基于Session的用户身份验证，确保数据安全

- 登录后显示用户专属相关功能

### 🎨 流程图绘制

- 右键菜单快速创建：矩形框、菱形判断框、文本框

- 图形操作：支持选中、拖拽移动、缩放大小

- 样式调整：可修改图形背景色（默认浅黄色）

### 🔗 图形连接

- 支持三种线型：实线、虚线、箭头线

- 连接逻辑：选中起点图形 → 选择线型 → 点击终点图形完成连接

- 连接成功有弹窗提示，操作可感知

### 💾 本地保存

- 实时自动保存流程图内容和标题到浏览器本地存储

- 刷新页面自动加载上次保存的内容，不丢失操作进度

## 🛠️ 技术栈

### 前端

- HTML5 - 页面结构搭建，语义化标签使用

- CSS3 - 样式美化，包括菜单、按钮、图形的布局与视觉优化

- 原生 JavaScript - 交互逻辑、事件绑定、本地存储操作

- mxGraph - 可视化流程图核心库，实现图形绘制、连接等功能

- JSP - 动态页面渲染，用户状态判断与页面内容适配

### 后端

- Java - 核心后端逻辑，Servlet 处理 HTTP 请求

- JDBC - 数据库连接与操作，实现数据持久化

- MySQL - 存储用户数据、流程图信息，支持外键关联

### 部署环境

- JDK 25 - 后端 Java 程序运行环境

- Tomcat 11 - Web 服务器，部署 JSP 和 Servlet 项目

- MySQL 9.0 - 数据库服务器，存储用户和流程图数据

- 浏览器：Chrome、Edge、Firefox 等现代浏览器（支持 HTML5 和 JavaScript）

```plain text
diagram/
├── src/
|    |
|  main/
│   └──java-com/
│       └── diagram/
│           ├── controller/       # 后端控制器（Servlet）
│           │   ├── DeleteDiagramServlet.java  # 删除流程图接口
│           │   ├── LoadDiagramByIdServlet.java # 加载流程图接口
│           │   ├── ListDiagramServlet.java    # 流程图列表接口
│           │   ├── LoginServlet.java          # 登录接口
│           │   ├── LogoutServlet.java         # 退出接口
│           │   ├── RegisterServlet.java       # 注册接口
│           │   |── SaveDiagramServlet.java    # 保存流程图接口
|           |   └── SendCodeServlet.java       # 发送验证码
│           ├── dao/              # 数据访问层
│           │   ├── DiagramDao.java            # 流程图数据操作
│           │   └── UserDao.java               # 用户数据操作
│           ├── model/            # 实体类
│           │   ├── Diagram.java               # 流程图实体
│           │   └── User.java                  # 用户实体
│           └── utils/            # 工具类
│               └── DBUtil.java                # 数据库连接工具
|               └── EmailUtil.java             # 邮件发送
├── webapp/
|   |—— css
|   |  └──style.css
|   |—— WEB-INF
│   │  └──web.xml
│   ├── login.jsp                # 登录页面
│   ├── register.jsp             # 注册页面
│   ├── index.jsp                # 主页面（流程图编辑器）
│   └── js/
│     └── mxClient.min.js      # mxGraph 核心库
|
|
├── diagram.sql                # 数据库初始化SQL脚本
└── pom.xml                      # 项目依赖配置（Maven）
```

## 🚀 部署指南（仅手动部署）

### 环境要求

- JDK 25 - 需正确配置环境变量，确保命令行可执行 java 命令

- Tomcat 11 - Web 服务器，用于部署 JSP 和 Servlet

- MySQL 9.0 - 数据库服务器，用于存储用户和流程图数据

- Maven - 项目打包工具，用于编译、打包项目

- 浏览器：Chrome、Edge、Firefox 等现代浏览器

### 手动部署步骤

1. 环境准备：安装 JDK 25、Tomcat 11、MySQL 9.0、Maven，配置对应环境变量（确保命令行可正常执行 java、mvn、mysql 命令）。

2. 数据库配置：
        

    - 启动 MySQL 服务，通过命令行或可视化工具（Navicat、SQLyog）登录 MySQL 客户端：`mysql -u root -p`，输入密码登录。

    - 执行数据库初始化脚本：
    ```sql
    `CREATE DATABASE IF NOT EXISTS diagram_sys;
    USE diagram_sys;
    
    CREATE TABLE user (
        id INT PRIMARY KEY AUTO_INCREMENT,
        email VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(100) NOT NULL
    );
    
    CREATE TABLE diagram (
        id INT PRIMARY KEY AUTO_INCREMENT,
        user_id INT NOT NULL,
        title VARCHAR(200),
        type VARCHAR(20),
        content LONGTEXT,
        FOREIGN KEY (user_id) REFERENCES user(id)
    );`
    ```

    - 脚本执行完成后，确认数据表创建成功（user 表和 diagram 表，且 diagram 表与 user 表有外键关联）。

    - 修改数据库连接配置：打开项目 `src/com/diagram/utils/DBUtil.java` 文件，修改 URL、USER、PASSWORD 三个参数，适配本地 MySQL 配置（确保用户名、密码、数据库地址正确）。

3. 项目打包：
        

    - 进入项目根目录，打开命令行，执行打包命令：`mvn clean package`。

    - 打包完成后，在项目 `target` 目录下生成 war 包（如：flowchart-editor.war）。

4. 部署项目：
        

    - 找到 Tomcat 安装目录，进入 `webapps` 文件夹。

    - 将打包好的 war 包复制到 `webapps` 目录下（Tomcat 启动后会自动解压 war 包）。

5. 启动服务：
        

    - 进入 Tomcat 安装目录的 `bin` 文件夹，执行启动命令：
    
    Windows 系统：双击 `startup.bat`；
                
    Linux 系统：执行 `./startup.sh`。
    

    - 等待 Tomcat 启动完成（可通过查看 `logs/catalina.out` 日志确认启动状态）。

6. 访问项目：打开浏览器，输入 `http://localhost:8080/flowchart-editor`（路径需根据 war 包名称调整，若 war 包名称为 ROOT.war，则直接访问 `http://localhost:8080`）。

### 配置调整

- 数据库配置：修改 `DBUtil.java` 中的 URL、USER、PASSWORD 参数，适配本地 MySQL 配置（如本地 MySQL 端口非默认 3306，需在 URL 中添加端口参数，例：`jdbc:mysql://localhost:3307/diagram_sys?...`）。

- Tomcat 端口调整：若 8080 端口被占用，修改 Tomcat 安装目录 `conf/server.xml` 文件中的 `Connector port="8080"`，将端口改为未被占用的端口（如 8081），重启 Tomcat 生效。

- 前端配置：可修改 `index.jsp` 中的图形大小、线型样式、自动保存间隔等参数，调整后重启 Tomcat 生效。

## 📖 使用说明

### 用户登录/注册

1. 访问项目首页，点击“登录”按钮，进入登录页面，输入注册的邮箱和密码，点击登录即可进入编辑器。

2. 若未注册，点击“注册”按钮，输入邮箱、密码（根据注册页面提示），完成注册后再进行登录。

3. 登录后可使用用户专属功能，退出登录点击导航栏“退出”按钮即可。

### 流程图绘制

1. 新建图形：在画布空白处右键单击，弹出菜单，可选择创建矩形框、菱形判断框、文本框，点击后自动在右键位置生成对应图形。

2. 图形操作：左键选中图形，可拖拽移动位置，拖拽图形边缘可缩放图形大小；右键单击画布，选择“更改背景色”可修改选中图形的背景色（默认浅黄色）。

### 图形连接

1. 选中一个图形（左键单击图形），右键单击画布，选择“连接”选项。

2. 在弹出的线型菜单中，选择需要的线型（实线、虚线、箭头线），弹出提示“请点击目标图形完成连接”。

3. 点击需要连接的目标图形，即可完成两个图形的连接，连接成功有弹窗提示。

### 本地保存

系统每1.5秒自动将当前流程图内容和标题保存到浏览器本地存储（localStorage），刷新页面后会自动加载上次保存的内容，无需手动保存。

## ⚙️ 配置参数

### 后端配置（DBUtil.java）

```java
// 本地 MySQL 连接地址（默认端口 3306，若端口修改需添加 port 参数）
private static final String URL = "jdbc:mysql://localhost:3306/diagram_sys?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=utf8";
// MySQL 登录用户名
private static final String USER = "root";
// MySQL 登录密码
private static final String PASSWORD = "root123456";
```

### 前端配置（index.jsp）

- 自动保存间隔：1500ms（可修改 `setInterval(loadLocalSave, 1500)` 中的时间参数）。

- 图形大小：默认矩形 100x60、菱形 100x60、文本 100x40（可修改 `addRectAtMenu` 等函数中的宽高参数）。

- 线型样式：实线（strokeWidth=2）、虚线（dashPattern=4 2）、箭头线（endArrow=block），可修改 `setLineType` 函数中的样式参数。

## 🔧 安全注意事项

### 用户安全

- 用户密码未加密存储（当前为演示版本），生产环境建议添加 MD5 或 SHA256 加密，确保密码安全。

- 基于 Session 进行身份验证，退出登录后销毁 Session，防止非法访问。

### 数据安全

- 用户数据和流程图数据存储在本地 MySQL 数据库中，建议定期备份数据库，防止数据丢失。

- 流程图本地保存仅存储在当前浏览器的 localStorage 中，换浏览器或清除浏览器数据后会丢失，需手动备份或存储在数据库中。

### 操作安全

- 连接图形时，需先选中一个图形，再选择线型，最后点击目标图形，避免误操作。

- 新建流程图会清空当前画布和本地保存，操作前请确认无需保留当前内容。

## 🐛 故障排除

### 常见问题

1. 右键菜单不弹出：检查浏览器是否禁用右键菜单，启用后重新尝试；确认`mxClient.min.js` 已正确加载。

2. 图形无法连接：确认已选中一个图形，再选择“连接”功能；检查线型是否选择，目标图形是否为有效顶点。

3. 项目无法访问：确认 Tomcat 已正常启动，war 包已正确放入 `webapps` 目录并完成解压；检查访问路径与 war 包名称一致。

4. 数据库连接失败：确认 MySQL 服务已启动，`DBUtil.java` 中的连接参数（URL、USER、PASSWORD）正确；确认 MySQL 允许 root 用户本地登录。

5. 本地保存无法加载：清除浏览器缓存和 localStorage，重新绘制流程图后再尝试。

### 日志检查

- Tomcat 日志：查看 Tomcat 安装目录 `logs/catalina.out` 文件，定位部署、接口调用相关错误。

- MySQL 日志：查看本地 MySQL 日志（Windows 通常在 `data/hostname.err`，Linux 通常在 `/var/log/mysql/error.log`），排查数据库连接、脚本执行错误。

- 浏览器控制台：按 F12 打开控制台，查看 Console 面板的 JS 报错，定位前端交互、图形加载相关错误。

## 📄 开源协议

本项目采用 CC-BY-NC 4.0 协议：

- 署名 - 必须给出适当的署名，提供指向本许可协议的链接，同时标明是否对原始内容作了修改。

- 非商业性使用 - 不得将本材料用于商业目的。

完整协议内容：https://creativecommons.org/licenses/by-nc/4.0/

## ⚠️ 免责声明

本系统仅供学习和研究使用，作者不对因使用本系统而产生的任何直接或间接损失负责。在本地办公场景使用前，请进行充分的安全测试和评估。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目。如有功能优化、Bug 修复、文档完善等建议，可直接提交贡献。

## 📞 支持

如有问题或建议，请通过以下方式联系：

- 提交 GitHub Issue（https://github.com/shenyuzi8/flowchart-editor-javaweb/issues）

- 查看本技术文档，排查常见问题

## 最后更新

2026年3月

作者：莘羽子

协议：CC-BY-NC 4.0s