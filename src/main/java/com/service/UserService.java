package com.service;


import com.model.User;
import java.util.List;

public interface UserService {
    // 用户登录
    User login(String phone, String password);

    // 用户注册
    boolean register(User user);



    // 根据手机号查询用户
    User getUserByPhone(String phone);

    // 查询所有用户
    List<User> getAllUsers();

    // 更新用户信息
    boolean updateUser(User user);

    // 删除用户
    boolean deleteUser(Integer id);

    // 检查手机号是否存在
    boolean isPhoneExists(String phone);

    // 更新用户信誉分
    boolean updateCreditScore(Integer userId, Integer creditScore);


    boolean updateNickname(Integer userId, String nickname);
    User getUserById(Integer id);

    boolean transferBalance(Integer fromUserId, Integer toUserId, double amount);
    double getBalance(Integer userId);

    /**
     * 增加余额（充值）
     */
    boolean addBalance(Integer userId, Double amount);


    // 管理员功能

    boolean deductCreditScore(Integer userId, Integer deductScore, String reason);
    boolean banUser(Integer userId, Integer banDays, String reason);
    boolean unbanUser(Integer userId);
    boolean isUserBanned(Integer userId);




}
