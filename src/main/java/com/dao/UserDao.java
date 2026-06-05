package com.dao;



import com.model.User;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;

public interface UserDao {
    /**
     * 根据ID查询用户
     */
    User findById(Integer id);

    /**
     * 根据用户名查询用户
     */
    User findByUsername(String username);

    /**
     * 根据手机号查询用户
     */
    User findByPhone(String phone);

    /**
     * 查询所有用户
     */
    List<User> findAll();

    /**
     * 添加用户
     */
    int insert(User user);

    /**
     * 更新用户信息
     */
    int update(User user);

    /**
     * 删除用户（逻辑删除）
     */
    int delete(Integer id);

    /**
     * 用户登录验证
     */
    User login(@Param("phone") String phone, @Param("password") String password);

    /**
     * 更新用户信誉分
     */
    int updateCreditScore(@Param("id") Integer id, @Param("creditScore") Integer creditScore);

    /**
     * 检查手机号是否存在
     */
    int checkPhoneExists(String phone);


    int deductBalance(@Param("userId") Integer userId, @Param("amount") Double amount);
    int addBalance(@Param("userId") Integer userId, @Param("amount") Double amount);

    double getBalance(Integer userId);




    // 管理员功能

    int updateCreditScore(@Param("userId") Integer userId,
                          @Param("creditScore") Integer creditScore,
                          @Param("reason") String reason);
    int banUser(@Param("userId") Integer userId,
                @Param("isBanned") Boolean isBanned,
                @Param("banReason") String banReason,
                @Param("banTime") Date banTime,
                @Param("banEndTime") Date banEndTime);
    int unbanUser(@Param("userId") Integer userId);



}