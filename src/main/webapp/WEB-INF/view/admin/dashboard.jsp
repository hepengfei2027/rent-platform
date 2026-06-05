<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html lang="zh-CN">
<head>
    <title>管理员后台 | 商品交易平台</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        :root {
            /* 全站统一配色系统 */
            --primary: #805ad5;
            --primary-light: #9f7aea;
            --success: #38b2ac;
            --warning: #ed8936;
            --danger: #e53e3e;
            --info: #4299e1;
            --gray-50: #fafafa;
            --gray-100: #f7fafc;
            --gray-200: #edf2f7;
            --gray-300: #e2e8f0;
            --gray-600: #718096;
            --gray-700: #4a5568;
            --gray-800: #2d3748;
            --gray-900: #1a202c;

            /* 尺寸系统 */
            --radius-sm: 6px;
            --radius-md: 8px;
            --radius-lg: 12px;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 6px rgba(0,0,0,0.08);
            --transition: all 0.2s ease-in-out;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            line-height: 1.5;
            color: var(--gray-900);
            background-color: var(--gray-50);
            padding-top: 72px; /* 适配固定导航栏 */
        }

        /* 导航栏样式 - 常驻顶部 */
        .navbar {
            background-color: white;
            box-shadow: var(--shadow-sm);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 999;
            padding: 0 1.5rem;
            transition: box-shadow 0.3s ease-in-out;
        }

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
            color: var(--gray-900);
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
            background-color: var(--primary);
            border-radius: var(--radius-sm);
        }

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
            color: var(--primary);
            border-bottom-color: var(--primary-light);
        }

        .nav-link.active {
            color: var(--primary);
            border-bottom-color: var(--primary);
        }

        /* 用户信息区域 - 下拉收纳 */
        .user-section {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-dropdown {
            position: relative;
            display: inline-block;
        }

        .user-trigger {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem;
            border-radius: var(--radius-sm);
            cursor: pointer;
            transition: var(--transition);
            color: var(--gray-700);
            font-size: 0.9rem;
            border: 1px solid transparent;
        }

        .user-trigger:hover {
            background-color: var(--gray-50);
            border-color: var(--gray-200);
        }

        .user-trigger svg {
            width: 16px;
            height: 16px;
            transition: var(--transition);
        }

        .user-trigger.open svg {
            transform: rotate(180deg);
        }

        .user-dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            z-index: 1000;
            min-width: 160px;
            background-color: white;
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-md);
            padding: 0.5rem 0;
            margin-top: 0.25rem;
            border: 1px solid var(--gray-200);
            display: none;
            animation: fadeIn 0.2s ease-in-out;
        }

        .user-dropdown-menu.show {
            display: block;
        }

        .user-dropdown-item {
            display: block;
            padding: 0.65rem 1.25rem;
            color: var(--gray-700);
            text-decoration: none;
            font-size: 0.9rem;
            transition: var(--transition);
            text-align: right;
        }

        .user-dropdown-item:hover {
            background-color: var(--gray-50);
            color: var(--danger);
        }

        .user-dropdown-item.logout {
            color: var(--danger);
            font-weight: 500;
        }

        .admin-badge {
            background-color: var(--danger);
            color: white;
            padding: 0.2rem 0.5rem;
            border-radius: 999px;
            font-size: 0.7rem;
            font-weight: 500;
        }

        /* 主容器样式 */
        .container {
            max-width: 1200px;
            margin: 2.5rem auto;
            padding: 0 1.5rem;
        }

        /* 页面标题样式 */
        .page-header {
            margin-bottom: 2rem;
        }

        .page-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--gray-900);
            margin-bottom: 0.5rem;
        }

        /* 统计卡片样式 */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            box-shadow: var(--shadow-sm);
            border-left: 4px solid var(--primary);
        }

        .stat-card.primary {
            border-left-color: var(--primary);
        }

        .stat-card.success {
            border-left-color: var(--success);
        }

        .stat-card-title {
            font-size: 1rem;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }

        .stat-desc {
            font-size: 0.85rem;
            color: var(--gray-600);
        }

        /* 分类排名样式 */
        .rank-list {
            margin-top: 1rem;
        }

        .rank-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid var(--gray-200);
        }

        .rank-item:last-child {
            border-bottom: none;
        }

        .rank-number {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 24px;
            height: 24px;
            background-color: var(--primary-light);
            color: white;
            border-radius: 50%;
            font-size: 0.8rem;
            margin-right: 0.5rem;
        }

        .rank-count {
            font-weight: 600;
            color: var(--danger);
        }

        /* 通知提示样式 */
        .alert {
            padding: 1rem;
            border-radius: var(--radius-md);
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }

        .alert-success {
            background-color: rgba(56, 178, 172, 0.1);
            color: var(--success);
            border: 1px solid rgba(56, 178, 172, 0.2);
        }

        .alert-error {
            background-color: rgba(229, 62, 62, 0.1);
            color: var(--danger);
            border: 1px solid rgba(229, 62, 62, 0.2);
        }

        /* 表格样式 */
        .card {
            background: white;
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            margin-bottom: 2rem;
        }

        .card-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--gray-200);
        }

        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--gray-800);
        }

        .card-body {
            padding: 1.5rem;
        }

        .user-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }

        .user-table th {
            background-color: var(--gray-50);
            color: var(--gray-700);
            font-weight: 600;
            padding: 1rem;
            text-align: left;
            border-bottom: 2px solid var(--gray-200);
        }

        .user-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--gray-200);
            vertical-align: top;
        }

        .user-table tbody tr {
            transition: var(--transition);
        }

        .user-table tbody tr:hover {
            background-color: var(--gray-50);
        }

        .user-table tbody tr.banned {
            background-color: rgba(229, 62, 62, 0.05);
        }

        .user-table tbody tr.banned:hover {
            background-color: rgba(229, 62, 62, 0.1);
        }

        /* 状态标签样式 */
        .status-tag {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: 999px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .status-normal {
            background-color: rgba(56, 178, 172, 0.1);
            color: var(--success);
        }

        .status-banned {
            background-color: rgba(229, 62, 62, 0.1);
            color: var(--danger);
        }

        .admin-badge-tag {
            background-color: var(--danger);
            color: white;
            padding: 0.2rem 0.5rem;
            border-radius: 999px;
            font-size: 0.75rem;
            margin-left: 0.5rem;
        }

        /* 表单和按钮样式 */
        .admin-form {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 0.75rem;
            flex-wrap: wrap;
        }

        .form-control {
            padding: 0.5rem;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-sm);
            font-size: 0.85rem;
            transition: var(--transition);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(128, 90, 213, 0.1);
        }

        .form-checkbox {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.8rem;
            color: var(--gray-700);
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.25rem;
            padding: 0.5rem 0.75rem;
            border: none;
            border-radius: var(--radius-sm);
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 500;
            transition: var(--transition);
        }

        .btn:hover {
            transform: translateY(-1px);
        }

        .btn-warning {
            background-color: var(--warning);
            color: white;
        }

        .btn-warning:hover {
            background-color: #dd7700;
        }

        .btn-danger {
            background-color: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background-color: #c02639;
        }

        .btn-success {
            background-color: var(--success);
            color: white;
        }

        .btn-success:hover {
            background-color: #2c8580;
        }

        .text-muted {
            color: var(--gray-600);
            font-size: 0.8rem;
        }

        /* 空状态样式 */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: var(--gray-600);
        }

        /* 动画效果 */
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

            body {
                padding-top: 120px;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }

            .admin-form {
                flex-direction: column;
                align-items: stretch;
            }

            .user-table {
                display: block;
                overflow-x: auto;
            }

            .card-body {
                padding: 1rem;
            }
        }

        @media (max-width: 480px) {
            .page-title {
                font-size: 1.5rem;
            }

            .stat-value {
                font-size: 1.25rem;
            }
        }
    </style>
</head>
<body>
<!-- 导航栏 - 与全站保持一致 -->
<nav class="navbar" id="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="nav-brand">校园资源共享租赁平台</a>

        <div class="nav-core">
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/product/list" class="nav-link">商品列表</a></li>
                <li><a href="/admin/dashboard" class="nav-link active">管理员后台</a></li>
                <li><a href="/admin/product/pending" class="nav-link">商品审核</a></li>
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

            <!-- 用户信息区域 - 下拉收纳退出按钮 -->
            <div class="user-section">
                <c:if test="${not empty sessionScope.currentUser}">
                    <div class="user-dropdown" id="userDropdown">
                        <div class="user-trigger" id="userTrigger">
                            <span>欢迎，${sessionScope.currentUser.nickname}</span>
                            <c:if test="${sessionScope.currentUser.role == 'admin'}">
                                <span class="admin-badge">管理员</span>
                            </c:if>
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                            </svg>
                        </div>
                        <div class="user-dropdown-menu" id="userDropdownMenu">
                            <a href="${pageContext.request.contextPath}/user/logout" class="user-dropdown-item logout" onclick="return confirm('确定退出登录吗？')">
                                退出登录
                            </a>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</nav>

<!-- 管理员后台主内容区 -->
<div class="container">
    <div class="page-header">
        <h1 class="page-title">管理员后台</h1>
    </div>

    <!-- 数据统计区域 -->
    <div class="stats-container">
        <!-- 商品分类统计卡片 -->
        <div class="stat-card primary">
            <h3 class="stat-card-title">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"></path>
                    <polyline points="3.27 6.96 12 12.01 20.73 6.96"></polyline>
                    <line x1="12" y1="22.08" x2="12" y2="12"></line>
                </svg>
                热门物品
            </h3>
            <div class="stat-desc">热门租赁物品排行（总计：${totalProducts} 件商品）</div>

            <c:if test="${not empty categoryStats}">
                <div class="rank-list">
                    <c:set var="rank" value="1" />
                    <c:forEach items="${categoryStats}" var="stat">
                        <div class="rank-item">
                            <span>
                                <span class="rank-number">${rank}</span>
                                ${stat.key}
                            </span>
                            <span class="rank-count">${stat.value} 件</span>
                        </div>
                        <c:set var="rank" value="${rank + 1}" />
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${empty categoryStats}">
                <p class="text-muted" style="margin-top: 1rem;">暂无商品数据</p>
            </c:if>
        </div>

        <!-- 交易总额卡片 -->
        <div class="stat-card success">
            <h3 class="stat-card-title">
                <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="2" y="2" width="20" height="20" rx="5" ry="5"></rect>
                    <path d="M16 10a4 4 0 0 1-8 0"></path>
                    <line x1="12" y1="14" x2="12" y2="20"></line>
                </svg>
                交易总额
            </h3>
            <div class="stat-value" style="color: var(--success);">
                ¥<fmt:formatNumber value="${totalAmount}" pattern="#,##0.00"/>
            </div>
            <div class="stat-desc">全平台累计交易金额</div>
        </div>
    </div>

    <!-- 用户管理区域 -->
    <div class="card">
        <div class="card-header">
            <h2 class="card-title">用户管理</h2>
        </div>
        <div class="card-body">
            <!-- 提示信息 -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                        ${fn:escapeXml(success)}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-error">
                        ${fn:escapeXml(error)}
                </div>
            </c:if>

            <!-- 用户表格 -->
            <table class="user-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>昵称</th>
                    <th>信誉分</th>
                    <th>余额</th>
                    <th>状态</th>
                    <th>注册时间</th>
                    <th>平均评分</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty users}">
                        <c:forEach items="${users}" var="user">
                            <tr class="${user.banned ? 'banned' : ''}">
                                <td>${user.id}</td>
                                <td>
                                        ${fn:escapeXml(user.username)}
                                    <c:if test="${user.role == 'admin'}">
                                        <span class="admin-badge-tag">管理员</span>
                                    </c:if>
                                </td>
                                <td>${fn:escapeXml(user.nickname)}</td>
                                <td>${user.creditScore}</td>
                                <td>¥${user.balance}</td>

                                <td>
                                    <c:choose>
                                        <c:when test="${user.banned}">
                                            <span class="status-tag status-banned">已封禁</span>
                                            <div class="text-muted" style="margin-top: 0.5rem;">
                                                <div>原因: ${fn:escapeXml(user.banReason)}</div>
                                                <div>到期: <fmt:formatDate value="${user.banEndTime}" pattern="yyyy-MM-dd HH:mm:ss" /></div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-tag status-normal">正常</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
                                <td> ${userAvgRatings[user.id]}分</td>
                                <td>
                                    <c:if test="${user.role != 'admin'}">
                                        <!-- 扣除信誉分表单 -->
                                        <form action="/admin/deductCredit" method="post" class="admin-form">
                                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                                            <input type="hidden" name="userId" value="${user.id}">
                                            <input type="number" name="deductScore"
                                                   placeholder="扣分"
                                                   min="1" max="${user.creditScore}"
                                                   style="width: 70px;" required class="form-control">
                                            <input type="text" name="reason" placeholder="原因" style="width: 120px;" required class="form-control">
                                            <button type="submit" class="btn btn-warning" onclick="return confirm('确认扣减该用户信誉分？')">扣分</button>
                                        </form>

                                        <!-- 封禁用户表单 -->
                                        <form action="/admin/banUser" method="post" class="admin-form">
                                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                                            <input type="hidden" name="userId" value="${user.id}">
                                            <input type="number" name="banDays" placeholder="天数" min="1" max="365" style="width: 70px;" required class="form-control">
                                            <label class="form-checkbox">
                                                <input type="checkbox" name="permanentBan" onchange="this.form.banDays.disabled=this.checked">
                                                永久封禁
                                            </label>
                                            <input type="text" name="reason" placeholder="封禁原因" style="width: 120px;" required class="form-control">
                                            <button type="submit" class="btn btn-danger" onclick="return confirm('确认封禁该用户？封禁后将限制其登录/使用功能！')">封禁</button>
                                        </form>

                                        <!-- 解封用户 -->
                                        <c:if test="${user.banned}">
                                            <form action="/admin/unbanUser" method="post" class="admin-form">
                                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                <input type="hidden" name="userId" value="${user.id}">
                                                <button type="submit" class="btn btn-success" onclick="return confirm('确认解封该用户？')">解封</button>
                                            </form>
                                        </c:if>
                                    </c:if>
                                    <c:if test="${user.role == 'admin'}">
                                        <span class="text-muted">管理员账号不可操作</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" class="empty-state">
                                暂无用户数据
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
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
</script>
</body>
</html>