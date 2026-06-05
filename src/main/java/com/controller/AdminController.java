package com.controller;

import com.model.Product;
import com.model.User;
import com.service.OrderService;
import com.service.ProductService;
import com.service.ReviewService;
import com.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private ProductService productService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private ReviewService reviewService;

    /**
     * 管理员仪表盘
     */
    @GetMapping("/dashboard")
    public String adminDashboard(Model model, HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/product/list";
        }

        // ✅ 3. 获取全平台交易总额
        Double totalAmount = orderService.getTotalTransactionAmount();
        model.addAttribute("totalAmount", totalAmount);


        // ✅ 获取分类统计
        Map<String, Integer> categoryStats = productService.getCategoryStatistics();
        model.addAttribute("categoryStats", categoryStats);

        // ✅ 计算商品总数
        int totalProducts = categoryStats.values().stream().mapToInt(Integer::intValue).sum();
        model.addAttribute("totalProducts", totalProducts);

        //获取用户
        List<User> users = userService.getAllUsers();
        // 计算每个用户的平均分
        Map<Integer, Double> userAvgRatings = new HashMap<>();
        for (User user : users) {
            double avgRating = reviewService.getUserAverageRating(user.getId());
            userAvgRatings.put(user.getId(), avgRating);
        }
        model.addAttribute("users", users);
        model.addAttribute("userAvgRatings", userAvgRatings);
        return "admin/dashboard";
    }

    /**
     * 获取待审核商品列表
     */
    @GetMapping("/product/pending")
    public String pendingProducts(Model model, HttpSession session) {
        if (!isAdmin(session)) {
            return "redirect:/product/list";
        }
        List<Product> pendingProducts = productService.getProductsByStatus(Product.STATUS_PENDING_REVIEW);
        model.addAttribute("pendingProducts", pendingProducts);
        return "product/pending"; // 对应 /WEB-INF/jsp/admin/pending.jsp
    }

    /**
     * 管理员审核商品（上架/下架）
     */
    @PostMapping("/product/review/{productId}")
    public String reviewProduct(@PathVariable Integer productId,
                                @RequestParam Integer status,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        if (!isAdmin(session)) {
            return "redirect:/product/list";
        }

        Product product = productService.getProductById(productId);
        if (product == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "商品不存在");
            return "redirect:/admin/product/pending";
        }

        if (status != Product.STATUS_ON_SALE && status != Product.STATUS_SOLD) {
            redirectAttributes.addFlashAttribute("errorMessage", "无效的状态值");
            return "redirect:/admin/product/pending";
        }

        product.setStatus(status);
        productService.updateProduct(product);

        if (status == Product.STATUS_ON_SALE) {
            redirectAttributes.addFlashAttribute("successMessage", "商品已上架");
        } else {
            redirectAttributes.addFlashAttribute("successMessage", "商品已下架");
        }

        return "redirect:/admin/product/pending";
    }

    /**
     * 扣除用户信誉分 - 修正版
     */
    @PostMapping("/deductCredit")
    public String deductCredit(@RequestParam Integer userId,
                               @RequestParam Integer deductScore,
                               @RequestParam String reason,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        try {
            // 1. 管理员权限检查
            if (!isAdmin(session)) {
                return "redirect:/product/list";
            }

            // 2. 参数验证
            if (userId == null || deductScore == null || deductScore <= 0) {
                redirectAttributes.addFlashAttribute("error", "参数错误");
                return "redirect:/admin/dashboard";
            }

            // 3. 执行信誉分扣除 - 修正方法调用
            boolean success = userService.deductCreditScore(userId, deductScore, reason);

            if (success) {
                redirectAttributes.addFlashAttribute("success", "扣除信誉分成功");
            } else {
                redirectAttributes.addFlashAttribute("error", "扣除信誉分失败");
            }

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error系统错误：" + e.getMessage());
        }

        return "redirect:/admin/dashboard";
    }

    /**
     * 封禁用户
     */
    @PostMapping("/banUser")
    public String banUser(@RequestParam Integer userId,
                          @RequestParam Integer banDays,
                          @RequestParam String reason,
                          HttpSession session,
                          RedirectAttributes redirectAttributes) {
        try {
            if (!isAdmin(session)) {
                return "redirect:/product/list";
            }

            boolean success = userService.banUser(userId, banDays, reason);

            if (success) {
                redirectAttributes.addFlashAttribute("success", "封禁用户成功");
            } else {
                redirectAttributes.addFlashAttribute("error", "封禁用户失败");
            }

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "系统错误：" + e.getMessage());
        }

        return "redirect:/admin/dashboard";
    }


    /**
     * 解封用户
     */
    @PostMapping("/unbanUser")
    public String unbanUser(@RequestParam Integer userId,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        try {
            // 1. 权限校验：确保当前操作用户是管理员
            if (!isAdmin(session)) {
                return "redirect:/product/list";
            }

            // 2. 调用服务层方法执行解封操作
            boolean success = userService.unbanUser(userId);

            // 3. 根据操作结果设置提示信息
            if (success) {
                redirectAttributes.addFlashAttribute("success", "解封用户成功");
            } else {
                redirectAttributes.addFlashAttribute("error", "解封用户失败");
            }

        } catch (Exception e) {
            // 4. 捕获并处理异常，传递错误信息
            redirectAttributes.addFlashAttribute("error", "系统错误：" + e.getMessage());
        }

        // 5. 重定向到管理员控制台页面
        return "redirect:/admin/dashboard";
    }
    /**
     * 检查是否为管理员
     */
    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("currentUser");
        return user != null && "admin".equals(user.getRole());

}}