<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="zh-CN">
<head>
  <title>我的订单 | 商品交易平台</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    :root {
      /* 极简高级配色系统 */
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

      /* 尺寸系统 */
      --radius-sm: 6px;
      --radius-md: 8px;
      --radius-lg: 12px;
      --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
      --shadow-md: 0 4px 6px rgba(0,0,0,0.08);

      /* 过渡动画 */
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

    /* 按钮样式 */
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

    /* 页面头部样式 */
    .page-header {
      margin-bottom: 2rem;
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

    /* 返回链接样式 */
    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      color: var(--secondary);
      text-decoration: none;
      font-weight: 500;
      margin-bottom: 1rem;
      transition: var(--transition);
    }

    .back-link:hover {
      color: var(--secondary-light);
      text-decoration: underline;
    }

    /* 提示信息样式 */
    .success-message {
      background-color: rgba(56, 178, 172, 0.1);
      color: var(--success);
      padding: 1rem 1.25rem;
      border-radius: var(--radius-md);
      margin: 1rem 0 2rem 0;
      border-left: 3px solid var(--success);
      font-weight: 500;
    }

    /* 订单表格样式 */
    .orders-table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      background-color: white;
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-sm);
      overflow: hidden;
    }

    .orders-table th {
      background-color: var(--gray-50);
      color: var(--gray-900);
      font-weight: 800;
      padding: 1rem 1.25rem;
      text-align: left;
      border-top: 3px solid var(--secondary); /* 表头上方紫色粗线 */
      border-bottom: 3px solid var(--secondary); /* 紫色粗线 */
    }

    .orders-table td {
      padding: 1rem 1.25rem;
      border-bottom: 1px solid var(--gray-100);
      color: var(--gray-800);
    }

    .orders-table tr:last-child td {
      border-bottom: none;
    }

    .orders-table tr:hover td {
      background-color: var(--gray-50);
    }

    /* 操作链接样式 */
    .action-link {
      color: var(--secondary);
      text-decoration: none;
      font-weight: 500;
      transition: var(--transition);
    }

    .action-link:hover {
      color: var(--secondary-light);
      text-decoration: underline;
    }

    /* 空状态样式 */
    .empty-state {
      text-align: center;
      padding: 5rem 2rem;
      background-color: white;
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-sm);
      margin: 2rem 0;
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

      /* 移动端表格适配 */
      .orders-table {
        display: block;
        overflow-x: auto;
      }

      .page-title {
        font-size: 1.75rem;
      }
    }

    @media (max-width: 480px) {
      .container {
        padding: 0 1rem;
      }

      .empty-state {
        padding: 3rem 1rem;
      }
    }
  </style>
</head>
<body>
<!-- 导航栏 - 与主页保持一致 -->
<nav class="navbar" id="navbar">
  <div class="nav-container">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">校园资源共享租赁平台</a>

    <div class="nav-core">
      <ul class="nav-menu">
        <li><a href="${pageContext.request.contextPath}/product/list" class="nav-link">商品列表</a></li>

        <c:if test="${sessionScope.currentUser.role == 'admin'}">
          <li><a href="/admin/dashboard" class="nav-link btn-primary">管理员后台</a></li>
        </c:if>

        <c:if test="${not empty sessionScope.currentUser}">
            <li><a href="${pageContext.request.contextPath}/order/my" class="nav-link active">我的订单</a></li>
            <li><a href="/user/center" class="nav-link">个人中心</a></li>
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

<!-- 主内容区 -->
<main class="container">

  <!-- 成功提示信息 -->
  <c:if test="${not empty success}">
    <div class="success-message">${success}</div>
  </c:if>

  <!-- 空订单状态 -->
  <c:if test="${empty orders}">
    <div class="empty-state">
      <div class="empty-state-icon">📦</div>
      <p class="empty-state-text">暂无订单记录，快去挑选心仪的商品吧！</p>
      <a href="/product/list" class="btn btn-primary">
        <span>🛒</span> 去购物
      </a>
    </div>
  </c:if>

  <!-- 订单表格 -->
  <c:if test="${not empty orders}">
    <table class="orders-table">
      <thead>
      <tr>
        <th>订单号</th>
        <th>商品名称</th>
        <th>金额</th>
        <th>时间</th>
        <th>操作</th>
      </tr>
      </thead>
      <tbody>
      <c:forEach items="${orders}" var="order">
        <tr>
          <td>${order.orderNo}</td>
          <td>${order.productName}</td>
          <td>¥${order.amount}</td>
          <td>${order.createTime}</td>
          <td>
            <a href="/order/detail/${order.id}" class="action-link">查看详情</a>
          </td>
        </tr>
      </c:forEach>
      </tbody>
    </table>
  </c:if>
</main>

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