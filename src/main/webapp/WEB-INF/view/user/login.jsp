<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>校园资源共享租赁平台</title>
    <style>
        /* 全局样式重置和基础设置 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', Arial, sans-serif;
        }

        html, body {
            height: 100%;
            overflow: hidden;
        }

        body {
            display: flex;
            background-color: #f8f9fa;
        }

        /* 主容器 - 填满整个屏幕，无边框 */
        .main-container {
            display: flex;
            width: 100vw;
            height: 100vh;
        }

        /* 左侧介绍区域 (3/4) - 保持不变 */
        .intro-section {
            flex: 3;
            background: linear-gradient(135deg, #7b2cbf 0%, #5a189a 100%);
            color: white;
            padding: 4rem 5rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            height: 100%;
        }

        .intro-logo {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 2.5rem;
            display: flex;
            align-items: center;
            gap: 1.2rem;
        }

        .intro-logo i {
            font-size: 3.5rem;
        }

        .intro-title {
            font-size: 2.8rem;
            font-weight: 600;
            margin-bottom: 2rem;
            line-height: 1.3;
        }

        .intro-desc {
            font-size: 1.2rem;
            line-height: 1.8;
            margin-bottom: 2.5rem;
            opacity: 0.9;
            max-width: 80%;
        }

        .intro-features {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
            margin-top: 2.5rem;
        }

        .feature-item {
            display: flex;
            align-items: flex-start;
            gap: 1.2rem;
            font-size: 1.1rem;
        }

        .feature-item i {
            font-size: 1.4rem;
            margin-top: 0.2rem;
            color: #e0aaff;
        }

        /* 右侧登录区域 (1/4) - 高级感设计 */
        .auth-section {
            flex: 1;
            background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
            padding: 5rem 4rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            height: 100%;
            position: relative;
            overflow: hidden;
        }

        /* 高级感装饰元素 */
        .auth-section::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(37, 99, 235, 0.03) 0%, rgba(123, 44, 191, 0.01) 100%);
            border-radius: 50%;
            z-index: 0;
        }

        /* 登录卡片容器 */
        .auth-card {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 400px;
            margin: 0 auto;
        }

        /* 高级感标题 */
        .auth-header {
            text-align: center;
            margin-bottom: 3rem;
        }

        .auth-header h2 {
            font-size: 2.2rem;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 0.8rem;
            letter-spacing: -0.5px;
        }

        .auth-header p {
            color: #64748b;
            font-size: 1rem;
            line-height: 1.6;
        }

        /* 标签切换样式 - 高级感设计 */
        .tabs {
            display: flex;
            margin-bottom: 2.5rem;
            position: relative;
            justify-content: center;
            background: #f1f5f9;
            border-radius: 50px;
            padding: 4px;
        }

        .tab {
            flex: 1;
            padding: 1rem 1.5rem;
            text-align: center;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            color: #64748b;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            border-radius: 50px;
            margin: 0;
        }

        .tab.active {
            color: #ffffff;
            background: linear-gradient(90deg, #2563eb, #3b82f6);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
        }

        .tab:hover:not(.active) {
            color: #2563eb;
            background-color: rgba(37, 99, 235, 0.05);
        }

        /* 表单容器样式 */
        .form-container {
            position: relative;
            width: 100%;
        }

        .form {
            display: none;
            animation: fadeIn 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .form.active {
            display: block;
        }

        /* 表单组样式 - 高级感设计 */
        .form-group {
            margin-bottom: 1.8rem;
            position: relative;
        }

        label {
            display: block;
            margin-bottom: 0.8rem;
            font-weight: 600;
            color: #334155;
            font-size: 14px;
            letter-spacing: 0.3px;
        }

        /* 密码输入框容器 */
        .password-container {
            position: relative;
        }

        /* 高级感输入框样式 */
        .form-control {
            width: 100%;
            padding: 1.1rem 1.5rem;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            font-size: 16px;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            background: #ffffff;
            color: #1e293b;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.02);
        }

        /* 密码输入框特殊样式 */
        .password-container .form-control {
            padding-right: 4.5rem;
        }

        .form-control:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1), 0 4px 12px rgba(0, 0, 0, 0.05);
            background: white;
            transform: translateY(-1px);
        }

        .form-control::placeholder {
            color: #94a3b8;
            font-weight: 400;
        }

        .form-control:hover {
            border-color: #cbd5e1;
        }

        /* 密码显示/隐藏按钮 - 高级感设计 */
        .toggle-password {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #94a3b8;
            cursor: pointer;
            font-size: 18px;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            border-radius: 50%;
        }

        .toggle-password:hover {
            color: #2563eb;
            background-color: rgba(37, 99, 235, 0.05);
        }

        /* 提交按钮样式 - 高级感渐变按钮 */
        .btn-primary {
            width: 100%;
            padding: 1.1rem 1.5rem;
            background: linear-gradient(90deg, #2563eb 0%, #3b82f6 100%);
            color: white;
            border: none;
            border-radius: 16px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            margin-top: 1rem;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.15);
            letter-spacing: 0.5px;
            position: relative;
            overflow: hidden;
        }

        .btn-primary::after {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.1), transparent);
            transition: all 0.6s ease;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(37, 99, 235, 0.25);
            background: linear-gradient(90deg, #1d4ed8 0%, #2563eb 100%);
        }

        .btn-primary:hover::after {
            left: 100%;
        }

        .btn-primary:active {
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.2);
        }

        /* 消息提示样式 - 高级感设计 */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 16px;
            margin-bottom: 2rem;
            font-size: 14px;
            animation: slideIn 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: none;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .alert-error {
            color: #dc2626;
            background: #fef2f2;
        }

        .alert-success {
            color: #059669;
            background: #f0fdf4;
        }

        /* 链接样式 - 高级感设计 */
        .links {
            text-align: center;
            margin-top: 2.5rem;
        }

        .links a {
            color: #2563eb;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-weight: 500;
            position: relative;
        }

        .links a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: #2563eb;
            transition: width 0.3s ease;
        }

        .links a:hover {
            color: #1d4ed8;
        }

        .links a:hover::after {
            width: 100%;
        }

        /* 动画效果 - 更流畅的曲线 */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(15px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-15px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* 响应式调整 */
        @media (max-width: 1200px) {
            .intro-section {
                padding: 3rem 4rem;
            }

            .auth-section {
                padding: 4rem 3rem;
            }

            .intro-title {
                font-size: 2.4rem;
            }
        }

        @media (max-width: 992px) {
            .main-container {
                flex-direction: column;
            }

            .intro-section {
                flex: none;
                padding: 3rem 2.5rem;
                height: 40%;
            }

            .auth-section {
                flex: none;
                padding: 3rem 2.5rem;
                height: 60%;
            }

            .intro-title {
                font-size: 2rem;
                margin-bottom: 1.5rem;
            }

            .intro-desc {
                max-width: 100%;
                font-size: 1.1rem;
            }

            .intro-logo {
                font-size: 2.5rem;
                margin-bottom: 1.5rem;
            }

            .auth-header h2 {
                font-size: 1.8rem;
            }
        }

        @media (max-width: 480px) {
            .intro-section {
                padding: 2rem 1.5rem;
                height: 35%;
            }

            .auth-section {
                padding: 2rem 1.5rem;
                height: 65%;
            }

            .tab {
                font-size: 15px;
                padding: 0.8rem 1rem;
            }

            .form-control {
                padding: 1rem 1.25rem;
                font-size: 15px;
            }

            .password-container .form-control {
                padding-right: 3.5rem;
            }

            .btn-primary {
                padding: 1rem 1.25rem;
                font-size: 15px;
            }

            .intro-title {
                font-size: 1.8rem;
            }

            .intro-desc {
                font-size: 1rem;
            }

            .toggle-password {
                font-size: 16px;
                right: 0.8rem;
                width: 36px;
                height: 36px;
            }

            .auth-header h2 {
                font-size: 1.6rem;
            }
        }
    </style>
    <!-- 引入图标库 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="main-container">
    <!-- 左侧介绍区域 - 保持不变 -->
    <div class="intro-section">
        <div class="intro-logo">
            <i class="fas fa-share-alt"></i>
            <span>校园资源共享</span>
        </div>
        <h1 class="intro-title">校园资源共享租赁平台</h1>
        <p class="intro-desc">
            打造校园内便捷的资源共享生态圈，让闲置的物品发挥最大价值，
            为师生提供安全、高效、便捷的租赁服务。
        </p>

        <div class="intro-features">
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>丰富的校园资源，涵盖学习、生活、运动等各类物品</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>实名认证，安全交易，保障双方权益</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>便捷的租赁流程，线上操作，线下交接</span>
            </div>
            <div class="feature-item">
                <i class="fas fa-check-circle"></i>
                <span>价格透明，自主定价，灵活租赁</span>
            </div>
        </div>
    </div>

    <!-- 右侧登录注册区域 - 高级感设计 -->
    <div class="auth-section">
        <div class="auth-card">
            <!-- 高级感标题区域 -->
            <div class="auth-header">
                <h2>欢迎回来</h2>
                <p>登录您的账号，开始校园资源共享之旅</p>
            </div>

            <!-- 显示成功或错误消息 -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">${errorMessage}</div>
            </c:if>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>

            <!-- 高级感标签切换 -->
            <div class="tabs">
                <button class="tab active" onclick="showForm('login')">登录</button>
                <button class="tab" onclick="showForm('register')">注册</button>
            </div>

            <div class="form-container">
                <!-- 登录表单 -->
                <form id="loginForm" class="form active" action="${pageContext.request.contextPath}/user/login" method="post">
                    <div class="form-group">
                        <label>手机号</label>
                        <input type="tel" name="phone" class="form-control" placeholder="请输入手机号" required value="${param.phone}">
                    </div>

                    <div class="form-group">
                        <label>密码</label>
                        <div class="password-container">
                            <input type="password" name="password" id="loginPassword" class="form-control" placeholder="请输入密码" required>
                            <button type="button" class="toggle-password" onclick="togglePassword('loginPassword', this)">
                                <i class="fas fa-eye-slash"></i>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="btn-primary">登录</button>
                </form>

                <!-- 注册表单 -->
                <form id="registerForm" class="form" action="${pageContext.request.contextPath}/user/register" method="post">
                    <div class="form-group">
                        <label>昵称</label>
                        <input type="text" name="nickname" class="form-control" placeholder="请输入昵称（可选）">
                    </div>

                    <div class="form-group">
                        <label>手机号</label>
                        <input type="tel" name="phone" class="form-control" placeholder="请输入手机号" required>
                    </div>

                    <div class="form-group">
                        <label>密码</label>
                        <div class="password-container">
                            <input type="password" name="password" id="registerPassword" class="form-control" placeholder="请输入密码（至少6位）" required minlength="6">
                            <button type="button" class="toggle-password" onclick="togglePassword('registerPassword', this)">
                                <i class="fas fa-eye-slash"></i>
                            </button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>确认密码</label>
                        <div class="password-container">
                            <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="请再次输入密码" required>
                            <button type="button" class="toggle-password" onclick="togglePassword('confirmPassword', this)">
                                <i class="fas fa-eye-slash"></i>
                            </button>
                        </div>
                    </div>

                    <input type="hidden" name="role" value="user">

                    <button type="submit" class="btn-primary">注册</button>
                </form>
            </div>

            <div class="links">
                <a href="${pageContext.request.contextPath}/product/list">← 返回商品列表</a>
            </div>
        </div>
    </div>
</div>

<script>
    // 标签切换功能
    function showForm(formType) {
        // 隐藏所有表单
        document.querySelectorAll('.form').forEach(form => {
            form.classList.remove('active');
        });

        // 移除所有标签的active类
        document.querySelectorAll('.tab').forEach(tab => {
            tab.classList.remove('active');
        });

        // 显示选中的表单
        document.getElementById(formType + 'Form').classList.add('active');

        // 激活选中的标签
        event.target.classList.add('active');

        // 清除消息
        clearMessages();
    }

    // 清除消息
    function clearMessages() {
        const messages = document.querySelectorAll('.alert');
        messages.forEach(msg => msg.style.display = 'none');
    }

    // 密码显示/隐藏切换功能
    function togglePassword(inputId, button) {
        const passwordInput = document.getElementById(inputId);
        const icon = button.querySelector('i');

        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        } else {
            passwordInput.type = 'password';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        }
    }

    // 注册表单客户端验证
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const password = this.querySelector('input[name="password"]').value;
        const confirmPassword = this.querySelector('input[name="confirmPassword"]').value;

        if (password !== confirmPassword) {
            e.preventDefault();
            showToast('两次输入的密码不一致！', 'error');
            return false;
        }

        if (password.length < 6) {
            e.preventDefault();
            showToast('密码长度至少6位！', 'error');
            return false;
        }
    });

    // 页面加载时根据URL参数显示对应标签
    window.addEventListener('load', function() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('success') === 'true') {
            // 注册成功，自动切换到登录标签
            showForm('login');
        }
    });

    // 美化的提示框
    function showToast(message, type) {
        // 先移除已有的提示
        const existingToast = document.querySelector('.toast');
        if (existingToast) {
            existingToast.remove();
        }

        // 创建新提示
        const toast = document.createElement('div');
        toast.className = type === 'error' ? 'alert alert-error toast' : 'alert alert-success toast';
        toast.textContent = message;
        toast.style.position = 'fixed';
        toast.style.top = '30px';
        toast.style.left = '50%';
        toast.style.transform = 'translateX(-50%)';
        toast.style.zIndex = '9999';
        toast.style.minWidth = '350px';
        toast.style.boxShadow = '0 8px 24px rgba(0,0,0,0.12)';
        toast.style.borderRadius = '16px';

        document.body.appendChild(toast);

        // 3秒后自动消失
        setTimeout(() => {
            toast.style.opacity = '0';
            toast.style.transition = 'opacity 0.3s ease';
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }

    // 输入框获得焦点时的动画
    document.querySelectorAll('.form-control').forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.style.transform = 'translateY(-3px)';
            this.parentElement.style.transition = 'transform 0.3s cubic-bezier(0.4, 0, 0.2, 1)';
        });

        input.addEventListener('blur', function() {
            this.parentElement.style.transform = 'translateY(0)';
        });
    });

    // 适配窗口大小变化
    window.addEventListener('resize', function() {
        document.querySelector('.main-container').style.height = window.innerHeight + 'px';
    });
</script>
</body>
</html>