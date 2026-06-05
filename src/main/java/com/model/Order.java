package com.model;

import java.math.BigDecimal;
import java.util.Date;

public class Order {
    private Integer id;
    private String orderNo;
    private Integer productId;
    private String productName;
    private Integer buyerId;
    private String buyerName;
    private Integer sellerId;
    private String sellerName;
    private BigDecimal amount;
    private Integer orderType; //1-购买 2-租赁
    private Integer status; //1-待支付 2-已支付 3-已完成 4-已取消
    private Date createTime;

    // 租赁相关字段（必须存在）
    private Integer rentDays;        // 租赁天数
    private Date rentStartTime;     // 租赁开始时间
    private Date rentEndTime;       // 租赁结束时间


// 常量定义
    public static final int TYPE_BUY = 1;
    public static final int TYPE_RENT = 2;
    public static final int STATUS_COMPLETED = 3;  //已完成
    public static final int STATUS_CANCELED = 4;
    public static final int STATUS_PENDING = 5;
    public static final int STATUS_PAID = 6;
    // Getter和Setter方法

    public Integer getRentDays() { return rentDays; }
    public void setRentDays(Integer rentDays) { this.rentDays = rentDays; }

    public Date getRentStartTime() { return rentStartTime; }
    public void setRentStartTime(Date rentStartTime) { this.rentStartTime = rentStartTime; }

    public Date getRentEndTime() { return rentEndTime; }
    public void setRentEndTime(Date rentEndTime) { this.rentEndTime = rentEndTime; }



    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }
    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public Integer getBuyerId() { return buyerId; }
    public void setBuyerId(Integer buyerId) { this.buyerId = buyerId; }
    public String getBuyerName() { return buyerName; }
    public void setBuyerName(String buyerName) { this.buyerName = buyerName; }
    public Integer getSellerId() { return sellerId; }
    public void setSellerId(Integer sellerId) { this.sellerId = sellerId; }
    public String getSellerName() { return sellerName; }
    public void setSellerName(String sellerName) { this.sellerName = sellerName; }
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    public Integer getOrderType() { return orderType; }
    public void setOrderType(Integer orderType) { this.orderType = orderType; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}