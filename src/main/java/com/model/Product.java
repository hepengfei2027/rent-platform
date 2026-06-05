package com.model;

import java.math.BigDecimal;
import java.util.Date;

public class Product {
    private Integer id;
    private String name;
    private BigDecimal price;
    private BigDecimal rentPrice;        // 租赁价格/天
    private Integer stock;
    private String description;
    private String category;
    private Integer ownerId;            // 商品所有者ID
    private String ownerName;           // 商品所有者名称
    private Integer status;             // 状态：1-上架, 0-下架, 2-已出租, 3-已售出
    private Integer productType;        // 商品类型：1-出售, 2-出租, 3-可租可售
    private Date createTime;
    private Date updateTime;
    // 添加押金相关字段
    private Double deposit; // 押金金额




    // 状态常量
    public static final int STATUS_ON_SALE = 1;      // 上架
    public static final int STATUS_OFF_SALE = 0;     // 下架
    public static final int STATUS_RENTED = 2;        // 已出租
    public static final int STATUS_SOLD = 3;          // 已售出
    public static final int STATUS_PENDING_REVIEW = 0; // 待审核


    // 构造方法
    public Product() {}

    // Getter和Setter方法

    public Double getDeposit() { return deposit; }
    public void setDeposit(Double deposit) { this.deposit = deposit; }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public BigDecimal getRentPrice() { return rentPrice; }
    public void setRentPrice(BigDecimal rentPrice) { this.rentPrice = rentPrice; }

    public Integer getStock() { return stock; }
    public void setStock(Integer stock) { this.stock = stock; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Integer getOwnerId() { return ownerId; }
    public void setOwnerId(Integer ownerId) { this.ownerId = ownerId; }

    public String getOwnerName() { return ownerName; }
    public void setOwnerName(String ownerName) { this.ownerName = ownerName; }

    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }

    public Integer getProductType() { return productType; }
    public void setProductType(Integer productType) { this.productType = productType; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }

}