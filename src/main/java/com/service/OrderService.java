package com.service;

import com.model.Order;
import java.util.List;

public interface OrderService {
    boolean createOrder(Order order);
    Order getOrderById(Integer id);
    List<Order> getOrdersByUser(Integer userId);
    boolean processPurchase(Integer productId, Integer buyerId, String buyerName);

    boolean processRental(Integer productId, Integer buyerId, String buyerName, Integer rentDays);

    // ✅ 新增：获取全平台交易总额
    Double getTotalTransactionAmount();

    }

