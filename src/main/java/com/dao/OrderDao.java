package com.dao;

import com.model.Order;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderDao {
    int insert(Order order);
    Order findById(Integer id);
    List<Order> findByBuyerId(Integer buyerId);
    int updateStatus(Integer id, Integer status);




    // ✅ 新增：统计全平台交易总额
    Double getTotalTransactionAmount();


}