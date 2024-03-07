/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 50558
 Source Host           : localhost:3306
 Source Schema         : finance

 Target Server Type    : MySQL
 Target Server Version : 50558
 File Encoding         : 65001

 Date: 25/03/2021 21:41:20
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for change_money
-- ----------------------------
DROP TABLE IF EXISTS `change_money`;
CREATE TABLE `change_money`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '零钱理财产品 主键id',
  `name` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '理财产品名称',
  `annualIncome` decimal(10, 8) NULL DEFAULT NULL COMMENT '日收益率',
  `peiIncome` decimal(10, 2) NULL DEFAULT NULL COMMENT '每万元收益',
  `invesMoney` decimal(10, 2) NULL DEFAULT NULL COMMENT '起投金额',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of change_money
-- ----------------------------
INSERT INTO `change_money` VALUES (1, '支付宝零钱理财', 0.00003000, 0.30, 100.00);
INSERT INTO `change_money` VALUES (2, '微信零钱理财', 0.00002900, 0.29, 200.00);
INSERT INTO `change_money` VALUES (3, '理财通零钱理财', 0.00002800, 0.28, 300.00);
INSERT INTO `change_money` VALUES (4, '云闪付理财', 0.00002600, 0.26, 500.00);

-- ----------------------------
-- Table structure for flow_of_funds
-- ----------------------------
DROP TABLE IF EXISTS `flow_of_funds`;
CREATE TABLE `flow_of_funds`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '资金记录表 id主键自增',
  `userId` int(10) NULL DEFAULT NULL COMMENT '所属用户',
  `flowMoney` decimal(20, 2) NULL DEFAULT NULL COMMENT '金额',
  `type` int(10) NULL DEFAULT NULL COMMENT '类型（1：支出  2：收入）',
  `source` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '来源',
  `createTime` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `fundDesc` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of flow_of_funds
-- ----------------------------
INSERT INTO `flow_of_funds` VALUES (18, 1, 100.00, 1, '支付宝零钱理财', '2021-02-14 02:21:32', '无');
INSERT INTO `flow_of_funds` VALUES (19, 1, 10000.00, 1, '借贷还款', '2021-02-14 02:21:53', '无');
INSERT INTO `flow_of_funds` VALUES (20, 4, 10000.00, 2, '网贷', '2021-03-03 21:59:48', '');
INSERT INTO `flow_of_funds` VALUES (21, 4, 10000.00, 2, '网贷', '2021-03-03 22:00:23', '');
INSERT INTO `flow_of_funds` VALUES (22, 4, 10000.00, 2, '网贷', '2021-03-03 22:02:03', '');
INSERT INTO `flow_of_funds` VALUES (23, 4, 10000.00, 2, '网贷', '2021-03-03 22:04:35', '');
INSERT INTO `flow_of_funds` VALUES (24, 4, 10000.00, 2, '网贷', '2021-03-03 22:37:53', '');
INSERT INTO `flow_of_funds` VALUES (25, 4, 10000.00, 2, '网贷', '2021-03-03 22:38:02', '');
INSERT INTO `flow_of_funds` VALUES (26, 4, 10000.00, 2, '网贷', '2021-03-03 22:39:38', '');

-- ----------------------------
-- Table structure for loan
-- ----------------------------
DROP TABLE IF EXISTS `loan`;
CREATE TABLE `loan`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '网贷信息表id 主键自增',
  `userId` int(10) NULL DEFAULT NULL COMMENT '借贷人id（用户）',
  `adminId` int(10) NULL DEFAULT NULL COMMENT '审核人id（管理员）',
  `startTime` datetime NULL DEFAULT NULL COMMENT '借贷时间',
  `amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '借贷金额',
  `term` int(20) NULL DEFAULT NULL COMMENT '借贷期限（天）',
  `rate` decimal(10, 8) NULL DEFAULT NULL COMMENT '固定年借贷利率',
  `applyStatus` int(10) NULL DEFAULT NULL COMMENT '申请状态（0：未审核  1：审核未通过  2：审核通过）',
  `loanStatus` int(10) NULL DEFAULT NULL COMMENT '借贷状态（0：未逾期  1：逾期  2：已还请）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of loan
-- ----------------------------
INSERT INTO `loan` VALUES (7, 1, 1, '2021-02-14 01:27:58', 10000.00, 20, 0.15000000, 2, 2);
INSERT INTO `loan` VALUES (8, 1, 1, '2021-02-14 02:03:09', 10000.00, 20, 0.15000000, 2, 2);
INSERT INTO `loan` VALUES (9, 1, 1, '2021-02-14 02:04:39', 10000.00, 20, 0.15000000, 2, 2);
INSERT INTO `loan` VALUES (10, 1, 1, '2021-02-14 02:16:29', 10000.00, 20, 0.15000000, 2, 2);
INSERT INTO `loan` VALUES (11, 1, 1, '2021-02-14 02:21:40', 10000.00, 20, 0.15000000, 2, 2);
INSERT INTO `loan` VALUES (12, 1, 1, '2021-02-16 16:48:02', 10000.00, 20, 0.15000000, 2, 0);
INSERT INTO `loan` VALUES (13, 1, 1, '2021-02-16 17:53:44', 10000.00, 20, 0.15000000, 2, 0);
INSERT INTO `loan` VALUES (14, 1, 1, '2021-02-16 17:59:01', 10000.00, 20, 0.15000000, 1, 0);
INSERT INTO `loan` VALUES (15, 1, 1, '2021-02-16 17:59:05', 10000.00, 20, 0.15000000, 1, 0);
INSERT INTO `loan` VALUES (16, 4, 1, '2021-03-03 19:00:54', 10000.00, 20, 0.15000000, 2, 0);
INSERT INTO `loan` VALUES (17, 4, 1, '2021-03-03 19:34:38', 10000.00, 20, 0.15000000, 2, 0);
INSERT INTO `loan` VALUES (18, 4, 1, '2021-03-03 22:00:12', 10000.00, 20, 0.15000000, 2, 0);
INSERT INTO `loan` VALUES (19, 4, 1, '2021-03-03 22:04:21', 10000.00, 20, 0.15000000, 2, 0);
INSERT INTO `loan` VALUES (20, 4, 1, '2021-03-03 22:34:15', 10000.00, 20, 0.15000000, 2, 0);


-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '用户id 主键自增',
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `realname` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `password` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '登录密码',
  `IDcard` varchar(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `paypwd` int(40) NULL DEFAULT NULL COMMENT '交易密码',
  `status` int(10) NULL DEFAULT NULL COMMENT '用户状态（0：离线   1：在线）',
  `reputation` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户信誉',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'lisi', '李四', 'e10adc3949ba59abbe56e057f20f883e', '110101199703142123', '15188888800', '123123@qq.com', 666666, 0, '良好');
INSERT INTO `user` VALUES (2, 'inmaps', '赵六', 'e10adc3949ba59abbe56e057f20f883e', '110101199608142123', '12345678912', '2333@233.com', 123456, 0, '超级优秀');
INSERT INTO `user` VALUES (3, 'zhangsan', '张四', 'e10adc3949ba59abbe56e057f20f883e', '110101199703142123', '15188888888', '567567@qq.com', 123456, 0, '啥也不是');
INSERT INTO `user` VALUES (4, 'dddd', '阿松大', 'f379eaf3c831b04de153469d1bec345e', '220581199503213516', '15834503333', '78999452@qq.com', 666666, 0, '良好');
INSERT INTO `user` VALUES (6, 'admin0', NULL, 'e10adc3949ba59abbe56e057f20f883e', NULL, NULL, NULL, NULL, 0, '良好');


