package com.controller;

import com.model.Product;
import com.model.Review;
import com.model.User;
import com.service.ProductService;
import com.service.ReviewService;
import com.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private ProductService productService;

    /**
     * 显示登录注册页面
     */
    @GetMapping("/auth")
    public String showAuthPage(@RequestParam(value = "error", required = false) String error,
                               @RequestParam(value = "success", required = false) String success,
                               Model model) {
        if (error != null) {
            model.addAttribute("errorMessage", "手机号或密码错误");
        }
        if (success != null) {
            model.addAttribute("successMessage", "注册成功，请登录");
        }
        return "user/login";
    }

    /**
     * 用户登录处理
     */
    @PostMapping("/login")
    public String login(@RequestParam String phone,
                        @RequestParam String password,
                        HttpSession session,
                        RedirectAttributes redirectAttributes) {
        User user = userService.login(phone, password);
        if (user != null) {
            // 检查是否被封禁
            if (Boolean.TRUE.equals(user.getBanned())) {
                // 账号已被封禁
                // 封禁用户，拒绝登录
                redirectAttributes.addFlashAttribute("errorMessage", "该账号已被封禁，无法登录！");
                return "redirect:/user/auth";
            }
            // 登录成功，将用户信息存入session
            session.setAttribute("currentUser", user);
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userNickname", user.getNickname());

            return "redirect:/product/list";
        } else {
            // 登录失败
            redirectAttributes.addAttribute("error", "true");
            return "redirect:/user/auth";
        }
    }

    /**
     * 用户注册处理 - 注册成功后跳转回登录界面
     */
    @PostMapping("/register")
    public String register(@RequestParam String nickname,
                           @RequestParam String phone,
                           @RequestParam String password,
                           @RequestParam String confirmPassword,
                           @RequestParam(defaultValue = "user") String role,
                           RedirectAttributes redirectAttributes,
                           Model model) {

        // 客户端验证
        if (!password.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("errorMessage", "两次输入的密码不一致");
            return "redirect:/user/auth";
        }

        if (password.length() < 6) {
            redirectAttributes.addFlashAttribute("errorMessage", "密码长度至少6位");
            return "redirect:/user/auth";
        }

        // 检查手机号是否已存在
        if (userService.isPhoneExists(phone)) {
            redirectAttributes.addFlashAttribute("errorMessage", "该手机号已被注册");
            return "redirect:/user/auth";
        }

        // 创建用户对象
        User user = new User();
        user.setNickname(nickname);
        user.setUsername(phone); // 使用手机号作为用户名
        user.setPassword(password);
        user.setPhone(phone);
        user.setRole(role);
        user.setCreditScore(100); // 默认信誉分
        // 注册用户
        boolean result = userService.register(user);

        if (result) {
            // 注册成功，跳转回登录界面并显示成功消息
            redirectAttributes.addAttribute("success", "true");
            return "redirect:/user/auth";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "注册失败，请重试");
            return "redirect:/user/auth";
        }
    }

    /**
     * 个人中心首页
     */
    @GetMapping("/center")
    public String userCenter(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/user/login";
        }

        // 获取最新用户信息（包含信誉分）
        User currentUser = userService.getUserById(user.getId());
        session.setAttribute("currentUser", currentUser);


        // 获取用户的商品
        List<Product> userProducts = productService.getProductsByOwner(user.getId());

        // 获取用户收到的评价
        List<Review> reviews = reviewService.getReviewsByUser(user.getId());

        model.addAttribute("user", currentUser);
        model.addAttribute("reviews", reviews);
        model.addAttribute("avgRating", reviewService.getUserAverageRating(user.getId()));
        model.addAttribute("reviewCount", reviewService.getReviewCount(user.getId()));
        model.addAttribute("products", userProducts);
        return "user/center";
    }

    /**
     * 修改昵称
     */
    @PostMapping("/updateNickname")
    public String updateNickname(@RequestParam String nickname,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/user/login";
        }

        boolean result = userService.updateNickname(user.getId(), nickname);
        if (result) {
            // 更新session中的用户信息
            User updatedUser = userService.getUserById(user.getId());
            session.setAttribute("currentUser", updatedUser);
            redirectAttributes.addFlashAttribute("success", "昵称修改成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "昵称修改失败");
        }

        return "redirect:/user/center";
    }

    /**
     * 评价订单
     */
    @PostMapping("/review")
    public String addReview(@RequestParam Integer orderId,
                            @RequestParam Integer targetUserId,
                            @RequestParam String targetUserName,
                            @RequestParam Integer rating,
                            @RequestParam String content,
                            @RequestParam Integer type,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        User reviewer = (User) session.getAttribute("currentUser");
        if (reviewer == null) {
            return "redirect:/user/login";
        }

        boolean result = reviewService.addOrderReview(
                orderId, reviewer.getId(), reviewer.getNickname(),
                targetUserId, targetUserName, rating, content, type
        );

        if (result) {
            redirectAttributes.addFlashAttribute("success", "评价成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "评价失败");
        }

        return "redirect:/order/detail/" + orderId;
    }


    /**
     * 充值页面
     */
    @GetMapping("/recharge")
    public String rechargePage() {
        return "user/recharge";
    }

    /**
     * 处理充值请求
     */
    @PostMapping("/doRecharge")
    public String doRecharge(@RequestParam String cardNumber,
                             @RequestParam Double amount,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        try {
            User user = (User) session.getAttribute("currentUser");
            if (user == null) {
                return "redirect:/user/auth";
            }

            // 1. 验证银行卡号格式（简单验证）
            if (!isValidCardNumber(cardNumber)) {
                redirectAttributes.addFlashAttribute("error", "银行卡号格式不正确");
                return "redirect:/user/recharge";
            }

            // 2. 验证金额
            if (amount <= 0) {
                redirectAttributes.addFlashAttribute("error", "充值金额必须大于0");
                return "redirect:/user/recharge";
            }

            // 3. 执行充值（增加余额）
            boolean success = userService.addBalance(user.getId(), amount);
            if (success) {
                // 更新session中的用户信息
                User updatedUser = userService.getUserById(user.getId());
                session.setAttribute("currentUser", updatedUser);

                redirectAttributes.addFlashAttribute("success",
                        "充值成功！充值金额：" + amount + "元，当前余额：" + updatedUser.getBalance() + "元");
            } else {
                redirectAttributes.addFlashAttribute("error", "充值失败");
            }

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "系统错误：" + e.getMessage());
        }

        return "redirect:/user/center";
    }

    /**
     * 简单的银行卡号验证
     */
    private boolean isValidCardNumber(String cardNumber) {
        if (cardNumber == null || cardNumber.trim().isEmpty()) {
            return false;
        }
        // 移除空格，验证是否为数字且长度在16-19位之间
        String cleanCardNumber = cardNumber.replaceAll("\\s+", "");
        return cleanCardNumber.matches("\\d{16,19}");
    }


    /**
     * 用户退出
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/user/auth";
    }
}