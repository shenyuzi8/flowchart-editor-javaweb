<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>完整版在线流程图/思维导图</title>
    <!-- 直接用CDN，不用下载任何文件 -->
    <script src="https://cdn.jsdelivr.net/npm/mxgraph@4.2.2/javascript/mxClient.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            padding: 10px;
        }
        .toolbar {
            display: flex;
            gap: 8px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }
        .toolbar button {
            padding: 6px 10px;
            cursor: pointer;
        }
        #container {
            width: 100%;
            height: 650px;
            border: 1px solid #aaa;
            background: white;
        }
        .top {
            margin-bottom: 10px;
            display: flex;
            gap: 10px;
            align-items: center;
        }
        input, select {
            padding: 6px;
            width: 220px;
        }
    </style>
</head>
<body>

<div class="top">
    图表标题：<input id="title" placeholder="请输入你的图表标题">
    类型：
    <select id="type">
        <option value="flowchart">流程图</option>
        <option value="mindmap">思维导图</option>
    </select>
    <button onclick="save()" style="background:#4299e1;color:white;border:none;padding:8px 16px">💾 保存到云端</button>
</div>

<!-- 工具栏 -->
<div class="toolbar">
    <button onclick="addRectangle()">矩形</button>
    <button onclick="addCircle()">椭圆/圆形</button>
    <button onclick="addRhombus()">菱形（判断）</button>
    <button onclick="addText()">文本框</button>
    <button onclick="deleteSelected()">删除选中</button>
    <button onclick="zoomIn()">放大 +</button>
    <button onclick="zoomOut()">缩小 -</button>
</div>

<!-- 绘图画布 -->
<div id="container"></div>

<script>
    // 初始化 mxGraph
    mxEvent.disableContextMenu(document.body);
    let container = document.getElementById('container');
    let graph = new mxGraph(container);

    // 启用核心功能
    graph.setConnectable(true);          // 允许连线
    graph.setCellsMovable(true);         // 允许拖动
    graph.setCellsResizable(true);       // 允许缩放大小
    graph.setCellsEditable(true);        // 双击改文字
    graph.setAllowDanglingEdges(false);  // 禁止悬空连线

    // 鼠标滚轮缩放
    graph.setPanning(true);
    graph.panningHandler.useLeftButtonForPanning = true;

    let parent = graph.getDefaultParent();

    // 默认示例节点
    graph.getModel().beginUpdate();
    try {
        let start = graph.insertVertex(parent, null, '开始', 50, 50, 100, 40);
        let step1 = graph.insertVertex(parent, null, '步骤1', 200, 50, 100, 40);
        let judge = graph.insertVertex(parent, null, '判断', 350, 50, 100, 60, 'shape=rhombus');
        let end = graph.insertVertex(parent, null, '结束', 500, 50, 100, 40);

        graph.insertEdge(parent, null, '是', start, step1);
        graph.insertEdge(parent, null, '', step1, judge);
        graph.insertEdge(parent, null, '通过', judge, end);
    } finally {
        graph.getModel().endUpdate();
    }

    // ==================== 工具栏功能 ====================
    function addRectangle() {
        graph.getModel().beginUpdate();
        try {
            graph.insertVertex(parent, null, '矩形', 100, 150, 100, 40);
        } finally {
            graph.getModel().endUpdate();
        }
    }

    function addCircle() {
        graph.getModel().beginUpdate();
        try {
            graph.insertVertex(parent, null, '圆形', 100, 220, 80, 80, 'shape=ellipse');
        } finally {
            graph.getModel().endUpdate();
        }
    }

    function addRhombus() {
        graph.getModel().beginUpdate();
        try {
            graph.insertVertex(parent, null, '判断', 100, 320, 100, 60, 'shape=rhombus');
        } finally {
            graph.getModel().endUpdate();
        }
    }

    function addText() {
        graph.getModel().beginUpdate();
        try {
            graph.insertVertex(parent, null, '文本', 100, 400, 100, 30);
        } finally {
            graph.getModel().endUpdate();
        }
    }

    function deleteSelected() {
        graph.removeCells(graph.getSelectionCells());
    }

    function zoomIn() {
        graph.zoomIn();
    }

    function zoomOut() {
        graph.zoomOut();
    }

    // ==================== 保存功能 ====================
    async function save() {
        let title = document.getElementById('title').value.trim();
        let type = document.getElementById('type').value;

        if (!title) {
            alert('请输入图表标题！');
            return;
        }

        // 导出绘图数据
        let encoder = new mxCodec();
        let node = encoder.encode(graph.getModel());
        let content = mxUtils.getXml(node);

        <% if(session.getAttribute("user") == null) { %>
        // 未登录 → 本地存储
        localStorage.setItem('flowchart_' + new Date().getTime(), JSON.stringify({
            title: title,
            type: type,
            content: content
        }));
        alert('✅ 保存到本地成功！');
        return;
        <% } %>

        // 已登录 → 云端保存
        let res = await fetch('/saveChart', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `title=${encodeURIComponent(title)}&type=${type}&content=${encodeURIComponent(content)}`
        });

        let text = await res.text();
        if (text === 'success') {
            alert('✅ 云端保存成功！多端可同步');
        } else {
            alert('❌ 保存失败');
        }
    }
</script>

</body>
</html>