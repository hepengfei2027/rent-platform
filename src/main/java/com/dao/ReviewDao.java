package com.dao;

import com.model.Review;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface ReviewDao {
    int insert(Review review);
    List<Review> findByOrderId(Integer orderId);
    List<Review> findByTargetUserId(Integer targetUserId);
    List<Review> findByReviewerId(Integer reviewerId);
    Double getAverageRatingByUserId(Integer userId);
    int getReviewCountByUserId(Integer userId);
}
