package com.dao;

import com.model.Product;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

public interface ProductDao {
    // 基本CRUD方法
    List<Product> findAll();
    Product findById(Integer id);
    int insert(Product product);
    int update(Product product);
    int delete(Integer id);
    List<Product> findByName(String name);

    // 更新操作方法
    int updateStock(@Param("id") Integer id, @Param("stock") Integer stock);
    int updateOwner(@Param("id") Integer id, @Param("ownerId") Integer ownerId, @Param("ownerName") String ownerName);
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);

    // 查询方法
    List<Product> findByOwnerId(Integer ownerId);
    List<Product> findByType(Integer productType);
    List<Product> findByCategoryAndStatus(@Param("category") String category, @Param("status") Integer status);

    // ✅ 添加这些缺失的关键方法
    List<Product> findOnSaleProducts(); // 查询上架商品
    List<Product> findByNameAndStatus(@Param("name") String name, @Param("status") Integer status); // 按名称和状态搜索

    // ✅ 添加原子更新方法（购买功能必需）
    int updateStatusAndStockAndOwner(@Param("id") Integer id,
                                     @Param("status") Integer status,
                                     @Param("stock") Integer stock,
                                     @Param("ownerId") Integer ownerId,
                                     @Param("ownerName") String ownerName);


    List<Product> selectProductsByStatus(Integer status);

    // ✅ 新增：统计所有商品的分类数量（包含所有状态）
    List<Map<String, Object>> countProductsByCategory();

}