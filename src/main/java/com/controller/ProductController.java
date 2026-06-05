package com.controller;

import com.model.Product;
import com.model.User;
import com.service.ProductService;
import com.service.ReviewService;
import com.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private UserService userService;

    @Autowired
    private ReviewService reviewService;
    /**
     * 显示添加商品页面
     */
    @GetMapping("/add")
    public String addProductPage(Model model) {
        model.addAttribute("product", new Product());
        return "product/add";
    }

    /**
     * 处理添加商品表单提交
     */
    @PostMapping("/add")
    public String addProduct(Product product, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "请先登录");
            return "redirect:/user/auth";
        }

        // 检查用户是否被封禁
        if (userService.isUserBanned(currentUser.getId())) {
            redirectAttributes.addFlashAttribute("error", "您的账号已被封禁，无法发布商品");
            return "redirect:/product/list";
        }

        // 信誉分检查 - 低于60分不能发布商品
        if (currentUser.getCreditScore() < 20) {
            redirectAttributes.addFlashAttribute("error",
                    "信誉分不足20分（当前：" + currentUser.getCreditScore() + "分），无法发布商品");
            return "redirect:/product/add";
        }

        // 设置商品所有者
        product.setOwnerId(currentUser.getId());
        product.setOwnerName(currentUser.getNickname());

        // 押金：用户填多少就是多少，不自动计算
        if (product.getDeposit() == null) {
            product.setDeposit(0.0); // 默认0元押金
        }

        // 默认状态为【待审核】
        if (product.getStatus() == null) {
            product.setStatus(Product.STATUS_PENDING_REVIEW);
        }

        // 设置默认库存
        if (product.getStock() == null || product.getStock() <= 0) {
            product.setStock(1);
        }

        // 设置默认商品类型（可租可售）
        if (product.getProductType() == null) {
            product.setProductType(3); // 可租可售
        }

        if (productService.addProduct(product)) {
            redirectAttributes.addFlashAttribute("successMessage", "商品添加成功");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "商品添加失败");
        }

        return "redirect:/product/list";
    }

    /**
     * 押金计算逻辑
     */
    private Double calculateDeposit(Double rentPrice, Integer creditScore){
        // 信誉分越高，押金比例越低
        if (creditScore >= 90) {
            return rentPrice * 0.5; // 信誉优秀：押金为租金的50%
        } else if (creditScore >= 70) {
            return rentPrice * 1.0; // 信誉良好：押金为租金的100%
        } else if (creditScore >=60) {
            return rentPrice * 2.0; // 信誉一般：押金为租金的200%
        } else {
            return rentPrice * 3.0; // 信誉差：押金为租金的300%
        }

    }

    /**
     * 商品列表 - 支持搜索和分类筛选
     */
    @GetMapping("/list")
    public String productList(@RequestParam(required = false) String name,
                              @RequestParam(required = false) String category,
                              Model model) {
        System.out.println("=== 查询商品列表 ===");
        System.out.println("搜索参数 - 名称: " + name + ", 分类: " + category);


        List<Product> products; // 声明变量

        // 条件判断逻辑
        if (name != null && !name.trim().isEmpty()) {
            //将结果赋值给products变量
            products = productService.getOnSaleProducts();
        System.out.println("搜索模式，结果数量: " + (products != null ? products.size() : 0));
        }
        //添加正确的条件判断
        else if (category != null && !category.trim().isEmpty()) {
            products = productService.getProductsByCategory(category);
            System.out.println("分类筛选模式[" + category + "]，结果数量: " + (products != null ? products.size() : 0));
        }
        else {
            products = productService.getOnSaleProducts();
            System.out.println("全部商品模式，结果数量: " + (products != null ? products.size() : 0));
        }

        //添加空值检查
        if (products == null) {
            products = new ArrayList<>(); // 防止空指针异常
            System.out.println("⚠️ 查询结果为空，使用空列表");
        }

        // 用来存储每个商品所有者的平均分
        Map<Integer, Double> ownerAvgRatings = new HashMap<>();

        for (Product product : products) {
            if (product.getOwnerId() != null) {
                // 计算该商品所有者的平均分
                double avgRating = reviewService.getUserAverageRating(product.getOwnerId());
                ownerAvgRatings.put(product.getId(), avgRating);
            }
        }


        model.addAttribute("products", products);
        model.addAttribute("ownerAvgRatings", ownerAvgRatings);
        model.addAttribute("searchName", name);
        model.addAttribute("selectedCategory", category);
        return "product/list";
    }



    /**
     * 搜索商品
     */
    @GetMapping("/search")
    public String searchProducts(@RequestParam String name, Model model) {
        List<Product> products = productService.searchProductsByName(name);
        model.addAttribute("products", products);
        model.addAttribute("searchName", name);
        return "product/list";
    }

    /**
     * 商品详情页面
     */
    @GetMapping("/detail/{id}")
    public String productDetail(@PathVariable Integer id, Model model) {
        Product product = productService.getProductById(id);
        model.addAttribute("product", product);
        return "order/detail";
    }

    /**
     * 编辑商品页面
     */
    @GetMapping("/edit/{id}")
    public String editProductPage(@PathVariable Integer id, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        Product product = productService.getProductById(id);

        // 权限检查：只有商品所有者或管理员可以编辑
        if (currentUser == null ||
                (!currentUser.getId().equals(product.getOwnerId()) &&
                        !"admin".equals(currentUser.getRole()))) {
            return "redirect:/product/list";
        }

        model.addAttribute("product", product);
        return "product/edit";
    }

    /**
     * 更新商品
     */
    @PostMapping("/update")
    public String updateProduct(Product product, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "请先登录");
            return "redirect:/user/auth";
        }

        // 权限检查
        Product existingProduct = productService.getProductById(product.getId());
        if (existingProduct == null ||
                (!currentUser.getId().equals(existingProduct.getOwnerId()) &&
                        !"admin".equals(currentUser.getRole()))) {
            redirectAttributes.addFlashAttribute("errorMessage", "无权限操作");
            return "redirect:/product/list";
        }

// 押金：直接使用用户填写的值，不修改
        if (product.getDeposit() == null) {
            product.setDeposit(0.0);
        }

        if (productService.updateProduct(product)) {
            redirectAttributes.addFlashAttribute("successMessage", "商品更新成功");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "商品更新失败");
        }

        return "redirect:/product/list";
    }

    /**
     * 删除商品
     */
    @GetMapping("/delete/{id}")
    public String deleteProduct(@PathVariable Integer id, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "请先登录");
            return "redirect:/user/auth";
        }

        // 权限检查
        Product product = productService.getProductById(id);
        if (product == null ||
                (!currentUser.getId().equals(product.getOwnerId()) &&
                        !"admin".equals(currentUser.getRole()))) {
            redirectAttributes.addFlashAttribute("errorMessage", "无权限操作");
            return "redirect:/product/list";
        }

        if (productService.deleteProduct(id)) {
            redirectAttributes.addFlashAttribute("successMessage", "商品删除成功");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "商品删除失败");
        }

        return "redirect:/product/list";
    }

    /**
     * 我的商品页面
     */
    @GetMapping("/my")
    public String myProducts(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/user/auth";
        }

        List<Product> myProducts = productService.getProductsByOwner(currentUser.getId());
        model.addAttribute("products", myProducts);
        return "order/my_products";
    }

    /**
     * RESTful API - 获取所有商品(JSON)
     */
    @GetMapping("/api/list")
    @ResponseBody
    public List<Product> getProductsApi() {
        return productService.getAllProducts();
    }

    /**
     * RESTful API - 根据ID获取商品(JSON)
     */
    @GetMapping("/api/{id}")
    @ResponseBody
    public Product getProductApi(@PathVariable Integer id) {
        return productService.getProductById(id);
    }






}