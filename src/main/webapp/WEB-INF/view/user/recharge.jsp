<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>余额充值</title>
    <style>
        body { font-family: Arial; margin: 20px; background: #f5f5f5; }
        .container { max-width: 500px; margin: 0 auto; background: white; padding: 30px; border-radius: 8px; }
        .form-group { margin: 15px 0; }
        label { display: block; margin: 5px 0; font-weight: bold; }
        input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; }
        .btn { padding: 12px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; width: 100%; }
        .btn:hover { background: #0056b3; }
    </style>
</head>
<body>
<div class="container">
    <h2>💰 余额充值</h2>

    <form action="/user/doRecharge" method="post">
        <div class="form-group">
            <label>银行卡号：</label>
            <input type="text" name="cardNumber" placeholder="请输入银行卡号" required maxlength="19">
        </div>

        <div class="form-group">
            <label>充值金额：</label>
            <input type="number" name="amount" placeholder="请输入充值金额" min="1" step="0.01" required>
        </div>

        <button type="submit" class="btn">立即充值</button>
    </form>

    <div style="margin-top: 20px; text-align: center;">
        <a href="/user/center">返回个人中心</a>
    </div>
</div>
</body>
</html>