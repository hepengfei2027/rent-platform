<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="zh-CN">
<head>
    <title>商品列表 | 商品交易平台</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        :root {
            /* 极简高级配色系统 - 低饱和度+中性色为主 */
            --primary: #2d3748;
            --primary-accent: #4a5568;
            --secondary: #805ad5;
            --secondary-light: #9f7aea;
            --success: #38b2ac;
            --warning: #ed8936;
            --danger: #e53e3e;
            --gray-50: #fafafa;
            --gray-100: #f7fafc;
            --gray-200: #edf2f7;
            --gray-300: #e2e8f0;
            --gray-600: #718096;
            --gray-700: #4a5568;
            --gray-900: #1a202c;

            /* 极简尺寸系统 */
            --radius-sm: 6px;
            --radius-md: 8px;
            --radius-lg: 12px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.08);

            /* 过渡动画 - 极简缓动 */
            --transition: all 0.2s ease-in-out;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.5;
            color: var(--gray-900);
            background-color: var(--gray-50);
            -webkit-font-smoothing: antialiased;
            /* 添加顶部内边距，避免导航栏遮挡页面内容 */
            padding-top: 72px;
        }

        /* 导航栏样式 - 常驻顶部优化 */
        .navbar {
            background-color: white;
            box-shadow: var(--shadow-sm);
            position: fixed; /* 固定定位，常驻顶部 */
            top: 0;
            left: 0;
            right: 0; /* 左右铺满屏幕 */
            z-index: 999; /* 提高层级，避免被其他元素遮挡 */
            padding: 0 1.5rem;
            /* 增加滚动时的阴影过渡，提升视觉层次 */
            transition: box-shadow 0.3s ease-in-out;
        }

        /* 滚动时增强阴影，提升质感 */
        .navbar.scrolled {
            box-shadow: var(--shadow-md);
        }

        .nav-container {
            max-width: 1280px;
            margin: 0 auto;
            height: 72px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-brand {
            font-size: 1.4rem;
            font-weight: 600;
            color: var(--primary);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            letter-spacing: -0.02em;
        }

        .nav-brand::before {
            content: '';
            display: inline-block;
            width: 20px;
            height: 20px;
            background-color: var(--secondary);
            border-radius: var(--radius-sm);
        }

        /* 导航核心区域 */
        .nav-core {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 1.5rem;
            align-items: center;
        }

        .nav-link {
            color: var(--gray-700);
            text-decoration: none;
            padding: 0.5rem 0;
            border-bottom: 2px solid transparent;
            transition: var(--transition);
            font-weight: 500;
            font-size: 0.95rem;
        }

        .nav-link:hover {
            color: var(--secondary);
            border-bottom-color: var(--secondary-light);
        }

        .nav-link.active {
            color: var(--secondary);
            border-bottom-color: var(--secondary);
        }

        /* 用户信息区域 - 右上角极简布局 */
        .user-section {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-info {
            color: var(--gray-700);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .admin-badge {
            background-color: var(--danger);
            color: white;
            padding: 0.2rem 0.5rem;
            border-radius: 999px;
            font-size: 0.7rem;
            font-weight: 500;
        }

        .btn-logout {
            padding: 0.5rem 1rem;
            background-color: var(--gray-100);
            color: var(--gray-700);
            border-radius: var(--radius-sm);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            transition: var(--transition);
        }

        .btn-logout:hover {
            background-color: var(--gray-200);
            color: var(--danger);
        }

        /* 按钮样式 - 极简高级化 */
        .btn {
            padding: 0.65rem 1.25rem;
            border: none;
            border-radius: var(--radius-md);
            cursor: pointer;
            font-weight: 500;
            font-size: 0.9rem;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-primary {
            background-color: var(--secondary);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--secondary-light);
        }

        .btn-success {
            background-color: var(--success);
            color: white;
        }

        .btn-success:hover {
            background-color: #319795;
        }

        .btn-warning {
            background-color: var(--warning);
            color: white;
        }

        .btn-warning:hover {
            background-color: #dd6b20;
        }

        .btn-danger {
            background-color: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background-color: #c53030;
        }

        .btn-outline {
            border: 1px solid var(--gray-200);
            background-color: transparent;
            color: var(--gray-700);
        }

        .btn-outline:hover {
            background-color: var(--gray-100);
        }

        /* 主容器样式 */
        .container {
            max-width: 1280px;
            margin: 2.5rem auto;
            padding: 0 1.5rem;
        }

        .page-header {
            margin-bottom: 2.5rem;
        }

        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.75rem;
            letter-spacing: -0.02em;
        }

        .page-subtitle {
            color: var(--gray-600);
            font-size: 1rem;
            line-height: 1.6;
        }

        /* 搜索筛选栏 - 极简重构 */
        .search-filter-bar {
            background-color: white;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            padding: 1.5rem;
            margin-bottom: 2.5rem;
            display: flex;
            flex-wrap: wrap;
            gap: 1.5rem;
            align-items: center;
        }

        /* 分类筛选下拉组件 - 透明底色设计 */
        .category-dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-toggle {
            padding: 0.75rem 1rem;
            background-color: transparent;
            border: 1px solid var(--gray-200);
            border-radius: 0 var(--radius-md) var(--radius-md) 0;
            color: var(--gray-700);
            font-size: 0.9rem;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: var(--transition);
        }

        .dropdown-toggle:hover {
            background-color: var(--gray-50);
            border-color: var(--gray-300);
        }

        .dropdown-toggle svg {
            width: 16px;
            height: 16px;
            transition: var(--transition);
        }

        .dropdown-toggle.open svg {
            transform: rotate(180deg);
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            z-index: 100;
            min-width: 200px;
            background-color: white;
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-md);
            padding: 0.75rem 0;
            margin-top: 0.25rem;
            border: 1px solid var(--gray-200);
            display: none;
        }

        .dropdown-menu.show {
            display: block;
            animation: fadeIn 0.2s ease-in-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-5px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .dropdown-item {
            display: block;
            padding: 0.5rem 1rem;
            color: var(--gray-700);
            text-decoration: none;
            font-size: 0.9rem;
            transition: var(--transition);
        }

        .dropdown-item:hover {
            background-color: var(--gray-50);
            color: var(--secondary);
        }

        .dropdown-item.active {
            background-color: rgba(128, 90, 213, 0.1);
            color: var(--secondary);
            font-weight: 600;
        }

        /* 搜索表单 - 与下拉组件联动 */
        .search-form {
            flex: 1;
            min-width: 300px;
            display: flex;
            align-items: stretch;
        }

        .form-input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-md) 0 0 var(--radius-md);
            font-size: 0.9rem;
            transition: var(--transition);
            background-color: var(--gray-50);
        }

        .form-input:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 3px rgba(128, 90, 213, 0.1);
        }

        .search-btn {
            border-radius: 0 var(--radius-md) var(--radius-md) 0;
            border-left: none;
        }

        /* 商品网格 - 紧凑化调整 */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.25rem;
        }

        /* 商品卡片 - 极简高级质感 + 紧凑化 */
        .product-card {
            background-color: white;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            transition: var(--transition);
            border: 1px solid var(--gray-100);
        }

        .product-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
            border-color: var(--gray-200);
        }

        .product-card-body {
            padding: 1.2rem;
        }

        .product-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.875rem;
        }

        .product-name {
            font-size: 1.05rem;
            font-weight: 600;
            color: var(--gray-900);
            margin: 0;
            line-height: 1.3;
            letter-spacing: -0.01em;
        }

        .product-price-section {
            text-align: right;
        }

        .product-price {
            color: var(--danger);
            font-weight: 700;
            font-size: 1.05rem;
        }

        .product-rent {
            color: var(--secondary);
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        .product-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 0.875rem;
            margin-bottom: 0.875rem;
            padding-bottom: 0.875rem;
            border-bottom: 1px solid var(--gray-100);
            font-size: 0.875rem;
            color: var(--gray-600);
        }

        .product-owner, .product-category, .product-deposit {
            display: flex;
            align-items: center;
            gap: 0.35rem;
        }

        .product-status {
            padding: 0.25rem 0.75rem;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 500;
            display: inline-block;
            margin-left: 0.5rem;
        }

        .status-available {
            background-color: rgba(56, 178, 172, 0.1);
            color: var(--success);
        }

        .status-rented {
            background-color: rgba(237, 137, 54, 0.1);
            color: var(--warning);
        }

        .status-sold {
            background-color: rgba(229, 62, 62, 0.1);
            color: var(--danger);
        }

        .product-description-label {
            font-size: 0.85rem;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
        }

        .product-description {
            color: var(--gray-600);
            margin-bottom: 0.875rem;
            font-size: 0.875rem;
            line-height: 1.6;
        }

        .product-actions {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .product-actions .btn {
            flex: 1;
            min-width: 90px;
            padding: 0.55rem 1rem;
            font-size: 0.85rem;
        }

        /* 租赁表单 - 紧凑化 */
        .rent-form {
            display: none;
            background-color: var(--gray-50);
            padding: 0.875rem;
            border-radius: var(--radius-md);
            margin-top: 0.875rem;
            border: 1px solid var(--gray-200);
        }

        .rent-form-header {
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--gray-700);
            font-size: 0.95rem;
        }

        .rent-form-group {
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .rent-form-label {
            font-size: 0.9rem;
            color: var(--gray-700);
            min-width: 80px;
        }

        .rent-input {
            width: 100px;
            padding: 0.5rem;
            border: 1px solid var(--gray-200);
            border-radius: var(--radius-sm);
            font-size: 0.9rem;
            background-color: white;
        }

        .rent-input:focus {
            outline: none;
            border-color: var(--secondary);
        }

        .rent-total {
            font-weight: 600;
            color: var(--secondary);
        }

        .rent-form-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 0.5rem;
        }

        /* 空状态 */
        .empty-state {
            text-align: center;
            padding: 5rem 2rem;
            background-color: white;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            margin-bottom: 2rem;
            border: 1px solid var(--gray-100);
        }

        .empty-state-icon {
            font-size: 3.5rem;
            color: var(--gray-300);
            margin-bottom: 1.25rem;
        }

        .empty-state-text {
            font-size: 1.125rem;
            color: var(--gray-600);
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        /* 响应式适配 */
        @media (max-width: 768px) {
            .nav-container {
                height: auto;
                padding: 1rem 0;
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .nav-core {
                width: 100%;
                justify-content: space-between;
            }

            .nav-menu {
                flex-wrap: wrap;
                gap: 1rem;
            }

            .user-section {
                width: 100%;
                justify-content: flex-end;
                margin-top: 0.5rem;
            }

            .products-grid {
                grid-template-columns: 1fr;
                gap: 1rem;
            }

            .product-actions {
                flex-direction: column;
            }

            .product-actions .btn {
                width: 100%;
            }
        }

        @media (max-width: 480px) {
            .search-filter-bar {
                padding: 1.25rem;
            }

            .search-form {
                min-width: 100%;
            }

            .page-title {
                font-size: 1.75rem;
            }
        }


        /* 模态弹窗样式 */
        .modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            /* 半透明渐变背景 */
            background: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.6));
            z-index: 9999;
            display: flex;
            justify-content: center;
            align-items: center;
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease-in-out, visibility 0.3s ease-in-out;
        }

        .modal.show {
            opacity: 1;
            visibility: visible;
        }

        .modal-content {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            padding: 2rem;
            width: 90%;
            max-width: 400px;
            transform: scale(0.95);
            transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1),
            opacity 0.3s ease-in-out;
            opacity: 0;
        }

        .modal.show .modal-content {
            transform: scale(1);
            opacity: 1;
        }

        .modal-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--gray-900);
            margin-bottom: 1rem;
        }

        .modal-message {
            color: var(--gray-600);
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .modal-actions {
            display: flex;
            gap: 0.75rem;
            justify-content: flex-end;
        }

        .modal-actions .btn {
            padding: 0.65rem 1.25rem;
            font-weight: 500;
            font-size: 0.9rem;
            border-radius: 8px;
            transition: transform 0.2s ease-in-out;
        }

        .modal-actions .btn:hover {
            transform: translateY(-2px);
        }


        /* 支付成功消息通知 - 高级渐变+顺滑动效+清晰字体 */
        .notification {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: linear-gradient(135deg, #2d2d2d, #1a1a1a); /* 深色渐变 */
            color: #f5e7b8; /* 金色文字 */
            font-weight: 700; /* 字体加粗 */
            padding: 14px 26px;
            border-radius: 12px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.07), 0 2px 4px rgba(0,0,0,0.05);
            z-index: 9999;
            font-size: 0.95rem;
            border: 1px solid rgba(255,255,255,0.8);
            /* 升级顺滑动效 比原来更丝滑 */
            opacity: 0;
            transform: translateY(30px) scale(0.96);
            transition: all 0.35s cubic-bezier(0.22, 1, 0.36, 1);
            backdrop-filter: blur(4px);
        }

        .notification.show {
            opacity: 1;
            transform: translateY(0) scale(1);
        }

    </style>
</head>
<body>
<!-- 导航栏 -->
<nav class="navbar" id="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="nav-brand">校园资源共享租赁平台</a>

        <div class="nav-core">
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/product/list" class="nav-link active">商品列表</a></li>
                <c:if test="${sessionScope.currentUser.role == 'admin'}">
                    <li><a href="/admin/dashboard" class="nav-link">管理员后台</a></li>
                    <li><a href="/admin/product/pending" class="nav-link">商品审核</a></li>
                </c:if>

                <c:if test="${not empty sessionScope.currentUser}">
                    <!-- 仅非管理员显示 -->
                    <c:if test="${sessionScope.currentUser.role != 'admin'}">
                        <li><a href="${pageContext.request.contextPath}/order/my" class="nav-link">我的订单</a></li>
                        <li><a href="/user/center" class="nav-link">个人中心</a></li>
                    </c:if>
                </c:if>

                <c:if test="${empty sessionScope.currentUser}">
                    <li><a href="${pageContext.request.contextPath}/user/auth" class="nav-link">登录/注册</a></li>
                </c:if>
            </ul>

            <!-- 用户信息区域 - 右上角极简布局 -->
            <div class="user-section">
                <c:if test="${not empty sessionScope.currentUser}">
                    <div class="user-info">
                        <span>欢迎，${sessionScope.currentUser.nickname}</span>
                        <c:if test="${sessionScope.currentUser.role == 'admin'}">
                            <span class="admin-badge">管理员</span>
                        </c:if>
                    </div>
                    <a href="${pageContext.request.contextPath}/user/logout" class="btn-logout">退出</a>
                </c:if>
            </div>
        </div>
    </div>
</nav>

<!-- 主内容区 -->
<main class="container">

    <!-- 搜索和筛选栏 -->
    <div class="search-filter-bar">
        <form action="${pageContext.request.contextPath}/product/search" method="get" class="search-form">
            <input type="text" name="name" class="form-input" placeholder="输入商品名称搜索..." value="${searchName}">

            <!-- 分类筛选下拉组件 - 搜索框右侧 -->
            <div class="category-dropdown">
                <button type="button" class="dropdown-toggle" id="categoryToggle">
                    <span>
                        <c:choose>
                            <c:when test="${not empty param.category}">${param.category}</c:when>
                            <c:otherwise>商品分类</c:otherwise>
                        </c:choose>
                    </span>
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                    </svg>
                </button>
                <div class="dropdown-menu" id="categoryMenu">
                    <a href="${pageContext.request.contextPath}/product/list" class="dropdown-item ${empty param.category ? 'active' : ''}">全部</a>
                    <a href="${pageContext.request.contextPath}/product/list?category=书籍" class="dropdown-item ${param.category == '书籍' ? 'active' : ''}">书籍</a>
                    <a href="${pageContext.request.contextPath}/product/list?category=数码" class="dropdown-item ${param.category == '数码' ? 'active' : ''}">数码</a>
                    <a href="${pageContext.request.contextPath}/product/list?category=体育器材" class="dropdown-item ${param.category == '体育器材' ? 'active' : ''}">体育器材</a>
                    <a href="${pageContext.request.contextPath}/product/list?category=其他" class="dropdown-item ${param.category == '其他' ? 'active' : ''}">其他</a>
                </div>
            </div>

            <button type="submit" class="btn btn-primary search-btn">
                <span class="btn-icon"></span> 搜索
            </button>
        </form>

        <a href="${pageContext.request.contextPath}/product/add" class="btn btn-success">
            <span class="btn-icon"></span> 添加商品
        </a>
    </div>

    <!-- 空状态 -->
    <c:if test="${empty products}">
        <div class="empty-state">
            <div class="empty-state-icon">📦</div>
            <p class="empty-state-text">暂无商品数据</p>
            <a href="${pageContext.request.contextPath}/product/add" class="btn btn-success">
                <span class="btn-icon"></span> 添加第一个商品
            </a>
        </div>
    </c:if>

    <!-- 商品卡片 -->
    <div class="products-grid">
        <c:forEach items="${products}" var="product">
            <div class="product-card">
                <div class="product-card-body">
                    <div class="product-header">
                        <h3 class="product-name">${product.name}</h3>
                        <div class="product-price-section">
                            <div class="product-price">¥${product.price}</div>
                            <c:if test="${product.rentPrice != null}">
                                <div class="product-rent">租：¥${product.rentPrice}/天</div>
                            </c:if>
                        </div>
                    </div>

                    <div class="product-meta">
                        <div class="product-owner">
                            <span>👤</span> 所有者：${product.ownerName}
                            <c:choose>
                                <c:when test="${product.status == 1}">
                                    <span class="product-status status-available">可租</span>
                                </c:when>
                                <c:when test="${product.status == 2}">
                                    <span class="product-status status-rented">已租</span>
                                </c:when>
                                <c:when test="${product.status == 3}">
                                    <span class="product-status status-sold">下架</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="product-status" style="background-color: rgba(113, 128, 150, 0.1); color: var(--gray-600);">下架</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="product-category">
                            <span>📂</span> 分类：${product.category}
                        </div>
                        <div class="product-deposit">
                            <span>🔒</span>
                            <c:if test="${product.deposit != null && product.deposit > 0}">
                                押金：¥${product.deposit}
                            </c:if>
                            <c:if test="${product.deposit == null || product.deposit == 0}">
                                押金：无
                            </c:if>
                        </div>
                    </div>

                    <div>
                        <p>商家评分:
                            <span class="star-rating">
                <c:forEach begin="1" end="5" var="i">
                    <c:choose>
                        <c:when test="${i <= ownerAvgRatings[product.id]}">★</c:when>
                        <c:otherwise>☆</c:otherwise>
                    </c:choose>
                </c:forEach>
            </span>
                                ${ownerAvgRatings[product.id]}分
                        </p>
                    </div>


                    <div class="product-description-label">商品描述和租赁规则：</div>
                    <c:if test="${not empty product.description}">
                        <div class="product-description">${product.description}</div>
                    </c:if>

                    <div class="product-actions">
                        <!-- 购买和租赁按钮 -->
                        <c:if test="${not empty sessionScope.currentUser}">
                            <c:if test="${product.status == 1}">
                                <form action="${pageContext.request.contextPath}/order/buy" method="post" style="display: inline; flex: 1; min-width: 90px;">
                                    <input type="hidden" name="productId" value="${product.id}">
                                    <button type="submit" class="btn btn-primary">
                                        <span class="btn-icon"></span> 购买
                                    </button>
                                </form>

                                <c:if test="${product.rentPrice != null}">
                                    <button type="button" class="btn btn-warning" onclick="showRentForm(${product.id})">
                                        <span class="btn-icon"></span> 租赁
                                    </button>
                                </c:if>
                            </c:if>
                        </c:if>

                        <!-- 编辑和删除按钮 -->
                        <c:if test="${not empty sessionScope.currentUser && (sessionScope.currentUser.id == product.ownerId || sessionScope.currentUser.role == 'admin')}">
                            <a href="${pageContext.request.contextPath}/product/edit/${product.id}" class="btn btn-outline">
                                <span class="btn-icon">✏️</span> 编辑
                            </a>
                            <a href="${pageContext.request.contextPath}/product/delete/${product.id}"
                               onclick="return confirm('确定删除商品【${product.name}】吗？')"
                               class="btn btn-danger">
                                <span class="btn-icon">🗑️</span> 删除
                            </a>
                        </c:if>
                    </div>

                    <!-- 租赁表单 -->
                    <div id="rentForm${product.id}" class="rent-form">
                        <div class="rent-form-header">租赁信息</div>
                        <form action="/order/rent" method="post">
                            <input type="hidden" name="productId" value="${product.id}">
                            <input type="hidden" id="rentPrice${product.id}" value="${product.rentPrice}">

                            <div class="rent-form-group">
                                <label class="rent-form-label">租赁天数：</label>
                                <input type="number"
                                       name="rentDays"
                                       id="rentDays${product.id}"
                                       class="rent-input"
                                       min="1"
                                       max="30"
                                       value="1"
                                       required
                                       oninput="calculateRentTotal(${product.id})">
                                <span>天</span>
                            </div>

                            <div class="rent-form-group">
                                <label class="rent-form-label">租赁总费用：</label>
                                <span class="rent-total">¥<span id="rentTotal${product.id}">${product.rentPrice}</span>元</span>
                            </div>

                            <div class="rent-form-actions">
                                <button type="submit" class="btn btn-success">确认租赁</button>
                                <button type="button" class="btn btn-outline" onclick="hideRentForm(${product.id})">取消</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 模态确认弹窗 -->
    <div id="confirmModal" class="modal">
        <div class="modal-content">
            <h3 class="modal-title" id="modalTitle">确认操作</h3>
            <p class="modal-message" id="modalMessage">请确认您的操作。</p>
            <div class="modal-actions">
                <button id="modalConfirmBtn" class="btn btn-primary">支付</button>
                <button id="modalCancelBtn" class="btn btn-outline">取消</button>
            </div>
        </div>
    </div>

</main>


<script>
    // 分类下拉菜单交互
    const categoryToggle = document.getElementById('categoryToggle');
    const categoryMenu = document.getElementById('categoryMenu');

    categoryToggle.addEventListener('click', function() {
        categoryMenu.classList.toggle('show');
        this.classList.toggle('open');
    });

    // 点击外部关闭下拉菜单
    document.addEventListener('click', function(e) {
        if (!categoryToggle.contains(e.target) && !categoryMenu.contains(e.target)) {
            categoryMenu.classList.remove('show');
            categoryToggle.classList.remove('open');
        }
    });

    // 显示租赁表单
    function showRentForm(productId) {
        document.querySelectorAll('.rent-form').forEach(form => {
            form.style.display = 'none';
        });
        const rentForm = document.getElementById('rentForm' + productId);
        rentForm.style.display = 'block';
        calculateRentTotal(productId);
    }

    // 隐藏租赁表单
    function hideRentForm(productId) {
        document.getElementById('rentForm' + productId).style.display = 'none';
    }

    // 计算租赁总费用
    function calculateRentTotal(productId) {
        const rentDaysInput = document.getElementById('rentDays' + productId);
        if (!rentDaysInput) return;
        const days = parseInt(rentDaysInput.value) || 1;
        const rentPrice = parseFloat(document.getElementById('rentPrice' + productId).value) || 0;
        const total = rentPrice * days;
        const totalElement = document.getElementById('rentTotal' + productId);
        if (totalElement) {
            totalElement.textContent = total.toFixed(2);
        }
    }

    // 页面加载时初始化所有租赁表单的计算
    document.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('.rent-form').forEach(form => {
            const productId = form.id.replace('rentForm', '');
            if (productId) {
                calculateRentTotal(productId);
            }
        });
    });

    // 导航栏滚动阴影效果
    window.addEventListener('scroll', function() {
        const navbar = document.getElementById('navbar');
        if (window.scrollY > 10) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });
    // 用户下拉菜单交互
    const userTrigger = document.getElementById('userTrigger');
    const userDropdownMenu = document.getElementById('userDropdownMenu');

    if (userTrigger) {
        userTrigger.addEventListener('click', function(e) {
            e.stopPropagation();
            userDropdownMenu.classList.toggle('show');
            this.classList.toggle('open');
        });

        // 点击外部关闭下拉菜单
        document.addEventListener('click', function(e) {
            if (!userTrigger.contains(e.target) && !userDropdownMenu.contains(e.target)) {
                userDropdownMenu.classList.remove('show');
                userTrigger.classList.remove('open');
            }
        });
    }

    // 模态弹窗相关
    const modal = document.getElementById('confirmModal');
    const modalTitle = document.getElementById('modalTitle');
    const modalMessage = document.getElementById('modalMessage');
    const modalConfirmBtn = document.getElementById('modalConfirmBtn');
    const modalCancelBtn = document.getElementById('modalCancelBtn');

    let pendingForm = null; // 保存待提交的表单

    // 打开弹窗
    function openModal(title, message, form) {
        modalTitle.textContent = title;
        modalMessage.textContent = message;
        pendingForm = form;
        modal.classList.add('show'); // 用 class 控制显示
    }

    function closeModal() {
        modal.classList.remove('show'); // 用 class 控制隐藏
    }

    // 确认提交
    modalConfirmBtn.addEventListener('click', () => {
        if (pendingForm) {
            pendingForm.submit();
        }
        closeModal();
    });

    // 取消
    modalCancelBtn.addEventListener('click', closeModal);

    // 点击模态背景关闭
    modal.addEventListener('click', (e) => {
        if (e.target === modal) {
            closeModal();
        }
    });

    // 购买确认
    document.querySelectorAll('form[action*="/order/buy"]').forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            openModal('购买确认', `您确定要购买此商品吗？`, this);
        });
    });

    // 租赁确认
    document.querySelectorAll('form[action*="/order/rent"]').forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            openModal('租赁确认', `您确定要租赁此商品吗？`, this);


        });
    });

    // 确认提交
    modalConfirmBtn.addEventListener('click', () => {
        if (pendingForm) {
            pendingForm.submit();
            // 刷新前：将支付成功状态存入 sessionStorage
            sessionStorage.setItem('paymentSuccess', 'true');
            // 原通知逻辑，刷新后会被新逻辑替代
            // showNotification();
        }
        closeModal();
    });
    // 显示通知
    function showNotification() {
        const notification = document.getElementById('notification');
        notification.classList.remove('show');
        // 延迟一帧再添加 show
        requestAnimationFrame(() => {
            notification.classList.add('show');
        });
        setTimeout(() => {
            notification.classList.remove('show');
        }, 1000);
    }

    document.addEventListener('DOMContentLoaded', function() {
        // 初始化所有租赁表单的计算
        document.querySelectorAll('.rent-form').forEach(form => {
            const productId = form.id.replace('rentForm', '');
            if (productId) {
                calculateRentTotal(productId);
            }
        });

        // 刷新后：检查 sessionStorage 中的支付成功状态
        if (sessionStorage.getItem('paymentSuccess') === 'true') {
            // 显示通知
            showNotification();
            // 通知显示后清除状态，防止重复显示
            setTimeout(() => {
                sessionStorage.removeItem('paymentSuccess');
            }, 1000); // 与通知显示时长一致
        }
    });



</script>
<div id="notification" class="notification">支付成功</div>
</body>
</html>