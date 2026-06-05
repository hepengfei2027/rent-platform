<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>商品审核管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
    <style>
        :root {
            --primary: #805ad5;
            --primary-light: #9f7aea;
            --success: #38b2ac;
            --warning: #ed8936;
            --danger: #e53e3e;
            --gray-50: #fafafa;
            --gray-100: #f7fafc;
            --gray-200: #edf2f7;
            --gray-300: #e2e8f0;
            --gray-600: #718096;
            --gray-700: #4a5568;
            --gray-800: #2d3748;
            --gray-900: #1a202c;
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
            display: none;
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
    </style>
</head>
<body>

<!-- 导航栏 -->
<nav class="navbar" id="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="nav-brand">校园资源共享租赁平台</a>
        <div class="nav-core">
            <ul class="nav-menu">
                <li><a href="${pageContext.request.contextPath}/product/list" class="nav-link">商品列表</a></li>
                <li><a href="/admin/dashboard" class="nav-link">管理员后台</a></li>
                <li><a href="/admin/product/pending" class="nav-link active">商品审核</a></li>
                <c:if test="${not empty sessionScope.currentUser}">
                    <c:if test="${sessionScope.currentUser.role != 'admin'}">
                        <li><a href="${pageContext.request.contextPath}/order/my" class="nav-link">我的订单</a></li>
                        <li><a href="/user/center" class="nav-link">个人中心</a></li>
                    </c:if>
                </c:if>
                <c:if test="${empty sessionScope.currentUser}">
                    <li><a href="${pageContext.request.contextPath}/user/auth" class="nav-link">登录/注册</a></li>
                </c:if>
            </ul>
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

<!-- 内容区 -->
<div class="container mt-5">
    <h1 class="mb-4">待审核商品列表</h1>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success" role="alert">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger" role="alert">${errorMessage}</div>
    </c:if>
    <div class="table-responsive">
        <table class="table table-striped table-hover">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>商品名称</th>
                <th>价格</th>
                <th>租赁价格/天</th>
                <th>库存</th>
                <th>所有者</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="product" items="${pendingProducts}">
                <tr>
                    <td>${product.id}</td>
                    <td>${product.name}</td>
                    <td>${product.price}</td>
                    <td>${product.rentPrice}</td>
                    <td>${product.stock}</td>
                    <td>${product.ownerName}</td>
                    <td>
                        <form action="${pageContext.request.contextPath}/admin/product/review/${product.id}" method="post" class="d-inline">
                            <input type="hidden" name="status" value="1"/>
                            <button type="submit" class="btn btn-success btn-sm">通过</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/admin/product/review/${product.id}" method="post" class="d-inline">
                            <input type="hidden" name="status" value="3"/>
                            <button type="submit" class="btn btn-danger btn-sm">拒绝</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty pendingProducts}">
                <tr>
                    <td colspan="7" class="text-center">暂无待审核商品</td>
                </tr>
            </c:if>
            </tbody>
        </table>
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