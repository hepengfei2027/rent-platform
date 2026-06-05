package com.model;

import java.util.Date;

public class User {
    private Integer id;
    private String nickname;     // 昵称
    private String username;     // 账号
    private String password;     // 密码
    private String phone;        // 手机号
    private Integer creditScore; // 信誉分（0-100）
    private String role;         // 角色：user-普通用户, admin-管理员
    private Date createTime;     // 创建时间
    private Date updateTime;     // 更新时间
    private Integer status;      // 状态：1-正常, 0-禁用
    private Double balance;
    private Boolean isBanned; // 是否被封禁
    private String banReason; // 封禁原因
    private Date banTime; // 封禁时间
    private Date banEndTime; // 封禁结束时间



    // 构造方法
    public User() {}

    public User(String nickname, String username, String password, String phone, String role) {
        this.nickname = nickname;
        this.username = username;
        this.password = password;
        this.phone = phone;
        this.role = role;
        this.creditScore = 100; // 默认信誉分100
        this.status = 1;        // 默认状态正常
    }

    // Getter和Setter方法


    public Boolean getBanned() {
        return isBanned;
    }

    public void setBanned(Boolean banned) {
        isBanned = banned;
    }

    public String getBanReason() {
        return banReason;
    }

    public void setBanReason(String banReason) {
        this.banReason = banReason;
    }

    public Date getBanTime() {
        return banTime;
    }

    public void setBanTime(Date banTime) {
        this.banTime = banTime;
    }

    public Date getBanEndTime() {
        return banEndTime;
    }

    public void setBanEndTime(Date banEndTime) {
        this.banEndTime = banEndTime;
    }

    public Double getBalance() {
        return balance;
    }

    public void setBalance(Double balance) {
        this.balance = balance;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Integer getCreditScore() { return creditScore; }
    public void setCreditScore(Integer creditScore) { this.creditScore = creditScore; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public Date getUpdateTime() { return updateTime; }
    public void setUpdateTime(Date updateTime) { this.updateTime = updateTime; }

    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }

    // 判断是否为管理员
    public boolean isAdmin() {
        return "admin".equals(role);
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", nickname='" + nickname + '\'' +
                ", username='" + username + '\'' +
                ", phone='" + phone + '\'' +
                ", creditScore=" + creditScore +
                ", role='" + role + '\'' +
                ", status=" + status +
                '}';
    }
}

