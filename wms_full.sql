-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: wms
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `distributionpoint`
--

DROP TABLE IF EXISTS `distributionpoint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `distributionpoint` (
  `dpid` int NOT NULL AUTO_INCREMENT COMMENT '配送点编号',
  `dpname` varchar(30) NOT NULL COMMENT '名称',
  `dpaddress` varchar(50) DEFAULT NULL COMMENT '地址',
  `dpregion` varchar(20) DEFAULT NULL COMMENT '区域',
  `dptel` varchar(13) DEFAULT NULL COMMENT '电话',
  PRIMARY KEY (`dpid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `distributionpoint`
--

LOCK TABLES `distributionpoint` WRITE;
/*!40000 ALTER TABLE `distributionpoint` DISABLE KEYS */;
INSERT INTO `distributionpoint` VALUES (1,'北辰配送中心','北辰区北仓道1号','北辰区','022-26300001'),(2,'河西配送站','河西区解放南路2号','河西区','022-28300002'),(3,'滨海新区配送站','滨海新区塘沽3号','滨海新区','022-66300003');
/*!40000 ALTER TABLE `distributionpoint` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `eid` int NOT NULL AUTO_INCREMENT COMMENT '员工编号',
  `ename` varchar(20) NOT NULL COMMENT '姓名',
  `esex` char(1) DEFAULT NULL COMMENT '性别',
  `ephone` char(11) DEFAULT NULL COMMENT '电话',
  `etype` varchar(10) NOT NULL COMMENT '岗位',
  `eidcard` char(18) DEFAULT NULL COMMENT '身份证号',
  `estatus` varchar(10) DEFAULT '在职' COMMENT '在职状态',
  PRIMARY KEY (`eid`),
  UNIQUE KEY `eidcard` (`eidcard`),
  CONSTRAINT `ck_etype` CHECK ((`etype` in (_utf8mb4'司机',_utf8mb4'装卸工',_utf8mb4'调度员',_utf8mb4'管理员')))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'赵强','男','13911110001','司机','130100199001010011','在职'),(2,'钱宇','男','13911110002','司机','130100199202020022','在职'),(3,'孙丽','女','13911110003','调度员','130100199503030033','在职');
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `handover`
--

DROP TABLE IF EXISTS `handover`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `handover` (
  `hid` int NOT NULL AUTO_INCREMENT COMMENT '交接单编号',
  `oid` int NOT NULL COMMENT '订单编号',
  `dpid` int DEFAULT NULL COMMENT '交接配送点',
  `eid` int DEFAULT NULL COMMENT '交接员工',
  `hdate` date DEFAULT NULL COMMENT '交接日期',
  `hremark` varchar(100) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`hid`),
  KEY `fk_hov_ord` (`oid`),
  KEY `fk_hov_dp` (`dpid`),
  KEY `fk_hov_emp` (`eid`),
  CONSTRAINT `fk_hov_dp` FOREIGN KEY (`dpid`) REFERENCES `distributionpoint` (`dpid`),
  CONSTRAINT `fk_hov_emp` FOREIGN KEY (`eid`) REFERENCES `employee` (`eid`),
  CONSTRAINT `fk_hov_ord` FOREIGN KEY (`oid`) REFERENCES `orders` (`oid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `handover`
--

LOCK TABLES `handover` WRITE;
/*!40000 ALTER TABLE `handover` DISABLE KEYS */;
INSERT INTO `handover` VALUES (1,2,3,1,'2026-09-06','正常签收'),(2,4,2,2,'2026-10-13','货物完好'),(3,3,2,2,'2026-10-24',NULL);
/*!40000 ALTER TABLE `handover` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `handover_record`
--

DROP TABLE IF EXISTS `handover_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `handover_record` (
  `recordid` int NOT NULL AUTO_INCREMENT COMMENT '记录编号',
  `hid` int NOT NULL COMMENT '交接单编号',
  `rtime` datetime DEFAULT NULL COMMENT '交接时间',
  `rgoods` varchar(30) DEFAULT NULL COMMENT '货物名称',
  `rweight` decimal(8,2) DEFAULT NULL COMMENT '重量(吨)',
  `rsign` char(1) DEFAULT 'N' COMMENT '是否签收',
  `rnote` varchar(100) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`recordid`),
  KEY `fk_rec_hov` (`hid`),
  CONSTRAINT `fk_rec_hov` FOREIGN KEY (`hid`) REFERENCES `handover` (`hid`),
  CONSTRAINT `ck_sign` CHECK ((`rsign` in (_utf8mb4'Y',_utf8mb4'N')))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `handover_record`
--

LOCK TABLES `handover_record` WRITE;
/*!40000 ALTER TABLE `handover_record` DISABLE KEYS */;
INSERT INTO `handover_record` VALUES (1,1,'2026-10-24 16:12:02','食品原料',8.00,'Y','已签收'),(2,1,'2026-10-24 14:12:02','食品原料',8.00,'N','在途'),(3,2,'2026-10-24 16:12:02','机电设备',15.00,'Y','已签收'),(4,3,'2026-10-24 16:41:09','服装',2.00,'N',NULL);
/*!40000 ALTER TABLE `handover_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `oid` int NOT NULL AUTO_INCREMENT COMMENT '订单编号',
  `ocust` varchar(30) NOT NULL COMMENT '客户名称',
  `ocusttel` char(11) DEFAULT NULL COMMENT '客户电话',
  `ostart` int DEFAULT NULL COMMENT '起始配送点',
  `oend` int DEFAULT NULL COMMENT '到达配送点',
  `rid` int DEFAULT NULL COMMENT '使用线路',
  `vid` int DEFAULT NULL COMMENT '使用车辆',
  `eid` int DEFAULT NULL COMMENT '驾驶员',
  `ogoods` varchar(30) NOT NULL COMMENT '货物名称',
  `oweight` decimal(8,2) DEFAULT NULL COMMENT '重量(吨)',
  `oprice` decimal(10,2) DEFAULT NULL COMMENT '配送费用(元)',
  `ostatus` varchar(10) NOT NULL DEFAULT '待受理' COMMENT '状态',
  `odate` date NOT NULL COMMENT '下单日期',
  `oremark` varchar(100) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`oid`),
  KEY `fk_ord_start` (`ostart`),
  KEY `fk_ord_end` (`oend`),
  KEY `fk_ord_route` (`rid`),
  KEY `fk_ord_veh` (`vid`),
  KEY `fk_ord_emp` (`eid`),
  KEY `idx_order_date` (`odate` DESC),
  KEY `idx_order_status` (`ostatus`),
  CONSTRAINT `fk_ord_emp` FOREIGN KEY (`eid`) REFERENCES `employee` (`eid`),
  CONSTRAINT `fk_ord_end` FOREIGN KEY (`oend`) REFERENCES `distributionpoint` (`dpid`),
  CONSTRAINT `fk_ord_route` FOREIGN KEY (`rid`) REFERENCES `route` (`rid`),
  CONSTRAINT `fk_ord_start` FOREIGN KEY (`ostart`) REFERENCES `distributionpoint` (`dpid`),
  CONSTRAINT `fk_ord_veh` FOREIGN KEY (`vid`) REFERENCES `vehicle` (`vid`),
  CONSTRAINT `ck_ostatus` CHECK ((`ostatus` in (_utf8mb4'待受理',_utf8mb4'配送中',_utf8mb4'已送达',_utf8mb4'已取消')))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'恒通商贸','13700000001',1,2,1,1,1,'日用品',3.50,245.00,'配送中','2026-09-01','加急'),(2,'海达食品','13700000002',1,3,2,2,2,'食品原料',8.00,480.00,'配送中','2026-09-05',''),(3,'万佳百货','13700000003',2,3,3,1,1,'服装',2.00,140.00,'配送中','2026-10-10',''),(4,'津西机电','13700000004',1,2,1,2,2,'机电设备',15.00,900.00,'已送达','2026-10-12','');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tri_order_insert` BEFORE INSERT ON `orders` FOR EACH ROW BEGIN
  DECLARE v_s VARCHAR(10);
  SELECT vstatus INTO v_s FROM vehicle WHERE vid=NEW.vid;
  IF v_s IN ('在途','维修') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='该车辆不可用，无法接单';
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tri_order_status` AFTER UPDATE ON `orders` FOR EACH ROW BEGIN
  IF NEW.ostatus='配送中' AND OLD.ostatus<>'配送中' THEN
    UPDATE vehicle SET vstatus='在途' WHERE vid=NEW.vid;
  END IF;
  IF NEW.ostatus='已送达' AND OLD.ostatus<>'已送达' THEN
    UPDATE vehicle SET vstatus='空闲' WHERE vid=NEW.vid;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `price`
--

DROP TABLE IF EXISTS `price`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `price` (
  `priceid` int NOT NULL AUTO_INCREMENT COMMENT '价格编号',
  `plowweight` decimal(6,2) DEFAULT NULL COMMENT '起始重量(吨)',
  `phighweight` decimal(6,2) DEFAULT NULL COMMENT '结束重量(吨)',
  `punitprice` decimal(8,2) NOT NULL COMMENT '单价(元/吨)',
  PRIMARY KEY (`priceid`),
  CONSTRAINT `ck_weight` CHECK ((`plowweight` < `phighweight`))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `price`
--

LOCK TABLES `price` WRITE;
/*!40000 ALTER TABLE `price` DISABLE KEYS */;
INSERT INTO `price` VALUES (1,0.00,1.00,80.00),(2,1.00,5.00,63.00),(3,5.00,20.00,60.00);
/*!40000 ALTER TABLE `price` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `route`
--

DROP TABLE IF EXISTS `route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `route` (
  `rid` int NOT NULL AUTO_INCREMENT COMMENT '线路编号',
  `rname` varchar(30) NOT NULL COMMENT '线路名称',
  `rstart` int NOT NULL COMMENT '起点配送点',
  `rend` int NOT NULL COMMENT '终点配送点',
  `rlen` decimal(8,2) DEFAULT NULL COMMENT '长度(km)',
  `rtime` int DEFAULT NULL COMMENT '预计时间(分钟)',
  PRIMARY KEY (`rid`),
  KEY `fk_route_start` (`rstart`),
  KEY `fk_route_end` (`rend`),
  CONSTRAINT `fk_route_end` FOREIGN KEY (`rend`) REFERENCES `distributionpoint` (`dpid`),
  CONSTRAINT `fk_route_start` FOREIGN KEY (`rstart`) REFERENCES `distributionpoint` (`dpid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `route`
--

LOCK TABLES `route` WRITE;
/*!40000 ALTER TABLE `route` DISABLE KEYS */;
INSERT INTO `route` VALUES (1,'北辰至河西线',1,2,15.50,40),(2,'北辰至滨海线',1,3,55.00,80),(3,'河西至滨海线',2,3,48.00,70);
/*!40000 ALTER TABLE `route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `uid` int NOT NULL AUTO_INCREMENT COMMENT '用户编号',
  `uname` varchar(20) NOT NULL COMMENT '用户名',
  `upwd` varchar(20) NOT NULL COMMENT '密码',
  `urole` varchar(10) NOT NULL DEFAULT '操作员' COMMENT '角色',
  `uphone` char(11) DEFAULT NULL COMMENT '电话',
  PRIMARY KEY (`uid`),
  CONSTRAINT `ck_role` CHECK ((`urole` in (_utf8mb4'管理员',_utf8mb4'调度员',_utf8mb4'操作员')))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'zhang','123456','管理员','13800000001'),(2,'li','123456','调度员','13800000002'),(3,'wang','123456','操作员','13800000003');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_order_detail`
--

DROP TABLE IF EXISTS `v_order_detail`;
/*!50001 DROP VIEW IF EXISTS `v_order_detail`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_order_detail` AS SELECT 
 1 AS `oid`,
 1 AS `ocust`,
 1 AS `ogoods`,
 1 AS `oweight`,
 1 AS `oprice`,
 1 AS `ostatus`,
 1 AS `odate`,
 1 AS `车牌号`,
 1 AS `驾驶员`,
 1 AS `起点`,
 1 AS `终点`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `vehicle`
--

DROP TABLE IF EXISTS `vehicle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehicle` (
  `vid` int NOT NULL AUTO_INCREMENT COMMENT '车辆编号',
  `vno` char(10) NOT NULL COMMENT '车牌号',
  `vtype` varchar(20) DEFAULT NULL COMMENT '车型',
  `vcapacity` decimal(6,2) DEFAULT NULL COMMENT '载重(吨)',
  `vstatus` varchar(10) NOT NULL DEFAULT '空闲' COMMENT '状态',
  `vbuydate` date DEFAULT NULL COMMENT '购置日期',
  PRIMARY KEY (`vid`),
  UNIQUE KEY `vno` (`vno`),
  CONSTRAINT `ck_vstatus` CHECK ((`vstatus` in (_utf8mb4'空闲',_utf8mb4'在途',_utf8mb4'维修',_utf8mb4'停用')))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehicle`
--

LOCK TABLES `vehicle` WRITE;
/*!40000 ALTER TABLE `vehicle` DISABLE KEYS */;
INSERT INTO `vehicle` VALUES (1,'冀A10001','厢式货车',5.00,'空闲','2022-03-01'),(2,'冀A10002','厢式货车',5.00,'在途','2022-05-12'),(3,'冀A20001','半挂车',20.00,'空闲','2021-11-08'),(4,'冀A30001','冷藏车',8.00,'空闲',NULL);
/*!40000 ALTER TABLE `vehicle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'wms'
--
/*!50003 DROP PROCEDURE IF EXISTS `proc_handover_generate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_handover_generate`(IN p_oid INT, IN p_dpid INT, IN p_eid INT)
BEGIN
  DECLARE v_hid INT;
  INSERT INTO handover(oid,dpid,eid,hdate) VALUES(p_oid,p_dpid,p_eid,CURDATE());
  SET v_hid = LAST_INSERT_ID();
  INSERT INTO handover_record(hid,rtime,rgoods,rweight,rsign)
  SELECT v_hid, NOW(), ogoods, oweight, 'N' FROM orders WHERE oid=p_oid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_vehicle_month` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_vehicle_month`(IN p_vid INT, IN p_month VARCHAR(7),
                                    OUT total_weight DECIMAL(10,2), OUT total_fee DECIMAL(12,2))
BEGIN
  SELECT COALESCE(SUM(oweight),0), COALESCE(SUM(oprice),0)
    INTO total_weight, total_fee
  FROM orders
  WHERE vid=p_vid AND DATE_FORMAT(odate,'%Y-%m')=p_month;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_order_detail`
--

/*!50001 DROP VIEW IF EXISTS `v_order_detail`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_order_detail` AS select `o`.`oid` AS `oid`,`o`.`ocust` AS `ocust`,`o`.`ogoods` AS `ogoods`,`o`.`oweight` AS `oweight`,`o`.`oprice` AS `oprice`,`o`.`ostatus` AS `ostatus`,`o`.`odate` AS `odate`,`v`.`vno` AS `车牌号`,`e`.`ename` AS `驾驶员`,`sp`.`dpname` AS `起点`,`ep`.`dpname` AS `终点` from ((((`orders` `o` left join `vehicle` `v` on((`o`.`vid` = `v`.`vid`))) left join `employee` `e` on((`o`.`eid` = `e`.`eid`))) left join `distributionpoint` `sp` on((`o`.`ostart` = `sp`.`dpid`))) left join `distributionpoint` `ep` on((`o`.`oend` = `ep`.`dpid`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-26 18:58:52
