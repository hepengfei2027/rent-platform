package com.service.Impl;

import com.dao.ReviewDao;
import com.dao.UserDao;
import com.model.Review;
import com.model.User;
import com.service.ReviewService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@Transactional
public class ReviewServiceImpl implements ReviewService {

    @Autowired
    private ReviewDao reviewDao;

    @Autowired
    private UserDao userDao;

    @Override
    public boolean addReview(Review review) {
        try {
            review.setCreateTime(new java.util.Date());
            boolean result = reviewDao.insert(review) > 0;

            if (result) {
                // 更新被评价用户的信誉分
                updateUserCreditScore(review.getTargetUserId());
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean addOrderReview(Integer orderId, Integer reviewerId, String reviewerName,
                                  Integer targetUserId, String targetUserName,
                                  Integer rating, String content, Integer type) {
        Review review = new Review();
        review.setOrderId(orderId);
        review.setReviewerId(reviewerId);
        review.setReviewerName(reviewerName);
        review.setTargetUserId(targetUserId);
        review.setTargetUserName(targetUserName);
        review.setRating(rating);
        review.setContent(content);
        review.setType(type);

        return addReview(review);
    }

    @Override
    public List<Review> getReviewsByOrder(Integer orderId) {
        try {
            return reviewDao.findByOrderId(orderId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Review> getReviewsByUser(Integer userId) {
        try {
            return reviewDao.findByTargetUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public Double getUserAverageRating(Integer userId) {
        try {
            Double rating = reviewDao.getAverageRatingByUserId(userId);
            return rating != null ? Math.round(rating * 10.0) / 10.0 : 5.0; // 默认5分
        } catch (Exception e) {
            e.printStackTrace();
            return 5.0;
        }
    }

    @Override
    public int getReviewCount(Integer userId) {
        try {
            return reviewDao.getReviewCountByUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * 更新用户信誉分（根据平均评分计算）
     */
    private void updateUserCreditScore(Integer userId) {
        try {
            Double avgRating = getUserAverageRating(userId);
            // 信誉分 = 平均分 * 20（5分制转100分制）
            int creditScore = (int) (avgRating * 20);

            User user = userDao.findById(userId);
            if (user != null) {
                user.setCreditScore(creditScore);
                userDao.update(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}