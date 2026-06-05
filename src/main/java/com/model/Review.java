package com.model;
import java.util.Date;

public class Review {
    private Integer id;
    private Integer orderId;        // 关联的订单ID
    private Integer reviewerId;      // 评价人ID
    private String reviewerName;     // 评价人姓名
    private Integer targetUserId;    // 被评价人ID
    private String targetUserName;  // 被评价人姓名
    private Integer rating;         // 评分 1-5星
    private String content;         // 评价内容
    private Integer type;           // 评价类型：1-买家评价卖家, 2-卖家评价买家
    private Date createTime;

    // 常量
    public static final int TYPE_BUYER_TO_SELLER = 1;
    public static final int TYPE_SELLER_TO_BUYER = 2;

    // Getter和Setter
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getOrderId() { return orderId; }
    public void setOrderId(Integer orderId) { this.orderId = orderId; }

    public Integer getReviewerId() { return reviewerId; }
    public void setReviewerId(Integer reviewerId) { this.reviewerId = reviewerId; }

    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }

    public Integer getTargetUserId() { return targetUserId; }
    public void setTargetUserId(Integer targetUserId) { this.targetUserId = targetUserId; }

    public String getTargetUserName() { return targetUserName; }
    public void setTargetUserName(String targetUserName) { this.targetUserName = targetUserName; }

    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Integer getType() { return type; }
    public void setType(Integer type) { this.type = type; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}