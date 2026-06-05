<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="zh-CN">
<head>
    <title>编辑商品 | 商品交易平台</title>
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
            max-width: 600px;
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
            margin-bottom: 1rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--primary);
            letter-spacing: -0.02em;
        }

        /* 返回链接样式 */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            color: var(--primary);
            text-decoration: none;
            font-size: 0.9rem;
            transition: var(--transition);
        }

        .back-link:hover {
            color: var(--primary-light);
            text-decoration: underline;
        }

        /* 表单样式 */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--gray-700);
            font-size: 0.95rem;
        }

        .form-required {
            color: var(--danger);
            margin-left: 0.25rem;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius-md);
            font-size: 0.9rem;
            font-family: inherit;
            transition: var(--transition);
            background-color: var(--gray-50);
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(128, 90, 213, 0.1);
        }

        .form-text {
            display: block;
            margin-top: 0.25rem;
            font-size: 0.85rem;
            color: var(--gray-600);
        }

        textarea.form-control {
            min-height: 120px;
            resize: vertical;
            line-height: 1.5;
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

        .btn-secondary {
            background-color: var(--gray-600);
            color: white;
        }

        .btn-secondary:hover {
            background-color: var(--gray-700);
        }

        .btn-group {
            display: flex;
            gap: 0.75rem;
            margin-top: 1.5rem;
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

            .btn-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                margin-right: 0;
            }
        }

        @media (max-width: 480px) {
            .page-title {
                font-size: 1.5rem;
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
                <li><a href="${pageContext.request.contextPath}/product/list" class="nav-link active">商品列表</a></li>

                <c:if test="${sessionScope.currentUser.role == 'admin'}">
                    <li><a href="/admin/dashboard" class="nav-link">管理员后台</a></li>
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

<!-- 编辑商品主内容区 -->
<div class="container">
    <h2 class="page-title">编辑商品</h2>
    <a href="/product/list" class="back-link">
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M19 12H5M12 19l-7-7 7-7"/>
        </svg>
        返回列表
    </a>

    <form action="/product/update" method="post">
        <input type="hidden" name="id" value="${product.id}" required>

        <div class="form-group">
            <label class="form-label">
                商品名称 <span class="form-required">*</span>
            </label>
            <input type="text" name="name" value="${product.name}" required
                   maxlength="100" placeholder="请输入商品名称" class="form-control">
        </div>

        <div class="form-group">
            <label class="form-label">
                分类 <span class="form-required">*</span>
            </label>
            <select name="category" required class="form-control">
                <option value="书籍" ${product.category == '书籍' ? 'selected' : ''}>书籍</option>
                <option value="数码" ${product.category == '数码' ? 'selected' : ''}>数码</option>
                <option value="体育器材" ${product.category == '体育器材' ? 'selected' : ''}>体育器材</option>
                <option value="其他" ${product.category == '其他' ? 'selected' : ''}>其他</option>
            </select>
        </div>

        <div class="form-group">
            <label class="form-label">
                价格 (元) <span class="form-required">*</span>
            </label>
            <input type="number" name="price" step="0.01" min="0"
                   value="${product.price}" required placeholder="请输入销售价格" class="form-control">
        </div>

        <div class="form-group">
            <label class="form-label">
                租赁价格 (元/天)
            </label>
            <input type="number" name="rentPrice" step="0.01" min="0"
                   value="${product.rentPrice}" placeholder="不租赁可留空" class="form-control">
            <span class="form-text">填写租赁价格时建议设置合理的押金金额</span>
        </div>

        <div class="form-group">
            <label class="form-label">
                押金金额 (元)
            </label>
            <input type="number" name="deposit" step="0.01" min="0"
                   value="${product.deposit}" class="form-control">
        </div>

        <div class="form-group">
            <label class="form-label">
                库存 <span class="form-required">*</span>
            </label>
            <input type="number" name="stock" min="0" value="${product.stock}"
                   required placeholder="请输入库存数量" class="form-control">
        </div>

        <div class="form-group">
            <label class="form-label">
                状态 <span class="form-required">*</span>
            </label>
            <select name="status" required class="form-control">
                <option value="1" ${product.status == 1 ? 'selected' : ''}>可租</option>
                <option value="2" ${product.status == 2 ? 'selected' : ''}>已租</option>
                <option value="3" ${product.status == 3 ? 'selected' : ''}>下架</option>
            </select>
        </div>

        <div class="form-group">
            <label class="form-label">
                描述
            </label>
            <textarea name="description" maxlength="500"
                      placeholder="请输入商品详细描述" class="form-control">${product.description}</textarea>
        </div>

        <div class="btn-group">
            <button type="submit" class="btn btn-success">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path>
                    <polyline points="17 21 17 13 7 13 7 21"></polyline>
                    <polyline points="7 3 7 8 15 8"></polyline>
                </svg>
                保存修改
            </button>
            <a href="/product/list" class="btn btn-secondary">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M19 12H5M12 19l-7-7 7-7"/>
                </svg>
                取消
            </a>
        </div>
    </form>
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