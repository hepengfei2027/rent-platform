package com.service.Impl;

import com.dao.OrderDao;
import com.dao.ProductDao;
import com.model.Order;
import com.model.Product;
import com.service.OrderService;
import com.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Service("orderService")
@Transactional
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao orderDao;

    @Autowired
    private ProductDao productDao;


    @Autowired
    private UserService userService;


    @Override
    public boolean createOrder(Order order) {
        try {
            if (order.getOrderNo() == null) {
                order.setOrderNo(generateOrderNo());
            }
            if (order.getCreateTime() == null) {
                order.setCreateTime(new Date());
            }

            return orderDao.insert(order) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Order getOrderById(Integer id) {
        try {
            return orderDao.findById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Order> getOrdersByUser(Integer userId) {
        try {
            return orderDao.findByBuyerId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }



    @Override
    public boolean processPurchase(Integer productId, Integer buyerId, String buyerName) {
        try {
            Product product = productDao.findById(productId);
            if (product == null || product.getStock() <= 0) {
                return false;
            }

            // 2. 获取卖家ID
            Integer sellerId = product.getOwnerId();

            // 3. 执行余额转移（BigDecimal转double）
            boolean success = userService.transferBalance(
                    buyerId,
                    sellerId,
                    product.getPrice().doubleValue() // BigDecimal转double
            );

            if (!success) {
                return false;
            }


            // 6. ✅ 修复：更新商品状态为已出租
            product.setStatus(Product.STATUS_SOLD); // STATUS_RENTED = 2
            productDao.update(product);

            Order order = new Order();
            order.setOrderNo(generateOrderNo());
            order.setProductId(productId);
            order.setProductName(product.getName());
            order.setBuyerId(buyerId);
            order.setBuyerName(buyerName);
            order.setSellerId(product.getOwnerId());
            order.setSellerName(product.getOwnerName());
            order.setAmount(product.getPrice());
            order.setOrderType(Order.TYPE_BUY);
            order.setStatus(Order.STATUS_COMPLETED);

            return createOrder(order);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean processRental(Integer productId, Integer buyerId, String buyerName, Integer rentDays) {
        try {
            // 1. 获取商品信息
            Product product = productDao.findById(productId);
            if (product == null || product.getRentPrice() == null) {
                return false;
            }
            // 2. 获取卖家ID
            Integer sellerId = product.getOwnerId();
            // 3. 执行余额转移（BigDecimal转double）
            boolean success = userService.transferBalance(
                    buyerId,
                    sellerId,
                    product.getPrice().doubleValue() // BigDecimal转double
            );

            if (!success) {
                return false;
            }

            // 2. 计算租赁金额
            BigDecimal rentAmount = product.getRentPrice().multiply(new BigDecimal(rentDays));

            // 6. ✅ 修复：更新商品状态为已出租
            product.setStatus(Product.STATUS_RENTED); // STATUS_RENTED = 2
            productDao.update(product);

            // 3. 创建租赁订单
            Order order = new Order();
            order.setOrderNo(generateOrderNo());
            order.setProductId(productId);
            order.setProductName(product.getName());
            order.setBuyerId(buyerId);
            order.setBuyerName(buyerName);
            order.setSellerId(product.getOwnerId());
            order.setSellerName(product.getOwnerName());
            order.setAmount(rentAmount);
            order.setOrderType(Order.TYPE_RENT);
            order.setRentDays(rentDays);
            order.setRentStartTime(new Date());
            order.setRentEndTime(new Date());

            // 计算租赁结束时间
            Date rentEndTime = new Date(System.currentTimeMillis() + rentDays * 24L * 60 * 60 * 1000);
            order.setRentEndTime(rentEndTime);
            order.setStatus(Order.STATUS_COMPLETED);
            order.setCreateTime(new Date());

            // 4. 保存订单
            return orderDao.insert(order) > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    @Override
    public Double getTotalTransactionAmount() {
        try {
            Double total = orderDao.getTotalTransactionAmount();
            return total != null ? total : 0.0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0; // 出错返回0
        }
    }



    private String generateOrderNo() {
        return "RENT" + System.currentTimeMillis();
    }
}




