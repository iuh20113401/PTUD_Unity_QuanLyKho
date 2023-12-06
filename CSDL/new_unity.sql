-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th12 06, 2023 lúc 02:37 AM
-- Phiên bản máy phục vụ: 10.4.28-MariaDB
-- Phiên bản PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `new_unity`
--

DELIMITER $$
--
-- Thủ tục
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `capNhatSoLuongDonKiemKe` (IN `in_maKiemKe` INT)   BEGIN
	UPDATE kiemke as kk JOIN 
    chitietkiemke as ctkk on ctkk.MaKiemKe = kk.MaKiemKe JOIN
    chitietsanpham as ctsp on ctsp.MaChiTietSanPham = ctkk.MaChiTietSanPham
    SET ctsp.soluongTon = CASE
    WHEN ctkk.TinhTrang = 0 THEN ctsp.SoLuongTon + ctkk.SoLuong
    WHEN ctkk.TinhTrang = 1 THEN ctsp.SoLuongTon - ctkk.SoLuong
    else ctsp.SoLuongTon
    END,
    ctsp.soLuongChoTieuHuy = CASE
    WHEN ctkk.TinhTrang = 2 THEN ctsp.soLuongChoTieuHuy + ctkk.SoLuong
    else ctsp.soLuongChoTieuHuy
    END,
    ctsp.tinhTrang = CASE
    WHEN ctkk.TinhTrang = 2 THEN 2
    else ctsp.tinhTrang 
    END
    WHERE kk.MaKiemKe = in_maKiemKe;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `layChiTietPhieuNhap` (IN `in_MaPhieu` INT)   BEGIN
SELECT ctd.MaSanPham,sp.TenSanPham, ctpn.SoLuong, ctd.DonVi, ctd.NgaySanXuat, ctd.NgayHetHan, pn.MaKho 
FROM phieunhap as pn  JOIN
chitietphieunhap as ctpn on ctpn.MaPhieu = pn.MaPhieu JOIN
chitietdonyeucau as ctd on ctd.MaDon = pn.MaDon and ctd.MaSanPham = ctpn.MaSanPham JOIN 
sanpham as sp on sp.MaSanPHam = ctd.MaSanPham 
WHERE pn.MaPhieu = in_MaPhieu;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `layChiTietPhieuXuat` (IN `in_MaPhieu` INT)   BEGIN
SELECT ctpx.MaChiTietSanPham,ctsp.MaSanPham,sp.TenSanPham, ctpx.SoLuong, ctsp.DonVi, ctsp.NgaySanXuat, ctsp.NgayHetHan 
FROM phieuxuat as px join 
chitietphieuxuat as ctpx on ctpx.MaPhieu = px.MaPhieu JOIN 
chitietsanpham as ctsp on ctsp.MaChiTietSanPham = ctpx.MaChiTietSanPham JOIN
sanpham as sp on sp.MaSanPHam = ctsp.MaSanPham 
WHERE px.MaPhieu = in_MaPhieu;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `layDonYeuCauDaDuyet` ()   BEGIN
	SELECT DISTINCT tk.TenDangNhap, d.MaDon, d.MaLoai,d.MaTaiKhoan, TenLoai,NgayLap, d.TrangThai,d.SoLuong as soluongnguyenlieu
FROM donyeucau as d JOIN chitietdonyeucau as ctd on ctd.MaDon = d.MaDon JOIN loaidon as ld on d.MaLoai = ld.MaLoai JOIN taikhoan as tk on tk.MaTaiKhoan = d.MaTaiKhoan WHERE (d.MaLoai = 1 or d.MaLoai = 3) AND TrangThai = "Đã duyệt";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `layDonYeuCauTheoMaDon` (IN `in_MaDon` INT)   BEGIN	
	SELECT TenDangNhap, d.MaDon, d.MaLoai,d.MaTaiKhoan, TenLoai,NgayLap, d.TrangThai,ctd.MaSanPham, sp.TenSanPham, ctd.SoLuong,sp.DonVi, ctd.NgaySanXuat, ctd.NgayHetHan FROM donyeucau as d JOIN chitietdonyeucau as ctd on d.MaDon = ctd.MaDon JOIN sanpham as sp on sp.MaSanPham = ctd.MaSanPham JOIN loaidon as ld on ld.MaLoai = d.MaLoai JOIN taikhoan as tk on tk.MaTaiKhoan = d.MaTaiKhoan WHERE ctd.MaDon = in_MaDon;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `layDonYeuCauTheoTaiKhoan` (IN `in_MaTaiKhoan` INT)   BEGIN	
	SELECT d.MaDon, d.MaLoai,MaTaiKhoan, TenLoai,NgayLap, d.TrangThai,ctd.MaSanPham, sp.TenSanPham, ctd.SoLuong,ctd.DonVi, ctd.NgaySanXuat, ctd.NgayHetHan FROM donyeucau as d JOIN chitietdonyeucau as ctd on d.MaDon = ctd.MaDon JOIN sanpham as sp on sp.MaSanPham = ctd.MaSanPham JOIN loaidon as ld on ld.MaLoai = d.MaLoai WHERE d.MaTaiKhoan = in_MaTaiKhoan AND (d.TrangThai ="Đã nhập kho" or d.TrangThai = "Đã xuất kho" or d.TrangThai = 'Hủy');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `layDonYeuCauXuatDaDuyet` ()   BEGIN
	SELECT DISTINCT tk.TenDangNhap,d.MaDon, d.MaLoai,d.MaTaiKhoan, TenLoai,NgayLap, d.TrangThai, d.soluong as soluongnguyenlieu
FROM donyeucau as d JOIN chitietdonyeucau as ctd on ctd.MaDon = d.MaDon JOIN loaidon as ld on d.MaLoai = ld.MaLoai JOIN taikhoan as tk on tk.MaTaiKhoan = d.MaTaiKhoan 
WHERE (d.MaLoai = 2 or d.MaLoai = 4) AND d.TrangThai = "Đã duyệt";
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `layPhieuNhapKhoTheoKho` (IN `in_MaTaiKhoan` INT, IN `in_maKho` INT, IN `in_trangThai` VARCHAR(255))   BEGIN
	SELECT DISTINCT pn.MaPhieu,d.MaDon,ctpn.NgayNhap, ctpn.TrangThai, pn.MaKho, d.MaLoai,pn.MaTaiKhoan,pn.NgayLap,  CASE WHEN count(DISTINCT ctpn.MaSanPham) > 0 THEN COUNT(DISTINCT ctpn.MaSanPham) ELSE null END as soluongnguyenlieu, 
    CASE 
    	WHEN d.MaLoai = 1 THEN "Phiếu nhập kho nguyên liệu"
        ELSE  "Phiếu nhập kho thành phẩm"
    END as TenLoai
    FROM donyeucau as d JOIN 
    phieunhap as pn on pn.MaDon = d.MaDon join
    loaidon as ld on d.MaLoai = ld.MaLoai JOIN
    chitietdonyeucau as ctd on ctd.MaDon = d.MaDon JOIN
    chitietphieunhap as ctpn on ctpn.MaPhieu = pn.MaPhieu
    WHERE  (pn.MaTaiKhoan = in_MaTaiKhoan or pn.MaKho = in_maKho)  and  pn.TrangThai = in_trangThai
    GROUP BY  pn.MaPhieu;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `layPhieuXuatKhoTheoKho` (IN `in_MaTaiKhoan` INT, IN `in_maKho` INT, IN `in_trangThai` VARCHAR(255))   BEGIN
	SELECT DISTINCT px.MaPhieu,d.MaDon, d.MaLoai,px.MaTaiKhoan,px.NgayLap, px.TrangThai,px.NgayXuat, px.MaKho, CASE WHEN count(*) > 0 THEN COUNT(*) ELSE null END as soluongnguyenlieu, 
    CASE 
    	WHEN d.MaLoai = 2 THEN "Phiếu xuất kho nguyên liệu"
        ELSE  "Phiếu xuất kho thành phẩm"
    END as TenLoai
FROM donyeucau as d JOIN 
phieuxuat as px on px.MaDon = d.MaDon join
loaidon as ld on d.MaLoai = ld.MaLoai JOIN
chitietphieuxuat as ctpx on ctpx.MaPhieu = px.MaPhieu
WHERE (px.MaTaiKhoan = in_MaTaiKhoan or px.MaKho = in_maKho) and px.TrangThai = in_trangThai
GROUP BY px.MaPhieu,d.MaDon, d.MaLoai,px.MaTaiKhoan,px.NgayLap, px.TrangThai;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `phanQuyen` ()   BEGIN
    DECLARE i, n,v_MaVaiTro INT DEFAULT 0;
    DECLARE  v_code, v_tenBang, v_tenVaiTro VARCHAR(255);
    SET n = (SELECT COUNT(*) FROM vaitro_quyen);
    
    WHILE i < n DO
        SELECT v.MaVaiTro, q.code, b.tenBang, v.tenVaiTro
        INTO v_MaVaiTro,v_code, v_tenBang, v_tenVaiTro
        FROM vaitro_quyen as vq 
        JOIN vaitro as v ON v.MaVaiTro = vq.MaVaiTro 
        JOIN quyen as q ON q.MaQuyen = vq.MaQuyen 
        JOIN bang as b ON b.MaBang = vq.MaBang 
        LIMIT i, 1;
        
        SET @grant_query = CONCAT(
            'GRANT ', v_code, ' ON new_unity.', v_tenBang, 
            ' TO ', v_tenVaiTro, '@localhost'
        );
        
        IF v_MaVaiTro = 2 THEN
            SET @grant_query = CONCAT(@grant_query, ' WITH GRANT OPTION;');
        ELSE
            SET @grant_query = CONCAT(@grant_query, ';');
        END IF;
        
        PREPARE stmt FROM @grant_query;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET i = i + 1;
    END WHILE;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tieuHuyChiTietSanPham` (IN `in_MaChiTietSanPham` INT)   BEGIN
	UPDATE 
    chitietsanpham as ctsp JOIN 
    sanpham as sp on ctsp.MaSanPHam = sp.MaSanPham JOIN
    kho as k on k.MaKho = ctsp.MaKho
    SET 
    ctsp.soLuongDaTieuHuy = ctsp.soLuongDaTieuHuy + ctsp.soLuongChoTieuHuy,
    ctsp.SoLuongTon = ctsp.SoLuongTon - ctsp.soLuongChoTieuHuy,
    ctsp.soLuongChoTieuHuy = 0,
    sp.SoLuongTon = sp.SoLuongTon - ctsp.soLuongChoTieuHuy,
    k.SucChuaDaDung = k.SucChuaDaDung - ctsp.soLuongChoTieuHuy
    WHERE ctsp.MaChiTietSanPham = in_MaChiTietSanPham;
    
    UPDATE 
    chitietsanpham as ctsp JOIN 
    sanpham as sp on ctsp.MaSanPHam = sp.MaSanPham JOIN
    kho as k on k.MaKho = ctsp.MaKho
    SET 
    ctsp.tinhTrang = CASE
    WHEN  ctsp.SoLuongTon - ctsp.soLuongChoTieuHuy > 0 THEN 0 
    ELSE 3
    END
    WHERE ctsp.MaChiTietSanPham = in_MaChiTietSanPham;
    
	UPDATE phieuxuat as px JOIN
    chitietphieuxuat as ctpx on ctpx.MaPhieu = px.MaPhieu JOIN
    chitietsanpham as ctsp on ctsp.MaChiTietSanPham = ctpx.MaChiTietSanPham JOIN
    sanpham as sp on sp.MaSanPham = ctsp.MaSanPHam JOIN
    donyeucau as d on d.MaDon = px.MaDon 
    SET 
    sp.SoLuongChoXuat  = 
    CASE 
    WHEN px.TrangThai = "Chờ xuất" THEN  sp.SoLuongChoXuat - ctpx.soLuong 
    ELSE sp.SoLuongChoXuat END,
    px.TrangThai = 
    CASE 
    WHEN px.TrangThai = "Chờ xuất" THEN "Đã hủy" 
    ELSE px.TrangThai END,
    d.TrangThai = 
    CASE 
    WHEN px.TrangThai = "Chờ xuất" THEN "Đã hủy" 
    ELSE d.TrangThai END
    WHERE ctsp.MaChiTietSanPham = in_MaChiTietSanPham;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `xacNhanNhapKho` (IN `in_maPhieu` INT)   BEGIN
    update  phieunhap  as pn JOIN
	chitietphieunhap as ctpn on ctpn.MaPhieu = pn.MaPhieu JOIN
	sanpham as sp on sp.MaSanPHam = ctpn.MaSanPham 
    SET sp.SoLuongTon = sp.SoLuongTon + ctpn.SoLuong, 
    sp.SoLuongChoNhap = sp.SoLuongChoNhap - ctpn.SoLuong,
    ctpn.trangThai  ='Đã nhập kho',
    pn.TrangThai = "Đã nhập kho"
    WHERE pn.MaPhieu = in_maPhieu ;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `xacNhanXuatKho` (IN `in_MaPhieu` INT)   BEGIN
UPDATE phieuxuat as px JOIN
chitietphieuxuat as ctpx on ctpx.MaPhieu = px.MaPhieu JOIN
chitietsanpham as ctsp on ctsp.MaChiTietSanPham = ctpx.MaChiTietSanPham JOIN
sanpham as sp on sp.MaSanPham = ctsp.MaSanPHam
SET sp.SoLuongTon = sp.SoLuongTon - ctpx.SoLuong,
    sp.SoLuongChoXuat = sp.SoLuongChoXuat - ctpx.SoLuong,
    ctsp.SoLuongTon = ctsp.SoLuongTon - ctpx.SoLuong,
    ctsp.soluongchoxuat = ctsp.soluongchoxuat - ctpx.SoLuong
WHERE px.MaPhieu = in_MaPhieu;

UPDATE kho as k JOIN (SELECT px.MaKho, SUM(ctpx.SoLuong) as soluong 
                  FROM  phieuxuat as px
                  JOIN chitietphieuxuat as ctpx on ctpx.MaPhieu = px.MaPhieu 
                  WHERE  px.MaPhieu = in_MaPhieu
                  GROUP by px.MaPhieu ) as ct on ct.MaKho = k.MaKho
SET k.SucChuaDaDung = k.SucChuaDaDung - ct.soluong;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `xemSanPhamTheoKho` (IN `in_loai` VARCHAR(255), IN `in_MaKho` INT)   BEGIN
	SELECT sp.MaSanPHam, sp.TenSanPham, ctsp.MaChiTietSanPham, ctsp.SoLuongTon, ctsp.NgaySanXuat, ctsp.NgayHetHan, ctsp.MaKho 
    FROM kho as k JOIN 
    chitietsanpham as ctsp on ctsp.MaKho = k.MaKho JOIN 
    sanpham as sp on sp.MaSanPHam = ctsp.MaSanPHam
    WHERE ctsp.MaKho = in_MaKho and sp.Loai = in_loai;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bang`
--

CREATE TABLE `bang` (
  `MaBang` int(11) NOT NULL,
  `TenBang` varchar(255) NOT NULL,
  `MoTa` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `bang`
--

INSERT INTO `bang` (`MaBang`, `TenBang`, `MoTa`) VALUES
(1, 'BienBan', 'Chứa thông tin biên bản. Bao gồm mã, đơn bị lập và lý do lập'),
(2, 'ChiTietCongThuc', 'Chứa thông tin về danh sách nguyên liệu có trong công thức'),
(3, 'ChiTietDonYeuCau', 'Bảng chứa thông tin chi tiết về đơn yêu cầu, bao gồm thông tin về danh sách sản phẩm có trong đơn, ngày sản xuất, ngày hết hạn của sản phẩm…'),
(4, 'ChiTietKiemKe', 'Chi tiết phiếu kiểm kê'),
(5, 'ChiTietPhieuXuat', 'Chi tiết về phiếu xuất kho, gồm số mã chi tiết sản phẩm và số lượng cần xuất'),
(6, 'ChiTietSanPham', 'Chứa thông tin danh sách chi tiết từng nguyên liệu trong kho.'),
(7, 'CongThuc', 'Chứa thôn tin công thức'),
(8, 'DonYeuCau', 'Bảng chứa thông tin của đơn yêu cầu.'),
(9, 'Kho', 'Thông tin về kho bao gồm mã, tên, vị trí thực tế, sức chứa, sức chứa đã dùng, loại…'),
(10, 'KiemKe', 'Thông tin về phiếu kiểm kê nguyên liệu/ thành phẩm trong kho'),
(11, 'LoaiDon', 'Bảng chứa thống tin của các loại đơn yêu cầu trong hệ thống bao gồm Mã loại, tên loại, và mô tả'),
(12, 'PhieuNhap', 'Thông tin về các phiếu nhập kho'),
(13, 'PhieuXuat', 'Thông tin về các phiếu xuất kho'),
(14, 'SanPham', 'Chứa thông tin về sản phẩm bao gồm mã, tên, số lượng tồn, số lượng chờ xuất, nhập…'),
(15, 'TaiKhoan', 'Thôn tin về tài khoản người dùng'),
(16, 'VaiTro', 'Chứa thông tin về các vai trò có trong hệ thống');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bienban`
--

CREATE TABLE `bienban` (
  `MaBienBan` int(10) NOT NULL,
  `MaDon` int(10) NOT NULL,
  `MaTaiKhoan` int(10) NOT NULL,
  `NgayLap` date NOT NULL,
  `LyDo` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `bienban`
--

INSERT INTO `bienban` (`MaBienBan`, `MaDon`, `MaTaiKhoan`, `NgayLap`, `LyDo`) VALUES
(781, 104112324, 2, '2023-12-04', 'Thiếu đường 100KG');

--
-- Bẫy `bienban`
--
DELIMITER $$
CREATE TRIGGER `lapBienBan` AFTER INSERT ON `bienban` FOR EACH ROW BEGIN
	UPDATE donyeucau as d JOIN 
    chitietdonyeucau as ctd on ctd.MaDon = d.MaDon JOIN
    sanpham as sp on sp.MaSanPham = ctd.MaSanPham 
    SET d.TrangThai = 'Lập biên bản',
    sp.SoLuongChoNhap = sp.SoLuongChoNhap - ctd.SoLuong
    WHERE d.MaDon = NEW.MaDon;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietcongthuc`
--

CREATE TABLE `chitietcongthuc` (
  `MaCongThuc` int(10) NOT NULL,
  `MaSanPHam` int(10) NOT NULL,
  `SoLuong` float(10,5) NOT NULL,
  `DonVi` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietcongthuc`
--

INSERT INTO `chitietcongthuc` (`MaCongThuc`, `MaSanPHam`, `SoLuong`, `DonVi`) VALUES
(22263817, 16470341, 5.00000, 'KG'),
(22263817, 19694585, 1.00000, 'KG'),
(24607429, 12177543, 0.50000, 'KG'),
(24607429, 19694585, 2.00000, 'KG'),
(25495711, 17692725, 0.80000, 'KG'),
(25495711, 19694585, 3.00000, 'KG');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietdonyeucau`
--

CREATE TABLE `chitietdonyeucau` (
  `MaDon` int(10) NOT NULL,
  `MaSanPham` int(10) NOT NULL,
  `SoLuong` float(10,5) NOT NULL,
  `DonVi` varchar(255) NOT NULL,
  `NgaySanXuat` date DEFAULT NULL,
  `NgayHetHan` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietdonyeucau`
--

INSERT INTO `chitietdonyeucau` (`MaDon`, `MaSanPham`, `SoLuong`, `DonVi`, `NgaySanXuat`, `NgayHetHan`) VALUES
(104112313, 12177543, 50.00000, 'KG', '2023-11-08', '2024-01-24'),
(104112313, 16470341, 500.00000, 'KG', '2023-11-01', '2024-03-07'),
(104112313, 19694585, 300.00000, 'KG', '2023-11-08', '2024-02-24'),
(104112324, 16470341, 500.00000, 'KG', NULL, NULL),
(104112324, 19694585, 100.00000, 'KG', NULL, NULL),
(104112379, 15725002, 50.00000, 'KG', '2023-11-15', '2024-01-04'),
(104112379, 17170391, 50.00000, 'KG', '2023-11-08', '2024-01-26'),
(104112379, 17692725, 50.00000, 'KG', '2023-11-08', '2024-02-02'),
(204112312, 12177543, 50.00000, 'KG', NULL, NULL),
(204112312, 16470341, 250.00000, 'KG', NULL, NULL),
(204112312, 19694585, 250.00000, 'KG', NULL, NULL),
(204112358, 22263817, 100.00000, 'Thùng', '2023-11-08', '2024-02-15'),
(204112358, 24607429, 100.00000, 'Hộp', '2023-10-26', '2024-01-25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietkiemke`
--

CREATE TABLE `chitietkiemke` (
  `MaKiemKe` int(10) NOT NULL,
  `MaChiTietSanPham` int(10) NOT NULL,
  `TinhTrang` int(255) NOT NULL,
  `SoLuong` int(11) NOT NULL,
  `MoTa` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Bẫy `chitietkiemke`
--
DELIMITER $$
CREATE TRIGGER `themChiTietKiemKE` AFTER INSERT ON `chitietkiemke` FOR EACH ROW BEGIN
	UPDATE chitietsanpham as ctsp JOIN
    sanpham as sp on sp.MaSanPham = ctsp.MaSanPHam JOIN
    kho as k on k.MaKho = ctsp.MaKho
    SET ctsp.tinhTrang = 1,
    sp.SoLuongChoXuat = sp.SoLuongChoXuat - new.SoLuong,
    ctsp.soLuongChoXuat = ctsp.soLuongChoXuat + new.SoLuong
    WHERE ctsp.MaChiTietSanPham = new.MaChiTietSanPham;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietphieunhap`
--

CREATE TABLE `chitietphieunhap` (
  `MaPhieu` int(11) NOT NULL,
  `MaSanPham` int(11) NOT NULL,
  `SoLuong` float(11,5) NOT NULL,
  `trangThai` varchar(255) NOT NULL,
  `NgayNhap` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietphieunhap`
--

INSERT INTO `chitietphieunhap` (`MaPhieu`, `MaSanPham`, `SoLuong`, `trangThai`, `NgayNhap`) VALUES
(10412237, 12177543, 50.00000, 'Đã nhập kho', NULL),
(10412237, 16470341, 250.00000, 'Đã nhập kho', NULL),
(10412237, 19694585, 100.00000, 'Đã nhập kho', NULL),
(10412406, 22263817, 100.00000, 'Đã nhập kho', NULL),
(10412406, 24607429, 100.00000, 'Đã nhập kho', NULL),
(10412531, 15725002, 50.00000, 'Đã nhập kho', NULL),
(10412531, 17170391, 50.00000, 'Đã nhập kho', NULL),
(10412531, 17692725, 50.00000, 'Đã nhập kho', NULL),
(10412581, 16470341, 250.00000, 'Đã nhập kho', NULL),
(10412581, 19694585, 200.00000, 'Đã nhập kho', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietphieuxuat`
--

CREATE TABLE `chitietphieuxuat` (
  `MaPhieu` int(10) NOT NULL,
  `MaChiTietSanPham` int(10) NOT NULL,
  `SoLuong` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietphieuxuat`
--

INSERT INTO `chitietphieuxuat` (`MaPhieu`, `MaChiTietSanPham`, `SoLuong`) VALUES
(10412223, 1341658794, 100),
(10412223, 1585981225, 150),
(10412719, 1341843136, 150),
(10412719, 1543121439, 50),
(10412719, 1585127966, 100);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chitietsanpham`
--

CREATE TABLE `chitietsanpham` (
  `MaChiTietSanPham` int(10) NOT NULL,
  `MaSanPHam` int(10) NOT NULL,
  `MaPhieuNhap` int(11) NOT NULL,
  `MaKho` int(10) NOT NULL,
  `SoLuongTon` float(10,5) NOT NULL,
  `Donvi` varchar(255) NOT NULL,
  `Giá` int(11) NOT NULL,
  `NgaySanXuat` date NOT NULL,
  `NgayHetHan` date NOT NULL,
  `soLuongChoXuat` float(10,5) NOT NULL,
  `soLuongChoTieuHuy` float(10,5) NOT NULL,
  `soLuongDaTieuHuy` float(10,5) NOT NULL,
  `tinhTrang` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `chitietsanpham`
--

INSERT INTO `chitietsanpham` (`MaChiTietSanPham`, `MaSanPHam`, `MaPhieuNhap`, `MaKho`, `SoLuongTon`, `Donvi`, `Giá`, `NgaySanXuat`, `NgayHetHan`, `soLuongChoXuat`, `soLuongChoTieuHuy`, `soLuongDaTieuHuy`, `tinhTrang`) VALUES
(24291271, 24607429, 10412406, 347, 100.00000, 'Hộp', 0, '2023-10-26', '2024-01-25', 0.00000, 0.00000, 0.00000, 0),
(28171272, 22263817, 10412406, 347, 100.00000, 'Thùng', 0, '2023-11-08', '2024-02-15', 0.00000, 0.00000, 0.00000, 0),
(1002421371, 15725002, 10412531, 847, 50.00000, 'KG', 0, '2023-11-15', '2024-01-04', 0.00000, 0.00000, 0.00000, 0),
(1341658794, 16470341, 10412581, 611, 250.00000, 'KG', 0, '2023-11-01', '2024-03-07', 100.00000, 0.00000, 0.00000, 0),
(1341843136, 16470341, 10412237, 698, 100.00000, 'KG', 0, '2023-11-01', '2024-03-07', 0.00000, 0.00000, 0.00000, 0),
(1391827223, 17170391, 10412531, 847, 50.00000, 'KG', 0, '2023-11-08', '2024-01-26', 0.00000, 0.00000, 0.00000, 0),
(1543121439, 12177543, 10412237, 698, 0.00000, 'KG', 0, '2023-11-08', '2024-01-24', 0.00000, 0.00000, 0.00000, 0),
(1585127966, 19694585, 10412237, 698, 0.00000, 'KG', 0, '2023-11-08', '2024-02-24', 0.00000, 0.00000, 0.00000, 0),
(1585981225, 19694585, 10412581, 611, 200.00000, 'KG', 0, '2023-11-08', '2024-02-24', 150.00000, 0.00000, 0.00000, 0),
(1725227593, 17692725, 10412531, 847, 50.00000, 'KG', 0, '2023-11-08', '2024-02-02', 0.00000, 0.00000, 0.00000, 0);

--
-- Bẫy `chitietsanpham`
--
DELIMITER $$
CREATE TRIGGER `tangSoLuongDaDungKho` BEFORE INSERT ON `chitietsanpham` FOR EACH ROW BEGIN
		UPDATE kho 
        SET SucChuaDaDung = SucChuaDaDung + NEW.SoLuongTon
        WHERE kho.MaKho = New.MaKho;
    END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `congthuc`
--

CREATE TABLE `congthuc` (
  `MaCongThuc` int(10) NOT NULL,
  `TenCongThuc` varchar(255) NOT NULL,
  `DonVi` varchar(255) NOT NULL,
  `SoLuongNguyenLieu` int(10) NOT NULL,
  `MoTa` varchar(255) NOT NULL,
  `trangThai` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `congthuc`
--

INSERT INTO `congthuc` (`MaCongThuc`, `TenCongThuc`, `DonVi`, `SoLuongNguyenLieu`, `MoTa`, `trangThai`) VALUES
(22263817, 'Bánh mì', 'Thùng', 2, 'Một thùng bánh mì gồm 100 cái bánh mì', 1),
(24607429, 'Bánh hạnh nhân', 'Hộp', 2, 'Bánh làm từ bộ mì và hạnh nhân ', 1),
(25495711, 'Bánh đậu xanh', 'Hộp', 2, 'Bánh làm từ bột mì và nhân đậu xanh', 1);

--
-- Bẫy `congthuc`
--
DELIMITER $$
CREATE TRIGGER `themCongThuc` AFTER INSERT ON `congthuc` FOR EACH ROW BEGIN
	INSERT sanpham VALUES (new.MaCongThuc, new.TenCongThuc, 0, new.DonVi, 0,0, "Thành phẩm");
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `donyeucau`
--

CREATE TABLE `donyeucau` (
  `MaDon` int(10) NOT NULL,
  `MaLoai` int(10) NOT NULL,
  `MaTaiKhoan` int(10) NOT NULL,
  `NgayLap` date NOT NULL,
  `SoLuong` int(10) NOT NULL,
  `TrangThai` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `donyeucau`
--

INSERT INTO `donyeucau` (`MaDon`, `MaLoai`, `MaTaiKhoan`, `NgayLap`, `SoLuong`, `TrangThai`) VALUES
(210, 2, 350, '2023-11-28', 2, 'Đã duyệt'),
(213, 2, 350, '2023-11-30', 2, 'Đã duyệt'),
(855, 2, 350, '2023-11-30', 2, 'Đã duyệt'),
(870, 4, 657, '2023-11-30', 1, 'Đã duyệt'),
(10211230, 1, 892, '2023-12-02', 2, 'Đã phân phối'),
(102112396, 1, 892, '2023-12-02', 2, 'Đã nhập kho'),
(104112313, 1, 892, '2023-12-04', 3, 'Đã nhập kho'),
(104112324, 1, 892, '2023-12-04', 2, 'Lập biên bản'),
(104112379, 1, 892, '2023-12-04', 3, 'Đã nhập kho'),
(204112312, 2, 350, '2023-12-04', 3, 'Đã xuất kho'),
(204112358, 3, 350, '2023-12-04', 2, 'Đã nhập kho'),
(1028102317, 1, 892, '2023-11-28', 2, 'Đã nhập kho'),
(1028102320, 1, 892, '2023-11-28', 2, 'Lập biên bản'),
(1028102387, 1, 892, '2023-11-28', 2, 'Đã nhập kho'),
(1030102362, 1, 892, '2023-11-30', 2, 'Đã nhập kho'),
(1030102371, 1, 892, '2023-11-30', 2, 'Đã nhập kho'),
(2030102337, 3, 350, '2023-11-30', 1, 'Chờ duyệt'),
(2030102352, 2, 350, '2023-11-30', 2, 'Đã xuất kho');

--
-- Bẫy `donyeucau`
--
DELIMITER $$
CREATE TRIGGER `chanCapNhatDon` BEFORE UPDATE ON `donyeucau` FOR EACH ROW BEGIN
	DECLARE new_trangthai varchar(255);
    SELECT TrangThai into new_trangthai FROM donyeucau WHERE MaDon = New.MaDon;
    if new_trangthai = "Đã hủy" THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Đơn yêu cầu đã bị hủy không thể cập nhật!';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `kho`
--

CREATE TABLE `kho` (
  `MaKho` int(10) NOT NULL,
  `TenKho` varchar(255) NOT NULL,
  `ViTri` varchar(255) NOT NULL,
  `MoTa` varchar(255) NOT NULL,
  `SucChua` int(10) NOT NULL,
  `SucChuaDaDung` int(10) NOT NULL,
  `Loai` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `kho`
--

INSERT INTO `kho` (`MaKho`, `TenKho`, `ViTri`, `MoTa`, `SucChua`, `SucChuaDaDung`, `Loai`) VALUES
(347, 'Kho thành phẩm 2', 'Số 10 lê lơi', 'Kho dùng để chứa thành phẩm 2', 1000, 200, 'Thành phẩm'),
(455, 'Kho thành phẩm 1', 'Số 9 lê lơi', 'Kho dùng để chứa thành phẩm 1', 1000, 0, 'Thành phẩm'),
(611, 'Kho nguyên liệu 2', 'Số 7 lê lợi ', 'Kho dung để chứa nguyên vật liệu để sản xuất 2', 1000, 450, 'Nguyên liệu'),
(694, 'Kho thành phẩm 3', 'Số 100 lê lợi', 'Kho dùng để chứa thành phẩm 3', 1000, 0, 'Thành phẩm'),
(698, 'Kho nguyên liệu 1', 'Số 6 lê lơi', 'Kho dùng để chứa nguyên liệu ', 1000, 100, 'Nguyên liệu'),
(847, 'Kho nguyên liệu 4', 'Số 100 lê lợi', 'Kho dùng để chứa nguyên liệu 4', 1000, 150, 'Nguyên liệu'),
(899, 'Kho nguyên liệu 6', 'số 100 lê lợi', 'Kho dùng để chứa nguyên liệu 5', 1000, 0, 'Kho đã hủy');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `kiemke`
--

CREATE TABLE `kiemke` (
  `MaKiemKe` int(10) NOT NULL,
  `MaTaiKhoan` int(11) NOT NULL,
  `NgayLap` date NOT NULL,
  `TinhTrang` int(255) NOT NULL,
  `Kho` int(11) NOT NULL,
  `Loai` int(11) NOT NULL,
  `MoTa` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `loaidon`
--

CREATE TABLE `loaidon` (
  `MaLoai` int(10) NOT NULL,
  `TenLoai` varchar(255) NOT NULL,
  `MoTa` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `loaidon`
--

INSERT INTO `loaidon` (`MaLoai`, `TenLoai`, `MoTa`) VALUES
(1, 'Đơn yêu cầu nhập kho nguyên liệu', 'Phiếu nhập kho nguyên vật liệu do ban giám đốc yêu cầu'),
(2, 'Đơn yêu cầu xuất kho nguyên liệu', 'Phiếu xuất kho nguyên liệu do bộ phận sản xuất yêu cầu'),
(3, 'Đơn yêu cầu nhập thành phẩm', 'Đơn do bên bộ phận sản xuất yêu cầu nhập thành phẩm đã hoàn tất vào kho'),
(4, 'Đơn yêu cầu xuất thành phẩm', 'Đơn do bộ phận bán hàng lập yêu cầu xuất thành phẩm để bán hàng');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phieunhap`
--

CREATE TABLE `phieunhap` (
  `MaPhieu` int(10) NOT NULL,
  `MaDon` int(10) NOT NULL,
  `MaKho` int(11) NOT NULL,
  `MaTaiKhoan` int(10) NOT NULL,
  `NgayLap` date NOT NULL,
  `TrangThai` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `phieunhap`
--

INSERT INTO `phieunhap` (`MaPhieu`, `MaDon`, `MaKho`, `MaTaiKhoan`, `NgayLap`, `TrangThai`) VALUES
(10412237, 104112313, 698, 2, '2023-12-04', 'Đã nhập kho'),
(10412406, 204112358, 347, 2, '2023-12-04', 'Đã nhập kho'),
(10412531, 104112379, 847, 2, '2023-12-04', 'Đã nhập kho'),
(10412581, 104112313, 611, 2, '2023-12-04', 'Đã nhập kho');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phieuxuat`
--

CREATE TABLE `phieuxuat` (
  `MaPhieu` int(10) NOT NULL,
  `MaDon` int(10) NOT NULL,
  `MaTaiKhoan` int(10) NOT NULL,
  `TrangThai` varchar(255) NOT NULL,
  `NgayLap` date DEFAULT NULL,
  `NgayXuat` date DEFAULT NULL,
  `MaKho` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `phieuxuat`
--

INSERT INTO `phieuxuat` (`MaPhieu`, `MaDon`, `MaTaiKhoan`, `TrangThai`, `NgayLap`, `NgayXuat`, `MaKho`) VALUES
(10412223, 204112312, 2, 'Chờ xuất', '2023-12-04', NULL, 611),
(10412719, 204112312, 2, 'Đã xuất', '2023-12-04', '2023-12-04', 698);

--
-- Bẫy `phieuxuat`
--
DELIMITER $$
CREATE TRIGGER `xuatKho` AFTER UPDATE ON `phieuxuat` FOR EACH ROW BEGIN
	IF new.TrangThai = "Đã xuất" THEN
    	CALL xacNhanXuatKho(new.MaPhieu);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `quyen`
--

CREATE TABLE `quyen` (
  `MaQuyen` int(11) NOT NULL,
  `TenQuyen` varchar(255) NOT NULL,
  `Code` varchar(50) NOT NULL,
  `MoTa` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `quyen`
--

INSERT INTO `quyen` (`MaQuyen`, `TenQuyen`, `Code`, `MoTa`) VALUES
(1, 'Xem dữ liệu', 'SELECT', 'quyền được xem dữ liệu'),
(2, 'Cập nhật dữ liệu', 'UPDATE', 'quyền được cập nhật dữ liệu'),
(3, 'Xóa dữ liệu', 'DELETE', 'quyền được xóa dữ liệu'),
(4, 'Thêm dữ liệu', 'INSERT', 'quyền được thêm dữ liệu');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sanpham`
--

CREATE TABLE `sanpham` (
  `MaSanPham` int(10) NOT NULL,
  `TenSanPham` varchar(255) NOT NULL,
  `SoLuongTon` int(10) NOT NULL,
  `DonVi` varchar(255) NOT NULL,
  `SoLuongChoNhap` float(10,5) NOT NULL,
  `SoLuongChoXuat` float(10,5) NOT NULL,
  `Loai` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `sanpham`
--

INSERT INTO `sanpham` (`MaSanPham`, `TenSanPham`, `SoLuongTon`, `DonVi`, `SoLuongChoNhap`, `SoLuongChoXuat`, `Loai`) VALUES
(12177543, 'Hạnh nhân', 0, 'KG', 0.00000, 0.00000, 'Nguyên liệu'),
(15725002, 'Sửa', 50, 'KG', 0.00000, 0.00000, 'Nguyên liệu'),
(16470341, 'Đường', 350, 'KG', 0.00000, 100.00000, 'Nguyên liệu'),
(17170391, 'Mè', 50, 'KG', 0.00000, 0.00000, 'Nguyên liệu'),
(17692725, 'Đậu xanh', 50, 'KG', 0.00000, 0.00000, 'Nguyên liệu'),
(19694585, 'Bột mì', 200, 'KG', 0.00000, 150.00000, 'Nguyên liệu'),
(22263817, 'Bánh mì', 100, 'Thùng', 0.00000, 0.00000, 'Thành phẩm'),
(24607429, 'Bánh hạnh nhân', 100, 'Hộp', 0.00000, 0.00000, 'Thành phẩm'),
(25495711, 'Bánh đậu xanh', 0, 'Hộp', 0.00000, 0.00000, 'Thành phẩm');

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `sanphamhethang`
-- (See below for the actual view)
--
CREATE TABLE `sanphamhethang` (
`MaSanPHam` int(10)
,`TenSanPham` varchar(255)
,`SoLuongTon` int(10)
,`DonVi` varchar(255)
,`SoLuongChoNhap` float(10,5)
,`SoLuongChoXuat` float(10,5)
,`Loai` varchar(255)
);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `taikhoan`
--

CREATE TABLE `taikhoan` (
  `MaTaiKhoan` int(10) NOT NULL,
  `MaVaiTro` int(10) NOT NULL,
  `TenDangNhap` varchar(255) NOT NULL,
  `MatKhau` varchar(255) NOT NULL,
  `ViTriKho` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `taikhoan`
--

INSERT INTO `taikhoan` (`MaTaiKhoan`, `MaVaiTro`, `TenDangNhap`, `MatKhau`, `ViTriKho`) VALUES
(2, 2, '20113401', '12345678', NULL),
(4, 3, '20113403', 'password123', 698),
(12, 6, '20113406', 'password123', NULL),
(140, 3, '20113411', 'password123', 847),
(350, 4, '20113405', 'password123', NULL),
(454, 3, '20113410', 'password123', 347),
(637, 3, '20113412', 'password123', 347),
(657, 5, '20113404', 'password123', 0),
(660, 3, '20113408', 'password123', 611),
(892, 1, '20113402', 'password123', NULL),
(981, 3, '20113409', 'password123', 455);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `vaitro`
--

CREATE TABLE `vaitro` (
  `MaVaiTro` int(10) NOT NULL,
  `TenVaiTro` varchar(255) NOT NULL,
  `MoTa` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `vaitro`
--

INSERT INTO `vaitro` (`MaVaiTro`, `TenVaiTro`, `MoTa`) VALUES
(1, 'GiamDoc', 'Người dùng có vai trò giám đốc'),
(2, 'QuanLyKho', 'Quản lý kho'),
(3, 'NhanVienKho', 'Bộ phận sản xuất'),
(4, 'BoPhanSanXuat', 'Bộ phận sản xuất'),
(5, 'BoPhanBanHang', 'Bộ phận bán hàng'),
(6, 'BoPhanKiemKe', 'Bộ phận chịu trách nhiệm kiểm kê kho');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `vaitro_quyen`
--

CREATE TABLE `vaitro_quyen` (
  `MaVaiTro` int(11) NOT NULL,
  `MaQuyen` int(11) NOT NULL,
  `MaBang` int(11) NOT NULL,
  `GrantOption` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `vaitro_quyen`
--

INSERT INTO `vaitro_quyen` (`MaVaiTro`, `MaQuyen`, `MaBang`, `GrantOption`) VALUES
(1, 1, 1, 0),
(1, 1, 2, 0),
(1, 1, 3, 0),
(1, 1, 4, 0),
(1, 1, 5, 0),
(1, 1, 6, 0),
(1, 1, 7, 0),
(1, 1, 8, 0),
(1, 1, 9, 0),
(1, 1, 10, 0),
(1, 1, 11, 0),
(1, 1, 12, 0),
(1, 1, 13, 0),
(1, 1, 14, 0),
(1, 1, 15, 0),
(1, 1, 16, 1),
(1, 2, 2, 0),
(1, 2, 6, 0),
(1, 2, 7, 0),
(1, 2, 8, 0),
(1, 2, 9, 0),
(1, 2, 10, 0),
(1, 2, 14, 0),
(1, 2, 15, 0),
(1, 4, 2, 0),
(1, 4, 3, 0),
(1, 4, 6, 0),
(1, 4, 7, 0),
(1, 4, 8, 0),
(1, 4, 9, 0),
(2, 1, 1, 1),
(2, 1, 2, 1),
(2, 1, 3, 1),
(2, 1, 4, 1),
(2, 1, 5, 1),
(2, 1, 6, 1),
(2, 1, 7, 1),
(2, 1, 8, 1),
(2, 1, 9, 1),
(2, 1, 10, 1),
(2, 1, 11, 1),
(2, 1, 12, 1),
(2, 1, 13, 1),
(2, 1, 14, 1),
(2, 1, 15, 1),
(2, 1, 16, 1),
(2, 2, 3, 1),
(2, 2, 5, 1),
(2, 2, 6, 1),
(2, 2, 8, 1),
(2, 2, 9, 1),
(2, 2, 12, 1),
(2, 2, 13, 1),
(2, 2, 14, 1),
(2, 2, 15, 1),
(2, 2, 16, 1),
(2, 4, 1, 1),
(2, 4, 5, 1),
(2, 4, 9, 1),
(2, 4, 12, 1),
(2, 4, 13, 1),
(2, 4, 14, 1),
(2, 4, 15, 1),
(3, 1, 1, 0),
(3, 1, 2, 0),
(3, 1, 3, 0),
(3, 1, 4, 0),
(3, 1, 5, 0),
(3, 1, 6, 0),
(3, 1, 7, 0),
(3, 1, 8, 0),
(3, 1, 9, 0),
(3, 1, 10, 0),
(3, 1, 11, 0),
(3, 1, 12, 0),
(3, 1, 13, 0),
(3, 1, 14, 0),
(3, 1, 15, 0),
(3, 1, 16, 1),
(3, 2, 6, 0),
(3, 2, 12, 0),
(3, 2, 13, 0),
(3, 2, 14, 0),
(3, 2, 15, 0),
(3, 4, 6, 0),
(4, 1, 1, 0),
(4, 1, 2, 0),
(4, 1, 3, 0),
(4, 1, 6, 0),
(4, 1, 7, 0),
(4, 1, 8, 0),
(4, 1, 9, 0),
(4, 1, 11, 0),
(4, 1, 14, 0),
(4, 1, 15, 0),
(4, 1, 16, 1),
(4, 2, 15, 0),
(4, 4, 3, 0),
(4, 4, 8, 0),
(5, 1, 1, 0),
(5, 1, 3, 0),
(5, 1, 4, 0),
(5, 1, 6, 0),
(5, 1, 8, 0),
(5, 1, 9, 0),
(5, 1, 10, 0),
(5, 1, 11, 0),
(5, 1, 14, 0),
(5, 1, 15, 0),
(5, 1, 16, 1),
(5, 2, 15, 0),
(5, 4, 3, 0),
(5, 4, 8, 0),
(6, 1, 1, 0),
(6, 1, 2, 0),
(6, 1, 3, 0),
(6, 1, 4, 0),
(6, 1, 5, 0),
(6, 1, 6, 0),
(6, 1, 7, 0),
(6, 1, 8, 0),
(6, 1, 9, 0),
(6, 1, 10, 0),
(6, 1, 11, 0),
(6, 1, 12, 0),
(6, 1, 13, 0),
(6, 1, 14, 0),
(6, 1, 15, 0),
(6, 1, 16, 1),
(6, 2, 4, 0),
(6, 2, 6, 0),
(6, 2, 8, 0),
(6, 2, 10, 0),
(6, 2, 12, 0),
(6, 2, 13, 0),
(6, 2, 15, 0),
(6, 4, 1, 0),
(6, 4, 4, 0),
(6, 4, 10, 0);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `vnguyenlieu`
-- (See below for the actual view)
--
CREATE TABLE `vnguyenlieu` (
`MaSanPHam` int(10)
,`TenSanPham` varchar(255)
,`SoLuongTon` int(10)
,`DonVi` varchar(255)
,`SoLuongChoNhap` float(10,5)
,`SoLuongChoXuat` float(10,5)
,`Loai` varchar(255)
);

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `vthanhpham`
-- (See below for the actual view)
--
CREATE TABLE `vthanhpham` (
`MaSanPHam` int(10)
,`TenSanPham` varchar(255)
,`SoLuongTon` int(10)
,`DonVi` varchar(255)
,`SoLuongChoNhap` float(10,5)
,`SoLuongChoXuat` float(10,5)
,`Loai` varchar(255)
);

-- --------------------------------------------------------

--
-- Cấu trúc cho view `sanphamhethang`
--
DROP TABLE IF EXISTS `sanphamhethang`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sanphamhethang`  AS SELECT `sanpham`.`MaSanPham` AS `MaSanPHam`, `sanpham`.`TenSanPham` AS `TenSanPham`, `sanpham`.`SoLuongTon` AS `SoLuongTon`, `sanpham`.`DonVi` AS `DonVi`, `sanpham`.`SoLuongChoNhap` AS `SoLuongChoNhap`, `sanpham`.`SoLuongChoXuat` AS `SoLuongChoXuat`, `sanpham`.`Loai` AS `Loai` FROM `sanpham` WHERE `sanpham`.`SoLuongTon` = 0 ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `vnguyenlieu`
--
DROP TABLE IF EXISTS `vnguyenlieu`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vnguyenlieu`  AS SELECT `sanpham`.`MaSanPham` AS `MaSanPHam`, `sanpham`.`TenSanPham` AS `TenSanPham`, `sanpham`.`SoLuongTon` AS `SoLuongTon`, `sanpham`.`DonVi` AS `DonVi`, `sanpham`.`SoLuongChoNhap` AS `SoLuongChoNhap`, `sanpham`.`SoLuongChoXuat` AS `SoLuongChoXuat`, `sanpham`.`Loai` AS `Loai` FROM `sanpham` WHERE `sanpham`.`Loai` = 'Nguyên liệu' ;

-- --------------------------------------------------------

--
-- Cấu trúc cho view `vthanhpham`
--
DROP TABLE IF EXISTS `vthanhpham`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vthanhpham`  AS SELECT `sanpham`.`MaSanPham` AS `MaSanPHam`, `sanpham`.`TenSanPham` AS `TenSanPham`, `sanpham`.`SoLuongTon` AS `SoLuongTon`, `sanpham`.`DonVi` AS `DonVi`, `sanpham`.`SoLuongChoNhap` AS `SoLuongChoNhap`, `sanpham`.`SoLuongChoXuat` AS `SoLuongChoXuat`, `sanpham`.`Loai` AS `Loai` FROM `sanpham` WHERE `sanpham`.`Loai` = 'Thành phẩm\'Thành phẩm' ;

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `bang`
--
ALTER TABLE `bang`
  ADD PRIMARY KEY (`MaBang`);

--
-- Chỉ mục cho bảng `bienban`
--
ALTER TABLE `bienban`
  ADD PRIMARY KEY (`MaBienBan`),
  ADD KEY `FKBienBan267512` (`MaDon`),
  ADD KEY `FKBienBan556856` (`MaTaiKhoan`);

--
-- Chỉ mục cho bảng `chitietcongthuc`
--
ALTER TABLE `chitietcongthuc`
  ADD PRIMARY KEY (`MaCongThuc`,`MaSanPHam`),
  ADD KEY `FKChiTietCon75882` (`MaCongThuc`),
  ADD KEY `FKChiTietCon401115` (`MaSanPHam`);

--
-- Chỉ mục cho bảng `chitietdonyeucau`
--
ALTER TABLE `chitietdonyeucau`
  ADD PRIMARY KEY (`MaDon`,`MaSanPham`),
  ADD KEY `FKChiTietDon673597` (`MaSanPham`),
  ADD KEY `FKChiTietDon910533` (`MaDon`);

--
-- Chỉ mục cho bảng `chitietkiemke`
--
ALTER TABLE `chitietkiemke`
  ADD PRIMARY KEY (`MaKiemKe`,`MaChiTietSanPham`),
  ADD KEY `FKChiTietKie686394` (`MaChiTietSanPham`),
  ADD KEY `FKChiTietKie166234` (`MaKiemKe`);

--
-- Chỉ mục cho bảng `chitietphieunhap`
--
ALTER TABLE `chitietphieunhap`
  ADD PRIMARY KEY (`MaPhieu`,`MaSanPham`),
  ADD KEY `MaSanPham` (`MaSanPham`);

--
-- Chỉ mục cho bảng `chitietphieuxuat`
--
ALTER TABLE `chitietphieuxuat`
  ADD PRIMARY KEY (`MaPhieu`,`MaChiTietSanPham`),
  ADD KEY `FKChiTietPhi963262` (`MaChiTietSanPham`),
  ADD KEY `FKChiTietPhi455447` (`MaPhieu`);

--
-- Chỉ mục cho bảng `chitietsanpham`
--
ALTER TABLE `chitietsanpham`
  ADD PRIMARY KEY (`MaChiTietSanPham`),
  ADD KEY `FKChiTietSan492747` (`MaKho`),
  ADD KEY `FKChiTietSan276671` (`MaSanPHam`),
  ADD KEY `MaPhieuNhap` (`MaPhieuNhap`);

--
-- Chỉ mục cho bảng `congthuc`
--
ALTER TABLE `congthuc`
  ADD PRIMARY KEY (`MaCongThuc`);

--
-- Chỉ mục cho bảng `donyeucau`
--
ALTER TABLE `donyeucau`
  ADD PRIMARY KEY (`MaDon`),
  ADD KEY `FKDonYeuCau371336` (`MaLoai`),
  ADD KEY `FKDonYeuCau246617` (`MaTaiKhoan`);

--
-- Chỉ mục cho bảng `kho`
--
ALTER TABLE `kho`
  ADD PRIMARY KEY (`MaKho`);

--
-- Chỉ mục cho bảng `kiemke`
--
ALTER TABLE `kiemke`
  ADD PRIMARY KEY (`MaKiemKe`),
  ADD KEY `Kho` (`Kho`),
  ADD KEY `MaTaiKhoan` (`MaTaiKhoan`);

--
-- Chỉ mục cho bảng `loaidon`
--
ALTER TABLE `loaidon`
  ADD PRIMARY KEY (`MaLoai`);

--
-- Chỉ mục cho bảng `phieunhap`
--
ALTER TABLE `phieunhap`
  ADD PRIMARY KEY (`MaPhieu`),
  ADD KEY `MaDon` (`MaDon`,`MaTaiKhoan`),
  ADD KEY `MaTaiKhoan` (`MaTaiKhoan`),
  ADD KEY `MaKho` (`MaKho`);

--
-- Chỉ mục cho bảng `phieuxuat`
--
ALTER TABLE `phieuxuat`
  ADD PRIMARY KEY (`MaPhieu`),
  ADD KEY `FKPhieuXuat472906` (`MaDon`),
  ADD KEY `FKPhieuXuat674315` (`MaTaiKhoan`),
  ADD KEY `phieuxuat_ibfk_1` (`MaKho`);

--
-- Chỉ mục cho bảng `quyen`
--
ALTER TABLE `quyen`
  ADD PRIMARY KEY (`MaQuyen`);

--
-- Chỉ mục cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  ADD PRIMARY KEY (`MaSanPham`);
ALTER TABLE `sanpham` ADD FULLTEXT KEY `Loai` (`Loai`);

--
-- Chỉ mục cho bảng `taikhoan`
--
ALTER TABLE `taikhoan`
  ADD PRIMARY KEY (`MaTaiKhoan`),
  ADD KEY `FKTaiKhoan752758` (`MaVaiTro`);

--
-- Chỉ mục cho bảng `vaitro`
--
ALTER TABLE `vaitro`
  ADD PRIMARY KEY (`MaVaiTro`);

--
-- Chỉ mục cho bảng `vaitro_quyen`
--
ALTER TABLE `vaitro_quyen`
  ADD PRIMARY KEY (`MaVaiTro`,`MaQuyen`,`MaBang`),
  ADD KEY `MaQuyen` (`MaQuyen`),
  ADD KEY `MaBang` (`MaBang`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `bang`
--
ALTER TABLE `bang`
  MODIFY `MaBang` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT cho bảng `bienban`
--
ALTER TABLE `bienban`
  MODIFY `MaBienBan` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=942;

--
-- AUTO_INCREMENT cho bảng `congthuc`
--
ALTER TABLE `congthuc`
  MODIFY `MaCongThuc` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26269117;

--
-- AUTO_INCREMENT cho bảng `kho`
--
ALTER TABLE `kho`
  MODIFY `MaKho` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=900;

--
-- AUTO_INCREMENT cho bảng `kiemke`
--
ALTER TABLE `kiemke`
  MODIFY `MaKiemKe` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=960;

--
-- AUTO_INCREMENT cho bảng `loaidon`
--
ALTER TABLE `loaidon`
  MODIFY `MaLoai` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `phieuxuat`
--
ALTER TABLE `phieuxuat`
  MODIFY `MaPhieu` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10412720;

--
-- AUTO_INCREMENT cho bảng `quyen`
--
ALTER TABLE `quyen`
  MODIFY `MaQuyen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `sanpham`
--
ALTER TABLE `sanpham`
  MODIFY `MaSanPham` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29281790;

--
-- AUTO_INCREMENT cho bảng `taikhoan`
--
ALTER TABLE `taikhoan`
  MODIFY `MaTaiKhoan` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=982;

--
-- AUTO_INCREMENT cho bảng `vaitro`
--
ALTER TABLE `vaitro`
  MODIFY `MaVaiTro` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `bienban`
--
ALTER TABLE `bienban`
  ADD CONSTRAINT `FKBienBan267512` FOREIGN KEY (`MaDon`) REFERENCES `donyeucau` (`MaDon`),
  ADD CONSTRAINT `FKBienBan556856` FOREIGN KEY (`MaTaiKhoan`) REFERENCES `taikhoan` (`MaTaiKhoan`);

--
-- Các ràng buộc cho bảng `chitietcongthuc`
--
ALTER TABLE `chitietcongthuc`
  ADD CONSTRAINT `FKChiTietCon401115` FOREIGN KEY (`MaSanPHam`) REFERENCES `sanpham` (`MaSanPham`),
  ADD CONSTRAINT `FKChiTietCon75882` FOREIGN KEY (`MaCongThuc`) REFERENCES `congthuc` (`MaCongThuc`);

--
-- Các ràng buộc cho bảng `chitietdonyeucau`
--
ALTER TABLE `chitietdonyeucau`
  ADD CONSTRAINT `FKChiTietDon673597` FOREIGN KEY (`MaSanPham`) REFERENCES `sanpham` (`MaSanPham`),
  ADD CONSTRAINT `FKChiTietDon910533` FOREIGN KEY (`MaDon`) REFERENCES `donyeucau` (`MaDon`);

--
-- Các ràng buộc cho bảng `chitietkiemke`
--
ALTER TABLE `chitietkiemke`
  ADD CONSTRAINT `FKChiTietKie166234` FOREIGN KEY (`MaKiemKe`) REFERENCES `kiemke` (`MaKiemKe`),
  ADD CONSTRAINT `FKChiTietKie686394` FOREIGN KEY (`MaChiTietSanPham`) REFERENCES `chitietsanpham` (`MaChiTietSanPham`);

--
-- Các ràng buộc cho bảng `chitietphieunhap`
--
ALTER TABLE `chitietphieunhap`
  ADD CONSTRAINT `chitietphieunhap_ibfk_2` FOREIGN KEY (`MaPhieu`) REFERENCES `phieunhap` (`MaPhieu`),
  ADD CONSTRAINT `chitietphieunhap_ibfk_3` FOREIGN KEY (`MaSanPham`) REFERENCES `sanpham` (`MaSanPham`);

--
-- Các ràng buộc cho bảng `chitietphieuxuat`
--
ALTER TABLE `chitietphieuxuat`
  ADD CONSTRAINT `FKChiTietPhi455447` FOREIGN KEY (`MaPhieu`) REFERENCES `phieuxuat` (`MaPhieu`),
  ADD CONSTRAINT `FKChiTietPhi963262` FOREIGN KEY (`MaChiTietSanPham`) REFERENCES `chitietsanpham` (`MaChiTietSanPham`);

--
-- Các ràng buộc cho bảng `chitietsanpham`
--
ALTER TABLE `chitietsanpham`
  ADD CONSTRAINT `FKChiTietSan276671` FOREIGN KEY (`MaSanPHam`) REFERENCES `sanpham` (`MaSanPham`),
  ADD CONSTRAINT `FKChiTietSan492747` FOREIGN KEY (`MaKho`) REFERENCES `kho` (`MaKho`),
  ADD CONSTRAINT `chitietsanpham_ibfk_1` FOREIGN KEY (`MaPhieuNhap`) REFERENCES `phieunhap` (`MaPhieu`);

--
-- Các ràng buộc cho bảng `donyeucau`
--
ALTER TABLE `donyeucau`
  ADD CONSTRAINT `FKDonYeuCau246617` FOREIGN KEY (`MaTaiKhoan`) REFERENCES `taikhoan` (`MaTaiKhoan`),
  ADD CONSTRAINT `FKDonYeuCau371336` FOREIGN KEY (`MaLoai`) REFERENCES `loaidon` (`MaLoai`);

--
-- Các ràng buộc cho bảng `kiemke`
--
ALTER TABLE `kiemke`
  ADD CONSTRAINT `kiemke_ibfk_1` FOREIGN KEY (`Kho`) REFERENCES `kho` (`MaKho`),
  ADD CONSTRAINT `kiemke_ibfk_2` FOREIGN KEY (`MaTaiKhoan`) REFERENCES `taikhoan` (`MaTaiKhoan`);

--
-- Các ràng buộc cho bảng `phieunhap`
--
ALTER TABLE `phieunhap`
  ADD CONSTRAINT `FKPhieuNhap984722` FOREIGN KEY (`MaTaiKhoan`) REFERENCES `taikhoan` (`MaTaiKhoan`),
  ADD CONSTRAINT `phieunhap_ibfk_1` FOREIGN KEY (`MaDon`) REFERENCES `donyeucau` (`MaDon`),
  ADD CONSTRAINT `phieunhap_ibfk_2` FOREIGN KEY (`MaKho`) REFERENCES `kho` (`MaKho`);

--
-- Các ràng buộc cho bảng `phieuxuat`
--
ALTER TABLE `phieuxuat`
  ADD CONSTRAINT `FKPhieuXuat472906` FOREIGN KEY (`MaDon`) REFERENCES `donyeucau` (`MaDon`),
  ADD CONSTRAINT `FKPhieuXuat674315` FOREIGN KEY (`MaTaiKhoan`) REFERENCES `taikhoan` (`MaTaiKhoan`),
  ADD CONSTRAINT `phieuxuat_ibfk_1` FOREIGN KEY (`MaKho`) REFERENCES `kho` (`MaKho`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `taikhoan`
--
ALTER TABLE `taikhoan`
  ADD CONSTRAINT `FKTaiKhoan752758` FOREIGN KEY (`MaVaiTro`) REFERENCES `vaitro` (`MaVaiTro`);

--
-- Các ràng buộc cho bảng `vaitro_quyen`
--
ALTER TABLE `vaitro_quyen`
  ADD CONSTRAINT `vaitro_quyen_ibfk_1` FOREIGN KEY (`MaVaiTro`) REFERENCES `vaitro` (`MaVaiTro`),
  ADD CONSTRAINT `vaitro_quyen_ibfk_2` FOREIGN KEY (`MaQuyen`) REFERENCES `quyen` (`MaQuyen`),
  ADD CONSTRAINT `vaitro_quyen_ibfk_3` FOREIGN KEY (`MaBang`) REFERENCES `bang` (`MaBang`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
