<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="zh-CN">
<head>
  <title>个人中心 | 商品交易平台</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    :root {
      /* 全站统一配色系统 */
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

      /* 尺寸系统 */
      --radius-sm: 6px;
      --radius-md: 8px;
      --radius-lg: 12px;
      --radius-full: 9999px;
      --shadow-sm: 0 1px 3px rgba(0,0,0,0.05);
      --shadow-md: 0 4px 6px rgba(0,0,0,0.08);
      --shadow-lg: 0 10px 15px rgba(0,0,0,0.1);
      --transition: all 0.2s ease-in-out;
    }

    /* 全局样式重置与基础设置 */
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
      border-radius: var(--radius-full);
      font-size: 0.7rem;
      font-weight: 500;
    }

    /* 容器样式 */
    .container {
      max-width: 1000px;
      margin: 2.5rem auto;
      background: white;
      padding: 2rem;
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-sm);
    }

    /* 通用按钮样式 */
    .btn {
      display: inline-block;
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
      text-align: center;
    }

    .btn:hover {
      background-color: var(--primary-light);
      transform: translateY(-1px);
    }

    .btn:active {
      transform: translateY(0);
    }

    .btn-primary {
      background-color: var(--primary);
    }

    .btn-success {
      background-color: var(--success);
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
      background-color: transparent;
      border: 1px solid var(--primary);
      color: var(--primary);
    }

    .btn-outline:hover {
      background-color: rgba(128, 90, 213, 0.1);
    }

    /* 小按钮样式 */
    .btn-sm {
      padding: 0.4rem 0.8rem;
      font-size: 0.85rem;
      border-radius: var(--radius-sm);
    }

    /* 笔形编辑按钮样式 */
    .edit-pen-btn {
      width: 28px;
      height: 28px;
      padding: 0;
      border-radius: var(--radius-full);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      line-height: 1;
      background-color: var(--gray-100);
      color: var(--gray-600);
      border: none;
      cursor: pointer;
      transition: var(--transition);
    }

    .edit-pen-btn:hover {
      background-color: var(--primary);
      color: white;
      transform: scale(1.05);
    }

    /* 链接样式 */
    a {
      color: var(--primary);
      text-decoration: none;
      transition: var(--transition);
    }

    a:hover {
      color: var(--primary-light);
    }

    .back-link {
      display: inline-flex;
      align-items: center;
      gap: 0.5rem;
      margin-bottom: 1.5rem;
      font-size: 0.9rem;
      color: var(--gray-700);
    }

    .back-link:hover {
      color: var(--primary);
      text-decoration: underline;
    }

    /* 标题样式 */
    h2 {
      font-size: 1.75rem;
      font-weight: 700;
      margin-bottom: 1.75rem;
      color: var(--gray-900);
      border-bottom: 1px solid var(--gray-200);
      padding-bottom: 0.75rem;
      letter-spacing: -0.02em;
    }

    h3 {
      font-size: 1.25rem;
      font-weight: 600;
      margin-bottom: 1rem;
      color: var(--gray-800);
      display: flex;
      align-items: center;
      gap: 0.5rem;
    }

    h3::before {
      content: '';
      display: inline-block;
      width: 4px;
      height: 16px;
      background-color: var(--primary);
      border-radius: var(--radius-sm);
    }

    /* 用户信息卡片 */
    .user-info {
      display: flex;
      align-items: center;
      margin-bottom: 2rem;
      padding: 1.5rem;
      background: linear-gradient(135deg, #fdf2f8 0%, #fef7fb 100%);
      border-radius: var(--radius-lg);
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--gray-100);
    }

    .avatar {
      width: 90px;
      height: 90px;
      background: var(--primary);
      border-radius: var(--radius-full);
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2.5rem;
      font-weight: 600;
      margin-right: 1.5rem;
      box-shadow: var(--shadow-md);
    }

    .user-details {
      flex: 1;
    }

    .nickname-container {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 0.5rem;
    }

    .nickname-display {
      font-size: 1.375rem;
      font-weight: 600;
      color: var(--gray-900);
    }

    .nickname-edit-form {
      display: none;
      align-items: center;
      gap: 8px;
    }

    .nickname-edit-input {
      padding: 0.5rem 0.75rem;
      border: 1px solid var(--gray-200);
      border-radius: var(--radius-sm);
      font-size: 1rem;
      width: 220px;
      transition: var(--transition);
      background-color: var(--gray-50);
    }

    .nickname-edit-input:focus {
      outline: none;
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(128, 90, 213, 0.1);
    }

    .edit-form-actions {
      display: flex;
      gap: 8px;
    }

    .form-btn {
      padding: 0.375rem 0.75rem;
      font-size: 0.85rem;
    }

    .user-details p {
      margin-bottom: 0.375rem;
      color: var(--gray-700);
      font-size: 0.95rem;
    }

    .credit-score {
      background: var(--success);
      color: white;
      padding: 0.25rem 0.75rem;
      border-radius: var(--radius-full);
      font-weight: 600;
      font-size: 0.85rem;
      display: inline-block;
      margin-left: 8px;
    }

    .star-rating {
      color: var(--warning);
      font-size: 1.2rem;
      margin: 0 8px;
    }

    /* 余额卡片 */
    .balance-card {
      background: linear-gradient(135deg, #e8f4f8 0%, #f0f8fb 100%);
      border-radius: var(--radius-lg);
      padding: 1.5rem;
      margin-bottom: 2rem;
      box-shadow: var(--shadow-sm);
      border: 1px solid var(--gray-100);
    }

    .balance-amount {
      font-size: 2rem;
      font-weight: 700;
      color: var(--success);
      margin: 0.75rem 0;
      letter-spacing: -0.02em;
    }

    /* 分区样式 */
    .section {
      margin: 2rem 0;
      padding: 1.5rem;
      border: 1px solid var(--gray-200);
      border-radius: var(--radius-lg);
      background: white;
      box-shadow: var(--shadow-sm);
    }

    /* 评价列表 */
    .review-item {
      border-bottom: 1px solid var(--gray-100);
      padding: 1.25rem 0;
    }

    .review-item:last-child {
      border-bottom: none;
    }

    .review-item strong {
      font-size: 0.95rem;
      color: var(--gray-800);
    }

    .review-item p {
      margin: 0.5rem 0;
      color: var(--gray-700);
      line-height: 1.6;
    }

    .review-item small {
      color: var(--gray-600);
      font-size: 0.85rem;
    }

    /* 商品表格 */
    table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      margin-top: 1rem;
      border-radius: var(--radius-md);
      overflow: hidden;
      box-shadow: var(--shadow-sm);
    }

    th, td {
      padding: 0.875rem 1rem;
      text-align: left;
      border-bottom: 1px solid var(--gray-200);
    }

    th {
      background-color: var(--gray-50);
      font-weight: 600;
      color: var(--gray-800);
      font-size: 0.9rem;
    }

    tr:hover {
      background-color: var(--gray-50);
    }

    /* 空状态样式 */
    .empty-state {
      padding: 2.5rem 0;
      text-align: center;
      color: var(--gray-600);
    }

    .empty-state p {
      margin-bottom: 1.25rem;
      font-size: 0.95rem;
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
        margin: 1.25rem auto;
      }

      .user-info {
        flex-direction: column;
        text-align: center;
      }

      .avatar {
        margin-right: 0;
        margin-bottom: 1rem;
      }

      .nickname-container {
        justify-content: center;
      }

      .nickname-edit-input {
        width: 180px;
      }

      table {
        display: block;
        overflow-x: auto;
      }

      .balance-amount {
        font-size: 1.5rem;
      }
    }

    @media (max-width: 480px) {
      .container {
        margin: 1rem;
      }

      h2 {
        font-size: 1.5rem;
      }

      .section {
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
            <li><a href="${pageContext.request.contextPath}/order/my" class="nav-link">我的订单</a></li>
            <li><a href="/user/center" class="nav-link active">个人中心</a></li>
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

<!-- 个人中心主内容区 -->
<div class="container">
  <h2>个人中心</h2>

  <a href="/product/list" class="back-link">
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M19 12H5M12 19l-7-7 7-7"/>
    </svg>
    返回首页
  </a>

  <!-- 用户信息 -->
  <div class="user-info">
    <div class="avatar">${user.nickname.charAt(0)}</div>
    <div class="user-details">
      <!-- 昵称展示与编辑区域 -->
      <div class="nickname-container">
        <span class="nickname-display" id="nicknameDisplay">${user.nickname}</span>
        <!-- 笔形编辑按钮 -->
        <button class="edit-pen-btn" id="editNicknameBtn" title="修改昵称">
          ✏️
        </button>
        <!-- 昵称编辑表单 -->
        <form action="/user/updateNickname" method="post" class="nickname-edit-form" id="nicknameEditForm">
          <input type="text" name="nickname" value="${user.nickname}" required
                 class="nickname-edit-input" placeholder="请输入新昵称">
          <div class="edit-form-actions">
            <button type="submit" class="btn btn-primary form-btn btn-sm">保存</button>
            <button type="button" class="btn btn-outline form-btn btn-sm" id="cancelEditBtn">取消</button>
          </div>
        </form>
      </div>

      <p>手机号: ${user.phone}</p>
      <p>信誉分: <span class="credit-score">${user.creditScore}分</span></p>
      <p>平均评分:
        <span class="star-rating">
          <c:forEach begin="1" end="5" var="i">
            <c:choose>
              <c:when test="${i <= avgRating}">★</c:when>
              <c:otherwise>☆</c:otherwise>
            </c:choose>
          </c:forEach>
        </span>
        ${avgRating}分 (${reviewCount}条评价)
      </p>
    </div>
  </div>

  <!-- 余额显示卡片 -->
  <div class="balance-card">
    <h3>账户余额</h3>
    <div class="balance-amount">¥${user.balance}</div>
    <p>可用余额</p>

    <!-- 充值入口 -->
    <div style="margin-top: 1rem;">
      <a href="/user/recharge" class="btn btn-success">
        <span>💰</span> 立即充值
      </a>
    </div>
  </div>

  <!-- 收到的评价 -->
  <div class="section">
    <h3>收到的评价 (${reviewCount}条)</h3>
    <c:if test="${empty reviews}">
      <div class="empty-state">
        <p>暂无评价，快去获得更多好评吧！</p>
      </div>
    </c:if>
    <c:forEach items="${reviews}" var="review">
      <div class="review-item">
        <strong>${review.reviewerName}</strong>
        <span class="star-rating">
          <c:forEach begin="1" end="5" var="i">
            <c:choose>
              <c:when test="${i <= review.rating}">★</c:when>
              <c:otherwise>☆</c:otherwise>
            </c:choose>
          </c:forEach>
        </span>
        <span>${review.rating}分</span>
        <p>${review.content}</p>
        <small>${review.createTime}</small>
      </div>
    </c:forEach>
  </div>

  <!-- 我的商品 -->
  <div class="section">
    <h3>我的商品</h3>
    <c:if test="${empty products}">
      <div class="empty-state">
        <p>您还没有发布任何商品</p>
        <a href="${pageContext.request.contextPath}/product/add" class="btn btn-primary">发布商品</a>
      </div>
    </c:if>

    <c:if test="${not empty products}">
      <table>
        <tr>
          <th>商品名称</th>
          <th>售价</th>
          <th>租赁价</th>
          <th>库存</th>
          <th>状态</th>
          <th>发布时间</th>
          <th>操作</th>
        </tr>
        <c:forEach items="${products}" var="product">
          <tr>
            <td>${product.name}</td>
            <td>¥${product.price}</td>
            <td>
              <c:if test="${product.rentPrice != null}">
                ¥${product.rentPrice}/天
              </c:if>
              <c:if test="${product.rentPrice == null}">
                -
              </c:if>
            </td>
            <td>${product.stock}</td>
            <td>
              <c:choose>
                <c:when test="${product.status == 1}"><span style="color: var(--success)">可租</span></c:when>
                <c:when test="${product.status == 2}"><span style="color: var(--warning)">已租</span></c:when>
                <c:when test="${product.status == 3}"><span style="color: var(--primary)">下架</span></c:when>
                <c:when test="${product.status == 0}"><span style="color: var(--danger)">待审核</span></c:when>
                <c:otherwise><span style="color: var(--gray-600)">已删除</span></c:otherwise>
              </c:choose>
            </td>
            <td>${product.createTime}</td>
            <td>
              <a href="${pageContext.request.contextPath}/product/edit/${product.id}" class="btn btn-warning btn-sm">编辑</a>
              <a href="${pageContext.request.contextPath}/product/delete/${product.id}"
                 onclick="return confirm('确定删除吗？删除后将无法恢复！')"
                 class="btn btn-danger btn-sm">删除</a>
            </td>
          </tr>
        </c:forEach>
      </table>
    </c:if>
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

  // 昵称编辑交互逻辑（保留原有功能）
  const nicknameDisplay = document.getElementById('nicknameDisplay');
  const editNicknameBtn = document.getElementById('editNicknameBtn');
  const nicknameEditForm = document.getElementById('nicknameEditForm');
  const cancelEditBtn = document.getElementById('cancelEditBtn');

  // 编辑昵称按钮点击事件
  editNicknameBtn.addEventListener('click', function() {
    nicknameDisplay.style.display = 'none';
    editNicknameBtn.style.display = 'none';
    nicknameEditForm.style.display = 'flex';
    // 聚焦输入框
    const inputEl = nicknameEditForm.querySelector('input');
    inputEl.focus();
    // 选中现有内容（方便直接替换）
    inputEl.select();
  });

  // 取消编辑按钮点击事件
  cancelEditBtn.addEventListener('click', function() {
    nicknameDisplay.style.display = 'inline';
    editNicknameBtn.style.display = 'flex';
    nicknameEditForm.style.display = 'none';
    // 恢复输入框原值
    nicknameEditForm.querySelector('input').value = nicknameDisplay.textContent;
  });
</script>
</body>
</html>