package com.service;

import com.model.Product;
import java.util.List;
import java.util.Map;

public interface ProductService {
    List<Product> getAllProducts();
    Product getProductById(Integer id);
    boolean addProduct(Product product);
    boolean updateProduct(Product product);
    boolean deleteProduct(Integer id);
    List<Product> searchProductsByName(String name);
    List<Product> getProductsByCategory(String category);
    //  新增：获取分类统计
    Map<String, Integer> getCategoryStatistics();
    List<Product> getProductsByOwner(Integer ownerId);
    List<Product> getOnSaleProducts();

    List<Product> getProductsByStatus(Integer status);
    boolean transferOwnership(Integer productId, Integer newOwnerId, String newOwnerName);
    boolean buyProduct(Integer productId, Integer buyerId, String buyerName);
    boolean rentProduct(Integer productId, Integer buyerId, String buyerName, Integer rentDays);
    boolean returnRentedProduct(Integer productId);
    boolean updateProductStock(Integer id, Integer stock);
    // 添加这两个缺失的关键方法
    boolean processPurchase(Integer productId, Integer buyerId, String buyerName);


}
