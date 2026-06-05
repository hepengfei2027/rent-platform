package com.service.Impl;


import com.dao.ProductDao;
import com.model.Product;
import com.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ProductServiceImpl implements ProductService {

    @Autowired
    private ProductDao productDao;

    @Override
    public List<Product> getAllProducts() {
        return productDao.findAll();
    }

    @Override
    public Product getProductById(Integer id) {
        return productDao.findById(id);
    }

    @Override
    public boolean addProduct(Product product) {
        return productDao.insert(product) > 0;
    }

    @Override
    public boolean updateProduct(Product product) {
        return productDao.update(product) > 0;
    }

    @Override
    public boolean deleteProduct(Integer id) {
        return productDao.delete(id) > 0;
    }

    @Override
    public List<Product> searchProductsByName(String name) {
        return productDao.findByName(name);
    }

    @Override
    public boolean updateProductStock(Integer id, Integer stock) {
        return productDao.updateStock(id, stock) > 0;
    }

    @Override
    public List<Product> getProductsByStatus(Integer status) {
        return productDao.selectProductsByStatus(status);
    }


    // 新增的租赁购买相关方法
    @Override
    public boolean buyProduct(Integer productId, Integer buyerId, String buyerName) {
        // 实现购买逻辑
        Product product = productDao.findById(productId);
        if (product == null || product.getStock() <= 0) {
            return false;
        }

        // 更新商品所有者
        productDao.updateOwner(productId, buyerId, buyerName);
        // 减少库存
        productDao.updateStock(productId, product.getStock() - 1);
        // 更新状态为已售出
        productDao.updateStatus(productId, 3); // 3表示已售出

        return true;
    }

    @Override
    public boolean rentProduct(Integer productId, Integer buyerId, String buyerName, Integer rentDays) {
        // 实现租赁逻辑
        Product product = productDao.findById(productId);
        if (product == null || product.getRentPrice() == null) {
            return false;
        }

        // 更新商品状态为已出租
        return productDao.updateStatus(productId, 2) > 0; // 2表示已出租
    }

    @Override
    public boolean returnRentedProduct(Integer productId) {
        // 实现归还逻辑
        return productDao.updateStatus(productId, 1) > 0; // 1表示上架
    }

    @Override
    public boolean transferOwnership(Integer productId, Integer newOwnerId, String newOwnerName) {
        return productDao.updateOwner(productId, newOwnerId, newOwnerName) > 0;
    }

    @Override
    public List<Product> getProductsByOwner(Integer ownerId) {
        try {
            return productDao.findByOwnerId(ownerId);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Override
    public List<Product> getProductsByCategory(String category) {
        try {
            return productDao.findByCategoryAndStatus(category, Product.STATUS_ON_SALE);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 获取上架商品列表 - 关键方法
     */
    @Override
    public List<Product> getOnSaleProducts() {
        try {
            System.out.println("=== ProductService: 查询上架商品 ===");
            List<Product> products = productDao.findOnSaleProducts();
            System.out.println("查询到上架商品数量: " + (products != null ? products.size() : 0));
            return products;
        } catch (Exception e) {
            System.err.println("❌ 查询上架商品异常: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 处理购买 - 关键方法（OrderService会调用这个方法）
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean processPurchase(Integer productId, Integer buyerId, String buyerName) {
        try {
            System.out.println("=== ProductService: 处理购买 ===");
            System.out.println("商品ID: " + productId + ", 买家ID: " + buyerId);

            // 1. 获取商品信息
            Product product = productDao.findById(productId);
            if (product == null) {
                System.out.println("❌ 商品不存在");
                return false;
            }

            System.out.println("购买前 - 商品状态: " + product.getStatus() + ", 库存: " + product.getStock());

            // 2. 检查商品是否可购买
            if (product.getStatus() != 1 || product.getStock() <= 0) {
                System.out.println("❌ 商品不可购买");
                return false;
            }

            // 3. 原子操作：更新状态、库存和所有者
            int updateResult = productDao.updateStatusAndStockAndOwner(
                    productId,
                    3, // 状态改为已售出
                    product.getStock() - 1, // 库存减1
                    buyerId,
                    buyerName
            );

            System.out.println("购买后 - 状态更新结果: " + updateResult);

            if (updateResult > 0) {
                System.out.println("✅ 商品状态已更新为已售出");
                return true;
            } else {
                System.out.println("❌ 商品状态更新失败");
                return false;
            }

        } catch (Exception e) {
            System.err.println("❌ 购买过程异常: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Map<String, Integer> getCategoryStatistics() {
        try {
            // 直接查询数据库
            List<Map<String, Object>> result = productDao.countProductsByCategory();
            Map<String, Integer> stats = new LinkedHashMap<>();

            for (Map<String, Object> row : result) {
                String category = (String) row.get("category");
                Long count = (Long) row.get("count");
                stats.put(category, count.intValue());
            }

            return stats;

        } catch (Exception e) {
            // ❌ 不要返回示例数据，直接返回空Map
            e.printStackTrace();
            return new LinkedHashMap<>();
        }
    }



}



