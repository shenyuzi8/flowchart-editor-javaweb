<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>流程图编辑器</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        .top { background: #2c3e50; color: white; padding: 15px; display: flex; justify-content: space-between; align-items: center; }
        .toolbar { background: #f8f9fa; padding: 10px; display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
        #container { width: 100%; height: 700px; border: 1px solid #ccc; background: #fff; position: relative; }
        input { padding: 8px 12px; width: 240px; }
        select { padding: 8px 12px; min-width: 220px; }
        button { padding: 8px 14px; background: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .delete-btn { background: #e74c3c; }

        /* 通知样式 */
        .toast {
            position: fixed;
            top: 20px;
            right: 20px;
            background: rgba(0,0,0,0.8);
            color: #fff;
            padding: 12px 20px;
            border-radius: 6px;
            z-index: 10000;
            font-size: 14px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
            transition: opacity 0.3s;
            max-width: 300px;
            word-wrap: break-word;
        }
        .toast.info { background: #3498db; }
        .toast.success { background: #27ae60; }
        .toast.error { background: #e74c3c; }

        /* 右键菜单及子菜单样式 */
        #contextMenu, #lineTypeMenu, #colorMenu {
            position: fixed;
            width: 180px;
            background: white;
            border: 1px solid #ccc;
            box-shadow: 2px 2px 10px rgba(0,0,0,0.2);
            z-index: 9999;
            display: none;
        }
        #contextMenu div, #lineTypeMenu div, #colorMenu div {
            padding: 8px 12px;
            cursor: pointer;
        }
        #contextMenu div:hover, #lineTypeMenu div:hover, #colorMenu div:hover {
            background: #f0f0f0;
        }
        .color-box {
            width: 20px;
            height: 20px;
            border: 1px solid #ccc;
            display: inline-block;
            margin-right: 8px;
            vertical-align: middle;
        }
    </style>

    <script>
        mxLoadResources = false;
        mxLoadStylesheets = false;
        mxLanguage = 'zh';
        mxForceIncludes = false;
    </script>
    <script src="js/mxClient.min.js"></script>
</head>
<body>

<div class="top">
    <h2>流程图编辑器</h2>
    <div style="display:flex; gap:14px; align-items:center">
        <%
            com.diagram.model.User user = (com.diagram.model.User) session.getAttribute("user");
            if (user == null) {
        %>
        <button onclick="location.href='login.jsp'">登录</button>
        <button onclick="location.href='register.jsp'">注册</button>
        <% } else { %>
        <span>欢迎：<%= user.getEmail() %></span>
        <select id="diagramSelect"></select>
        <button onclick="loadSelectedDiagram()">加载</button>
        <button onclick="loadList()">🔄 刷新列表</button>
        <button onclick="location.href='/logout'">退出</button>
        <% } %>
    </div>
</div>

<div class="toolbar">
    <input id="title" placeholder="标题">

    <% if (user != null) { %>
    <button onclick="saveToCloud()">保存云端</button>
    <button onclick="deleteDiagram()" class="delete-btn">删除云端</button>
    <% } %>

    <button onclick="newDiagram()">新建</button>
</div>

<div id="container">
    <!-- 图形容器 -->
</div>

<!-- 右键主菜单 -->
<div id="contextMenu">
    <div onclick="addRectAtMenu()">📦 矩形框</div>
    <div onclick="addDiamondAtMenu()">🔷 菱形判断框</div>
    <div onclick="addTextAtMenu()">📝 文字</div>
    <div onclick="showColorMenu()">🎨 更改背景色</div>
    <div onclick="startConnect()">🔗 连接</div>
    <div onclick="deleteSelectedCell()" style="color:#e74c3c;">🗑️ 删除</div>
</div>

<!-- 线型选择菜单（连接子菜单） -->
<div id="lineTypeMenu">
    <div onclick="setLineType('solid')">➖ 实线</div>
    <div onclick="setLineType('dashed')">---- 虚线</div>
    <div onclick="setLineType('arrow')">➡️ 箭头线</div>
</div>

<!-- 颜色选择菜单（背景色子菜单） -->
<div id="colorMenu">
    <div onclick="setBgColor('#FFB6C1')"><span class="color-box" style="background:#FFB6C1;"></span>浅粉色</div>
    <div onclick="setBgColor('#FFD700')"><span class="color-box" style="background:#FFD700;"></span>金黄色</div>
    <div onclick="setBgColor('#98FB98')"><span class="color-box" style="background:#98FB98;"></span>淡绿色</div>
    <div onclick="setBgColor('#87CEEB')"><span class="color-box" style="background:#87CEEB;"></span>天蓝色</div>
    <div onclick="setBgColor('#F4A460')"><span class="color-box" style="background:#F4A460;"></span>沙棕色</div>
    <div onclick="setBgColor('#DDA0DD')"><span class="color-box" style="background:#DDA0DD;"></span>梅红色</div>
    <div onclick="setBgColor('#FFFFFF')"><span class="color-box" style="background:#FFFFFF; border:1px solid #aaa;"></span>白色</div>
    <div onclick="setBgColor('#E6E6FA')"><span class="color-box" style="background:#E6E6FA;"></span>薰衣草色</div>
</div>

<script>
    var graph;
    var menuX = 0, menuY = 0;          // 相对于container的坐标，用于添加图形
    var clientX = 0, clientY = 0;       // 屏幕坐标，用于菜单定位
    var connectMode = false;
    var sourceCell = null;
    var currentLineStyle = "";

    // ========== 通知系统 ==========
    function showToast(message, type = 'info', duration = 3000) {
        var toast = document.createElement('div');
        toast.className = 'toast ' + type;
        toast.innerText = message;
        document.body.appendChild(toast);
        setTimeout(() => {
            toast.style.opacity = '0';
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }

    window.onload = function () {
        var container = document.getElementById('container');
        graph = new mxGraph(container);
        var parent = graph.getDefaultParent();
        graph.setConnectable(true);
        graph.setCellsResizable(true);
        graph.setEdgeLabelsMovable(true);

        // 禁用默认右键菜单并自定义
        graph.container.oncontextmenu = (e) => {
            e.preventDefault();
            // 获取鼠标下的单元格（包括顶点和边）
            var rect = graph.container.getBoundingClientRect();
            var relX = e.clientX - rect.left;
            var relY = e.clientY - rect.top;
            var cell = graph.getCellAt(relX, relY);
            if (cell) {
                // 无论顶点还是边，都选中
                graph.setSelectionCell(cell);
            } else {
                graph.clearSelection();
            }
            showContextMenu(e);
        };

        // 点击容器关闭所有菜单
        container.addEventListener("click", () => {
            hideAllMenus();
        });

        // 添加初始开始节点
        graph.getModel().beginUpdate();
        graph.insertVertex(parent, null, '开始', 50, 50, 100, 60);
        graph.getModel().endUpdate();

        // 自定义连接逻辑：连接模式开启时点击目标完成连线
        graph.addListener(mxEvent.CLICK, (sender, evt) => {
            if (!connectMode || !sourceCell) return;
            var target = evt.getProperty("cell");
            if (target && target != sourceCell && target.isVertex()) {
                // 应用当前选择的线型，若未选择则默认实线无箭头
                var finalStyle = currentLineStyle || "endArrow=none";
                connectCells(sourceCell, target, finalStyle);
                resetConnectMode();
                showToast("连接成功！", "success");
            }
            evt.consume();
        });

        // 按ESC键取消连接模式
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && connectMode) {
                resetConnectMode();
                showToast("已取消连接", "info");
            }
        });

        loadLocal();
        setInterval(loadLocalSave, 1500);
        <% if (user != null) { %>
        setTimeout(loadList, 300);
        <% } %>
    };

    // 重置连接模式相关状态
    function resetConnectMode() {
        connectMode = false;
        sourceCell = null;
        currentLineStyle = "";
    }

    // ========== 右键菜单显示（带边界检测） ==========
    function showContextMenu(e) {
        hideAllMenus();
        // 计算相对于container的坐标（用于添加图形）
        var rect = graph.container.getBoundingClientRect();
        menuX = e.clientX - rect.left;
        menuY = e.clientY - rect.top;
        // 存储屏幕坐标用于子菜单定位
        clientX = e.clientX;
        clientY = e.clientY;

        var menu = document.getElementById("contextMenu");
        // 先临时显示以获取尺寸
        menu.style.display = "block";
        var menuWidth = menu.offsetWidth;
        var menuHeight = menu.offsetHeight;
        // 计算合适位置
        var left = clientX;
        var top = clientY;
        // 检查右边界
        if (left + menuWidth > window.innerWidth) {
            left = window.innerWidth - menuWidth - 5;
        }
        // 检查下边界
        if (top + menuHeight > window.innerHeight) {
            top = window.innerHeight - menuHeight - 5;
        }
        // 确保不超出左/上边界
        if (left < 0) left = 5;
        if (top < 0) top = 5;
        menu.style.left = left + "px";
        menu.style.top = top + "px";
        menu.style.display = "block";
    }

    function hideAllMenus() {
        document.getElementById("contextMenu").style.display = "none";
        document.getElementById("lineTypeMenu").style.display = "none";
        document.getElementById("colorMenu").style.display = "none";
    }

    // 通用的子菜单位置调整函数
    function adjustMenuPosition(menu, x, y) {
        menu.style.display = "block";
        var menuWidth = menu.offsetWidth;
        var menuHeight = menu.offsetHeight;
        var left = x;
        var top = y;
        if (left + menuWidth > window.innerWidth) {
            left = window.innerWidth - menuWidth - 5;
        }
        if (top + menuHeight > window.innerHeight) {
            top = window.innerHeight - menuHeight - 5;
        }
        if (left < 0) left = 5;
        if (top < 0) top = 5;
        menu.style.left = left + "px";
        menu.style.top = top + "px";
        menu.style.display = "block";
    }

    // ========== 菜单创建图形 ==========
    function addRectAtMenu() {
        hideAllMenus();
        var p = graph.getDefaultParent();
        graph.getModel().beginUpdate();
        graph.insertVertex(p, null, "矩形", menuX, menuY, 100, 60);
        graph.getModel().endUpdate();
    }

    function addDiamondAtMenu() {
        hideAllMenus();
        var p = graph.getDefaultParent();
        graph.getModel().beginUpdate();
        graph.insertVertex(p, null, "判断", menuX, menuY, 100, 60, "shape=rhombus;fillColor=#f9f9f9;strokeColor=#000000;");
        graph.getModel().endUpdate();
    }

    function addTextAtMenu() {
        hideAllMenus();
        var p = graph.getDefaultParent();
        graph.getModel().beginUpdate();
        graph.insertVertex(p, null, "文本", menuX, menuY, 100, 40, "shape=text");
        graph.getModel().endUpdate();
    }

    // ========== 背景颜色（二级菜单） ==========
    function showColorMenu() {
        hideAllMenus();
        var menu = document.getElementById("colorMenu");
        adjustMenuPosition(menu, clientX + 190, clientY);
    }

    function setBgColor(color) {
        hideAllMenus();
        var cell = graph.getSelectionCell();
        if (cell && cell.isVertex()) {
            graph.setCellStyles(mxConstants.STYLE_FILLCOLOR, color, [cell]);
        } else {
            showToast("请先选中一个图形！", "error");
        }
    }

    // ========== 连接逻辑 ==========
    function startConnect() {
        hideAllMenus();
        var cell = graph.getSelectionCell();
        if (!cell || !cell.isVertex()) {
            showToast("请先选中一个图形！", "error");
            return;
        }
        sourceCell = cell;
        connectMode = true;
        showLineTypeMenu();
    }

    function showLineTypeMenu() {
        var menu = document.getElementById("lineTypeMenu");
        adjustMenuPosition(menu, clientX + 190, clientY);
    }

    function setLineType(type) {
        hideAllMenus();
        if (type === "solid") currentLineStyle = "endArrow=none";
        if (type === "dashed") currentLineStyle = "endArrow=none;dashed=1";
        if (type === "arrow") currentLineStyle = "endArrow=block";
        showToast("请点击目标图形完成连接", "info");
        // 保持连接模式开启，等待目标点击
    }

    function connectCells(from, to, style) {
        var p = graph.getDefaultParent();
        graph.getModel().beginUpdate();
        graph.insertEdge(p, null, "", from, to, style);
        graph.getModel().endUpdate();
    }

    // ========== 删除功能 ==========
    function deleteSelectedCell() {
        hideAllMenus();
        var cell = graph.getSelectionCell();
        if (!cell) {
            showToast("未选中任何图形或连线", "error");
            return;
        }
        if (confirm("确定要删除选中的元素吗？")) {
            graph.getModel().beginUpdate();
            try {
                graph.removeCells([cell]);
                showToast("删除成功", "success");
            } finally {
                graph.getModel().endUpdate();
            }
            // 删除后如果处于连接模式，且源单元格被删除，则重置连接模式
            if (sourceCell === cell) {
                resetConnectMode();
            }
        }
    }

    // ========== 数据持久化 ==========
    function getXML() {
        var codec = new mxCodec();
        var node = codec.encode(graph.getModel());
        return mxUtils.getXml(node);
    }

    function setXML(xml) {
        if (!xml) return;
        try {
            var doc = mxUtils.parseXml(xml);
            var codec = new mxCodec(doc);
            codec.decode(doc.documentElement, graph.getModel());
        } catch (e) { console.error("解析失败", e); }
    }

    function loadLocalSave() {
        localStorage.setItem("xml", getXML());
        localStorage.setItem("title", document.getElementById("title").value);
    }

    function loadLocal() {
        var xml = localStorage.getItem("xml");
        var title = localStorage.getItem("title");
        if (xml) { setXML(xml); document.getElementById("title").value = title; }
    }

    function newDiagram() {
        graph.getModel().clear();
        document.getElementById("title").value = "";
        localStorage.removeItem("xml");
        var p = graph.getDefaultParent();
        graph.getModel().beginUpdate();
        graph.insertVertex(p, null, '开始', 50, 50, 100, 60);
        graph.getModel().endUpdate();
        resetConnectMode();
        showToast("已新建流程图", "success");
    }

    // ========== 云端操作 ==========
    function saveToCloud() {
        var title = document.getElementById("title").value;
        if (!title) {
            showToast("请输入标题", "error");
            return;
        }
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/saveDiagram", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send("title="+encodeURIComponent(title)+"&type=flow&content="+encodeURIComponent(getXML()));
        xhr.onload = () => {
            if (xhr.responseText === "success") {
                showToast("保存成功！", "success");
                loadList();
            } else {
                showToast("保存失败！", "error");
            }
        };
        xhr.onerror = () => showToast("网络错误", "error");
    }

    function loadList() {
        var sel = document.getElementById("diagramSelect");
        if (!sel) return;
        sel.innerHTML = "";
        var xhr = new XMLHttpRequest();
        xhr.open("GET", "/listDiagram", true);
        xhr.onload = () => {
            try {
                var list = JSON.parse(xhr.responseText || "[]");
                list.forEach(item => {
                    var opt = document.createElement("option");
                    opt.value = item.id;
                    opt.innerText = item.title;
                    sel.appendChild(opt);
                });
            } catch (e) {}
        };
        xhr.send();
    }

    function loadSelectedDiagram() {
        var sel = document.getElementById("diagramSelect");
        if (!sel) return;
        var id = sel.value;
        if (!id) {
            showToast("请选择流程图", "error");
            return;
        }

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/loadDiagramById", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send("id=" + id);
        xhr.onload = function() {
            try {
                var resp = JSON.parse(xhr.responseText);
                if (resp.success) {
                    setXML(resp.content);
                    document.getElementById("title").value = resp.title || "";
                    showToast("加载成功！", "success");
                } else {
                    showToast("加载失败：" + (resp.message || "未知错误"), "error");
                }
            } catch (e) {
                console.error("解析响应失败", e);
                showToast("加载失败：服务器返回的数据格式错误", "error");
            }
        };
        xhr.onerror = function() {
            showToast("网络请求失败", "error");
        };
    }

    function deleteDiagram() {
        var sel = document.getElementById("diagramSelect");
        if (!sel) return;
        var id = sel.value;
        if (!id) {
            showToast("请选择流程图", "error");
            return;
        }
        if (!confirm("确定删除？")) return;
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "/deleteDiagram", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send("id="+id);
        xhr.onload = () => {
            if (xhr.responseText === "success") {
                showToast("删除成功！", "success");
                loadList();
                newDiagram();
            } else {
                showToast("删除失败！", "error");
            }
        };
        xhr.onerror = () => showToast("网络错误", "error");
    }
</script>
</body>
</html>