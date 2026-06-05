package com.service.Impl;



import com.dao.UserDao;
import com.model.User;
import com.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public User login(String phone, String password) {
        return userDao.login(phone, password);
    }

    @Override
    public boolean register(User user) {
        // 检查手机号是否已存在
        if (userDao.checkPhoneExists(user.getPhone()) > 0) {
            return false;
        }

        // 设置默认值
        if (user.getCreditScore() == null) {
            user.setCreditScore(100);
        }

        if (user.getRole() == null) {
            user.setRole("user"); // 默认普通用户
        }

        return userDao.insert(user) > 0;
    }


    @Override
    public User getUserByPhone(String phone) {
        return userDao.findByPhone(phone);
    }

    @Override
    public List<User> getAllUsers() {
        return userDao.findAll();
    }

    @Override
    public boolean updateUser(User user) {
        return userDao.update(user) > 0;
    }

    @Override
    public boolean deleteUser(Integer id) {
        return userDao.delete(id) > 0;
    }

    @Override
    public boolean isPhoneExists(String phone) {
        return userDao.checkPhoneExists(phone) > 0;
    }

    @Override
    public boolean updateCreditScore(Integer userId, Integer creditScore) {
        return userDao.updateCreditScore(userId, creditScore) > 0;
    }

    @Override
    public boolean updateNickname(Integer userId, String nickname) {
        try {
            User user = userDao.findById(userId);
            if (user == null) {
                return false;
            }
            user.setNickname(nickname);
            return userDao.update(user) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public User getUserById(Integer id) {
        try {
            return userDao.findById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean transferBalance(Integer fromUserId, Integer toUserId, double amount) {
        try {
            // 1. 检查余额是否足够
            double fromBalance = userDao.getBalance(fromUserId);
            if (fromBalance < amount) {
                return false;
            }

            // 2. 执行余额转移
            userDao.deductBalance(fromUserId, amount);
            userDao.addBalance(toUserId, amount);

            return true;
        } catch (Exception e) {
            throw new RuntimeException("转账失败");
        }
    }

    @Override
    public double getBalance(Integer userId) {
        return userDao.getBalance(userId);
    }


    @Override
    @Transactional
    public boolean addBalance(Integer userId, Double amount) {
        try {
            // 直接调用DAO增加余额
            return userDao.addBalance(userId, amount) > 0;
        } catch (Exception e) {
            throw new RuntimeException("充值失败");
        }
    }

    @Override
    @Transactional
    public boolean deductCreditScore(Integer userId, Integer deductScore, String reason) {
        try {
            User user = userDao.findById(userId);
            if (user == null) return false;

            int newScore = Math.max(0, user.getCreditScore() - deductScore); // 最低0分
            return userDao.updateCreditScore(userId, newScore, reason) > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    @Transactional
    public boolean banUser(Integer userId, Integer banDays, String reason) {
        try {
            Date banTime = new Date();
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(banTime);
            calendar.add(Calendar.DAY_OF_MONTH, banDays);
            Date banEndTime = calendar.getTime();

            return userDao.banUser(userId, true, reason, banTime, banEndTime) > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    @Transactional
    public boolean unbanUser(Integer userId) {
        try {
            return userDao.unbanUser(userId) > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean isUserBanned(Integer userId) {
        try {
            User user = userDao.findById(userId);
            if (user == null || !user.getBanned()) {
                return false;
            }

            // 检查封禁是否过期
            if (user.getBanEndTime() != null && user.getBanEndTime().before(new Date())) {
                // 自动解封过期封禁
                unbanUser(userId);
                return false;
            }

            return user.getBanned();

        } catch (Exception e) {
            return false;
        }
    }


}