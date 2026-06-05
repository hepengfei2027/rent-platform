<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="zh-CN">
<head>
  <title>订单详情 | 商品交易平台</title>
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
      max-width: 800px;
      margin: 2.5rem auto;
      background: white;
      padding: 2rem;
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-sm);
    }

    /* 页面标题样式 */
    .page-title {
      font-size: 1.75rem;
      font-weight: 700;
      color: var(--gray-900);
      margin-bottom: 1.5rem;
      padding-bottom: 0.75rem;
      border-bottom: 2px solid var(--primary);
      letter-spacing: -0.02em;
    }

    /* 订单信息卡片 */
    .order-card {
      background-color: var(--gray-50);
      border-radius: var(--radius-lg);
      padding: 1.5rem;
      margin-bottom: 2rem;
      border: 1px solid var(--gray-200);
    }

    .info-row {
      display: flex;
      align-items: center;
      margin: 1rem 0;
      padding-bottom: 1rem;
      border-bottom: 1px solid var(--gray-200);
    }

    .info-row:last-child {
      border-bottom: none;
      margin-bottom: 0;
      padding-bottom: 0;
    }

    .info-label {
      width: 120px;
      font-weight: 600;
      color: var(--gray-700);
      font-size: 0.95rem;
    }

    .info-value {
      flex: 1;
      color: var(--gray-800);
      font-size: 0.95rem;
    }

    .order-no {
      font-weight: 700;
      color: var(--primary);
      font-size: 1rem;
    }

    .amount {
      color: var(--danger);
      font-weight: 700;
      font-size: 1.1rem;
    }

    /* 状态标签样式 */
    .status-tag {
      display: inline-flex;
      align-items: center;
      padding: 0.25rem 0.75rem;
      border-radius: 999px;
      font-weight: 500;
      font-size: 0.85rem;
    }

    .status-pending {
      background-color: rgba(237, 137, 54, 0.1);
      color: var(--warning);
      border: 1px solid rgba(237, 137, 54, 0.2);
    }

    .status-paid {
      background-color: rgba(66, 153, 225, 0.1);
      color: var(--info);
      border: 1px solid rgba(66, 153, 225, 0.2);
    }

    .status-completed {
      background-color: rgba(56, 178, 172, 0.1);
      color: var(--success);
      border: 1px solid rgba(56, 178, 172, 0.2);
    }

    .status-canceled {
      background-color: rgba(229, 62, 62, 0.1);
      color: var(--danger);
      border: 1px solid rgba(229, 62, 62, 0.2);
    }

    /* 按钮样式 */
    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 0.5rem;
      padding: 0.65rem 1.25rem;
      background-color: var(--primary);
      color: white;
      text-decoration: none;
      border-radius: var(--radius-md);
      border: none;
      cursor: pointer;
      font-size: 0.9rem;
      font-weight: 500;
      transition: var(--transition);
      margin-right: 0.75rem;
    }

    .btn:hover {
      background-color: var(--primary-light);
      transform: translateY(-1px);
    }

    .btn:active {
      transform: translateY(0);
    }

    .btn-success {
      background-color: var(--success);
    }

    .btn-success:hover {
      background-color: #319795;
    }

    /* 空状态样式 */
    .empty-state {
      text-align: center;
      padding: 4rem 2rem;
      color: var(--gray-600);
    }

    .empty-state h3 {
      font-size: 1.25rem;
      color: var(--gray-800);
      margin-bottom: 0.75rem;
    }

    .empty-state p {
      font-size: 0.95rem;
      margin-bottom: 1.5rem;
    }

    /* 评价区域样式 */
    .review-section {
      margin-top: 2rem;
      padding-top: 1.5rem;
      border-top: 1px solid var(--gray-200);
    }

    .review-section h3 {
      font-size: 1.25rem;
      font-weight: 600;
      color: var(--gray-800);
      margin-bottom: 1rem;
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    .review-section h3::before {
      content: '';
      display: inline-block;
      width: 4px;
      height: 16px;
      background-color: var(--primary);
      border-radius: var(--radius-sm);
    }

    .form-group {
      margin-bottom: 1rem;
    }

    .form-label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: 500;
      color: var(--gray-700);
    }

    .form-select,
    .form-textarea {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid var(--gray-300);
      border-radius: var(--radius-md);
      font-size: 0.9rem;
      font-family: inherit;
      transition: var(--transition);
      background-color: var(--gray-50);
    }

    .form-select:focus,
    .form-textarea:focus {
      outline: none;
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(128, 90, 213, 0.1);
    }

    .form-textarea {
      min-height: 120px;
      resize: vertical;
      line-height: 1.5;
    }

    .submit-btn {
      background-color: var(--primary);
      color: white;
      border: none;
      padding: 0.75rem 1.5rem;
      border-radius: var(--radius-md);
      font-weight: 500;
      cursor: pointer;
      transition: var(--transition);
    }

    .submit-btn:hover {
      background-color: var(--primary-light);
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

      .container {
        padding: 1.25rem;
        margin: 1.25rem;
      }

      .info-row {
        flex-direction: column;
        align-items: flex-start;
      }

      .info-label {
        width: 100%;
        margin-bottom: 0.25rem;
      }

      .btn {
        display: block;
        width: 100%;
        margin-right: 0;
        margin-bottom: 0.75rem;
      }
    }

    @media (max-width: 480px) {
      .page-title {
        font-size: 1.5rem;
      }

      .order-card {
        padding: 1rem;
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

        <c:if test="${sessionScope.currentUser.role == 'admin'}">
          <li><a href="/admin/dashboard" class="nav-link">管理员后台</a></li>
        </c:if>

        <c:if test="${not empty sessionScope.currentUser}">
          <!-- 仅非管理员显示 -->
          <c:if test="${sessionScope.currentUser.role != 'admin'}">
            <li><a href="${pageContext.request.contextPath}/order/my" class="nav-link active">我的订单</a></li>
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

<!-- 订单详情主内容区 -->
<div class="container">
  <h2 class="page-title">订单详情</h2>

  <c:if test="${not empty order}">
    <div class="order-card">
      <div class="info-row">
        <span class="info-label">订单号：</span>
        <span class="info-value order-no">${order.orderNo}</span>
      </div>
      <div class="info-row">
        <span class="info-label">商品名称：</span>
        <span class="info-value">${order.productName}</span>
      </div>
      <div class="info-row">
        <span class="info-label">订单类型：</span>
        <span class="info-value">
                    <c:choose>
                      <c:when test="${order.orderType == 1}">购买</c:when>
                      <c:when test="${order.orderType == 2}">租赁</c:when>
                      <c:otherwise>其他</c:otherwise>
                    </c:choose>
                </span>
      </div>
      <div class="info-row">
        <span class="info-label">订单金额：</span>
        <span class="info-value amount">¥${order.amount}</span>
      </div>
      <div class="info-row">
        <span class="info-label">买家：</span>
        <span class="info-value">${order.buyerName}</span>
      </div>
      <div class="info-row">
        <span class="info-label">卖家：</span>
        <span class="info-value">${order.sellerName}</span>
      </div>
      <div class="info-row">
        <span class="info-label">订单状态：</span>
        <span class="info-value">
                    <c:choose>
                      <c:when test="${order.status == 1}">
                        <span class="status-tag status-pending">待支付</span>
                      </c:when>
                      <c:when test="${order.status == 2}">
                        <span class="status-tag status-paid">已支付</span>
                      </c:when>
                      <c:when test="${order.status == 3}">
                        <span class="status-tag status-completed">已完成</span>
                      </c:when>
                      <c:when test="${order.status == 4}">
                        <span class="status-tag status-canceled">已取消</span>
                      </c:when>
                      <c:otherwise>未知状态</c:otherwise>
                    </c:choose>
                </span>
      </div>
      <div class="info-row">
        <span class="info-label">下单时间：</span>
        <span class="info-value">${order.createTime}</span>
      </div>
      <c:if test="${order.orderType == 2}">
        <div class="info-row">
          <span class="info-label">租赁天数：</span>
          <span class="info-value">${order.rentDays}天</span>
        </div>
        <div class="info-row">
          <span class="info-label">租赁开始：</span>
          <span class="info-value">${order.rentStartTime}</span>
        </div>
        <div class="info-row">
          <span class="info-label">租赁结束：</span>
          <span class="info-value">${order.rentEndTime}</span>
        </div>
      </c:if>
    </div>
  </c:if>

  <c:if test="${empty order}">
    <div class="empty-state">
      <h3>订单不存在</h3>
      <p>您要查看的订单不存在或已被删除</p>
      <a href="${pageContext.request.contextPath}/order/my" class="btn">返回订单列表</a>
    </div>
  </c:if>

  <div style="margin-top: 2rem;">
    <a href="${pageContext.request.contextPath}/order/my" class="btn">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M19 12H5M12 19l-7-7 7-7"/>
      </svg>
      返回订单列表
    </a>
    <a href="${pageContext.request.contextPath}/product/list" class="btn btn-success">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="11" cy="11" r="8"></circle>
        <path d="m21 21-4.35-4.35"></path>
      </svg>
      继续购物
    </a>
  </div>

  <!-- 评价区域 -->
  <c:if test="${order.status == 3}"> <!-- 已完成订单可评价 -->
    <div class="review-section">
      <h3>评价此交易</h3>
      <form action="/user/review" method="post">
        <input type="hidden" name="orderId" value="${order.id}">

        <c:if test="${currentUser.id == order.buyerId}">
          <!-- 买家评价卖家 -->
          <input type="hidden" name="targetUserId" value="${order.sellerId}">
          <input type="hidden" name="targetUserName" value="${order.sellerName}">
          <input type="hidden" name="type" value="1">
          <p style="margin-bottom: 1rem; color: var(--gray-700);">评价卖家: <strong>${order.sellerName}</strong></p>
        </c:if>

        <c:if test="${currentUser.id == order.sellerId}">
          <!-- 卖家评价买家 -->
          <input type="hidden" name="targetUserId" value="${order.buyerId}">
          <input type="hidden" name="targetUserName" value="${order.buyerName}">
          <input type="hidden" name="type" value="2">
          <p style="margin-bottom: 1rem; color: var(--gray-700);">评价买家: <strong>${order.buyerName}</strong></p>
        </c:if>

        <div class="form-group">
          <label class="form-label" for="rating">评分:</label>
          <select name="rating" id="rating" class="form-select" required>
            <option value="5">5星 - 非常好</option>
            <option value="4">4星 - 很好</option>
            <option value="3">3星 - 一般</option>
            <option value="2">2星 - 较差</option>
            <option value="1">1星 - 很差</option>
          </select>
        </div>

        <div class="form-group">
          <label class="form-label" for="content">评价内容:</label>
          <textarea name="content" id="content" rows="3" placeholder="请输入评价内容..." class="form-textarea" required></textarea>
        </div>

        <button type="submit" class="submit-btn">提交评价</button>
      </form>
    </div>
  </c:if>
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