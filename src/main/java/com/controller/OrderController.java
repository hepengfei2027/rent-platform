package com.controller;

import com.model.Order;
import com.model.User;
import com.service.OrderService;
import com.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/order")
public class OrderController {

    @Autowired
    private OrderService orderService;
    @Autowired
    private UserService userService;

    @GetMapping("/my")
    public String myOrders(HttpSession session, Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/user/login";
        }

        List<Order> orders = orderService.getOrdersByUser(user.getId());
        model.addAttribute("orders", orders);
        return "order/my_order";
    }

    @PostMapping("/buy")
    public String buyProduct(@RequestParam Integer productId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "请先登录");
            return "redirect:/user/login";
        }

        // 检查用户是否被封禁
        if (userService.isUserBanned(user.getId())) {
            redirectAttributes.addFlashAttribute("error", "您的账号已被封禁，无法购买商品");
            return "redirect:/product/list";
        }


        boolean result = orderService.processPurchase(
                productId, user.getId(), user.getNickname());

        if (result) {
            redirectAttributes.addFlashAttribute("success", "购买成功");
        } else {
            redirectAttributes.addFlashAttribute("error", "购买失败");
        }

        return "redirect:/product/list";
    }

    @GetMapping("/detail/{id}")
    public String orderDetail(@PathVariable Integer id,
                              HttpSession session,
                              Model model) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            return "redirect:/user/login";
        }

        Order order = orderService.getOrderById(id);
        if (order == null || !order.getBuyerId().equals(user.getId())) {
            return "redirect:/order/my";
        }

        model.addAttribute("order", order);
        return "order/detail";
    }

    /**
     * 处理租赁请求
     */
    @PostMapping("/rent")
    public String rentProduct(@RequestParam Integer productId,
                              @RequestParam Integer rentDays,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            redirectAttributes.addFlashAttribute("error", "请先登录");
            return "redirect:/user/login";
        }

        try {
            boolean result = orderService.processRental(productId, user.getId(), user.getNickname(), rentDays);
            if (result) {
                redirectAttributes.addFlashAttribute("success", "租赁成功！租赁期：" + rentDays + "天");
            } else {
                redirectAttributes.addFlashAttribute("error", "租赁失败，请重试");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "系统错误：" + e.getMessage());
        }

        return "redirect:/product/list";
    }


}