package com.service;

import com.model.Review;
import java.util.List;

public interface ReviewService {
    boolean addReview(Review review);
    List<Review> getReviewsByOrder(Integer orderId);
    List<Review> getReviewsByUser(Integer userId);
    boolean addOrderReview(Integer orderId, Integer reviewerId, String reviewerName,
                           Integer targetUserId, String targetUserName,
                           Integer rating, String content, Integer type);
    Double getUserAverageRating(Integer userId);
    int getReviewCount(Integer userId);


}