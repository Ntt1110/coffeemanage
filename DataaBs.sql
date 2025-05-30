USE [QuanLyQuanCafe]
GO
/****** Object:  UserDefinedFunction [dbo].[fuConvertToUnsign1]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fuConvertToUnsign1] ( @strInput NVARCHAR(4000) ) RETURNS NVARCHAR(4000) AS BEGIN IF @strInput IS NULL RETURN @strInput IF @strInput = '' RETURN @strInput DECLARE @RT NVARCHAR(4000) DECLARE @SIGN_CHARS NCHAR(136) DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' DECLARE @COUNTER int DECLARE @COUNTER1 int SET @COUNTER = 1 WHILE (@COUNTER <=LEN(@strInput)) BEGIN SET @COUNTER1 = 1 WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) BEGIN IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) BEGIN IF @COUNTER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) ELSE SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) BREAK END SET @COUNTER1 = @COUNTER1 +1 END SET @COUNTER = @COUNTER +1 END SET @strInput = replace(@strInput,' ','-') RETURN @strInput END
GO
/****** Object:  Table [dbo].[Account]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[UserName] [nvarchar](100) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[PassWord] [nvarchar](1000) NOT NULL,
	[Type] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bill]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bill](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DateCheckIn] [datetime] NOT NULL,
	[DateCheckOut] [datetime] NULL,
	[idTable] [int] NOT NULL,
	[status] [int] NOT NULL,
	[totalPrice] [decimal](18, 2) NULL,
	[discount] [decimal](5, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BillInfo]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillInfo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idBill] [int] NOT NULL,
	[idFood] [int] NOT NULL,
	[count] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Food]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Food](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[idCategory] [int] NOT NULL,
	[price] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FoodCategory]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodCategory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TableFood]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableFood](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[status] [nvarchar](100) NOT NULL,
	[TableID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Account] ([UserName], [DisplayName], [PassWord], [Type]) VALUES (N'bathien', N'Thiendz', N'202cb962ac59075b964b07152d234b70', 1)
INSERT [dbo].[Account] ([UserName], [DisplayName], [PassWord], [Type]) VALUES (N'cbt', N'nhanvien', N'nv123', 0)
INSERT [dbo].[Account] ([UserName], [DisplayName], [PassWord], [Type]) VALUES (N'thien', N'thien1', N'123', 0)
GO
SET IDENTITY_INSERT [dbo].[Bill] ON 

INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (1, CAST(N'2025-05-07T20:38:29.410' AS DateTime), CAST(N'2025-05-07T20:38:29.410' AS DateTime), 1, 1, CAST(150000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (2, CAST(N'2025-05-08T15:10:15.257' AS DateTime), CAST(N'2025-05-08T16:24:38.637' AS DateTime), 1, 1, CAST(120000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (3, CAST(N'2025-05-08T16:58:01.953' AS DateTime), CAST(N'2025-05-08T20:12:02.317' AS DateTime), 1, 1, CAST(82000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (4, CAST(N'2025-05-08T20:42:57.990' AS DateTime), CAST(N'2025-05-08T20:43:33.357' AS DateTime), 1, 1, CAST(81600.00 AS Decimal(18, 2)), CAST(4.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (5, CAST(N'2025-05-08T20:52:42.403' AS DateTime), CAST(N'2025-05-08T20:53:14.157' AS DateTime), 1, 1, CAST(90000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (6, CAST(N'2025-05-08T21:12:07.970' AS DateTime), CAST(N'2025-05-08T21:12:18.993' AS DateTime), 1, 1, CAST(105000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (7, CAST(N'2025-05-08T21:22:16.113' AS DateTime), CAST(N'2025-05-08T21:22:19.703' AS DateTime), 1, 1, CAST(150000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (8, CAST(N'2025-05-08T21:29:22.347' AS DateTime), CAST(N'2025-05-08T21:29:28.317' AS DateTime), 1, 1, CAST(270000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (9, CAST(N'2025-05-08T21:47:31.873' AS DateTime), CAST(N'2025-05-08T21:47:35.740' AS DateTime), 1, 1, CAST(30000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (10, CAST(N'2025-05-09T13:17:39.920' AS DateTime), CAST(N'2025-05-09T13:17:43.110' AS DateTime), 1, 1, CAST(60000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (11, CAST(N'2025-05-09T13:17:49.260' AS DateTime), CAST(N'2025-05-09T13:17:52.097' AS DateTime), 1, 1, CAST(30000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (12, CAST(N'2025-05-09T13:18:33.510' AS DateTime), CAST(N'2025-05-09T13:18:37.367' AS DateTime), 1, 1, CAST(30000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (13, CAST(N'2025-05-09T13:26:50.700' AS DateTime), CAST(N'2025-05-09T13:26:53.473' AS DateTime), 1, 1, CAST(30000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (14, CAST(N'2025-05-09T13:47:07.560' AS DateTime), CAST(N'2025-05-09T13:47:12.323' AS DateTime), 1, 1, CAST(60000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (15, CAST(N'2025-05-09T14:11:10.983' AS DateTime), CAST(N'2025-05-09T14:11:14.450' AS DateTime), 1, 1, CAST(30000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (16, CAST(N'2025-05-10T12:18:02.797' AS DateTime), CAST(N'2025-05-10T12:18:27.037' AS DateTime), 1, 1, CAST(30000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (17, CAST(N'2025-05-10T12:18:06.790' AS DateTime), CAST(N'2025-05-10T12:18:21.250' AS DateTime), 2, 1, CAST(110000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (18, CAST(N'2025-05-10T12:18:13.937' AS DateTime), CAST(N'2025-05-10T12:18:17.317' AS DateTime), 3, 1, CAST(40000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (19, CAST(N'2025-05-10T12:19:52.663' AS DateTime), CAST(N'2025-05-10T12:19:58.410' AS DateTime), 1, 1, CAST(80000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [totalPrice], [discount]) VALUES (20, CAST(N'2025-05-10T13:35:52.320' AS DateTime), CAST(N'2025-05-10T13:36:32.340' AS DateTime), 1, 1, CAST(75000.00 AS Decimal(18, 2)), CAST(0.00 AS Decimal(5, 2)))
SET IDENTITY_INSERT [dbo].[Bill] OFF
GO
SET IDENTITY_INSERT [dbo].[BillInfo] ON 

INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (6, 4, 9, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (7, 4, 16, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (8, 4, 18, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (9, 5, 8, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (10, 6, 8, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (11, 6, 13, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (12, 7, 8, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (13, 8, 8, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (14, 9, 8, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (15, 10, 8, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (16, 11, 8, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (17, 12, 8, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (18, 13, 8, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (19, 14, 8, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (20, 15, 8, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (21, 16, 8, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (22, 17, 8, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (23, 17, 10, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (24, 18, 10, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (25, 19, 10, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (26, 20, 8, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (27, 20, 17, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (28, 20, 24, 1)
SET IDENTITY_INSERT [dbo].[BillInfo] OFF
GO
SET IDENTITY_INSERT [dbo].[Food] ON 

INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (8, N'Caffe đen', 1, 30000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (9, N'Caffe sữa', 1, 25000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (10, N'Bạc xỉu', 1, 40000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (11, N'7Up', 2, 15000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (12, N'Pessi', 2, 15000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (13, N'CoCaCoLa', 2, 15000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (14, N'Sting', 2, 15000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (15, N'Trà sữa chân trâu đường đen', 3, 30000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (16, N'Trà sữa dâu', 3, 25000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (17, N'Trà Tắc', 3, 30000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (18, N'Trà đào', 3, 35000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (19, N'Sinh tố dâu', 4, 30000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (20, N'Sinh tố bơ', 4, 25000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (21, N'Sinh tố me', 4, 30000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (22, N'Sinh tố dừa', 4, 35000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (23, N'Aquafina', 5, 10000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (24, N'lavie', 5, 15000)
INSERT [dbo].[Food] ([id], [name], [idCategory], [price]) VALUES (25, N'Caffe đen', 1, 30000)
SET IDENTITY_INSERT [dbo].[Food] OFF
GO
SET IDENTITY_INSERT [dbo].[FoodCategory] ON 

INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (1, N'Caffe')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (2, N'Nước ngọt')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (3, N'Trà Sữa')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (4, N'Sinh tốt')
INSERT [dbo].[FoodCategory] ([id], [name]) VALUES (5, N'Nước lọc')
SET IDENTITY_INSERT [dbo].[FoodCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[TableFood] ON 

INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (1, N'Bàn 1', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (2, N'Bàn 1', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (3, N'Bàn 2', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (4, N'Bàn 3', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (5, N'Bàn 4', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (6, N'Bàn 5', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (7, N'Bàn 6', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (8, N'Bàn 7', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (9, N'Bàn 8', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (10, N'Bàn 9', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (11, N'Bàn 10', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (12, N'Bàn 11', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (13, N'Bàn 12', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (14, N'Bàn 13', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (15, N'Bàn 14', N'Trống', NULL)
INSERT [dbo].[TableFood] ([id], [name], [status], [TableID]) VALUES (16, N'Bàn 15', N'Trống', NULL)
SET IDENTITY_INSERT [dbo].[TableFood] OFF
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT (N'Kter') FOR [DisplayName]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT ('0') FOR [PassWord]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT ((0)) FOR [Type]
GO
ALTER TABLE [dbo].[Bill] ADD  DEFAULT (getdate()) FOR [DateCheckIn]
GO
ALTER TABLE [dbo].[Bill] ADD  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[BillInfo] ADD  DEFAULT ((0)) FOR [count]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT (N'Chưa đặt tên') FOR [name]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT ((0)) FOR [idCategory]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT ((0)) FOR [price]
GO
ALTER TABLE [dbo].[FoodCategory] ADD  DEFAULT (N'Chưa đặt tên') FOR [name]
GO
ALTER TABLE [dbo].[TableFood] ADD  DEFAULT (N'Bàn chưa có tên') FOR [name]
GO
ALTER TABLE [dbo].[TableFood] ADD  DEFAULT (N'Trống') FOR [status]
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD FOREIGN KEY([idTable])
REFERENCES [dbo].[TableFood] ([id])
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD FOREIGN KEY([idTable])
REFERENCES [dbo].[TableFood] ([id])
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([idBill])
REFERENCES [dbo].[Bill] ([id])
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([idBill])
REFERENCES [dbo].[Bill] ([id])
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([idFood])
REFERENCES [dbo].[Food] ([id])
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([idFood])
REFERENCES [dbo].[Food] ([id])
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD FOREIGN KEY([idCategory])
REFERENCES [dbo].[FoodCategory] ([id])
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD FOREIGN KEY([idCategory])
REFERENCES [dbo].[FoodCategory] ([id])
GO
/****** Object:  StoredProcedure [dbo].[UpdateBillItem]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[UpdateBillItem]
    @BillID INT,
    @FoodID INT,
    @NewCount INT
AS
BEGIN
    UPDATE BillInfo
    SET Count = @NewCount
    WHERE idBill = @BillID AND idFood = @FoodID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteFood]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DeleteFood]
    @foodId INT
AS
BEGIN
    DELETE FROM Food WHERE id = @foodId;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAccountByUserName]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetAccountByUserName]
@userName nvarchar(100)
AS 
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @userName
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetListBillByDate]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetListBillByDate]
    @start DATETIME,
    @end DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    SELECT b.id, b.dateCheckIn, b.dateCheckOut, b.status, b.discount, b.totalPrice, t.name AS tableName
    FROM Bill b
    INNER JOIN TableFood t ON b.idTable = t.id
    WHERE b.dateCheckIn >= @start AND b.dateCheckIn <= @end
    ORDER BY b.dateCheckIn DESC;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetListBillByDateAndPage]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetListBillByDateAndPage]
@checkIn date, @checkOut date, @page int
AS 
BEGIN
	DECLARE @pageRows INT = 10
	DECLARE @selectRows INT = @pageRows
	DECLARE @exceptRows INT = (@page - 1) * @pageRows
	
	;WITH BillShow AS( SELECT b.ID, t.name AS [Tên bàn], b.totalPrice AS [Tổng tiền], DateCheckIn AS [Ngày vào], DateCheckOut AS [Ngày ra], discount AS [Giảm giá]
	FROM dbo.Bill AS b,dbo.TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.status = 1
	AND t.id = b.idTable)
	
	SELECT TOP (@selectRows) * FROM BillShow WHERE id NOT IN (SELECT TOP (@exceptRows) id FROM BillShow)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetListBillByDateForReport]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetListBillByDateForReport]
@checkIn DATE, @checkOut DATE
AS 
BEGIN
    SELECT 
        t.name, 
        b.totalPrice, 
        b.DateCheckIn, 
        b.DateCheckOut, 
        b.discount
    FROM dbo.Bill AS b
    INNER JOIN dbo.TableFood AS t ON t.id = b.idTable
    WHERE b.DateCheckIn BETWEEN @checkIn AND @checkOut
      AND b.status = 1;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetNumBillByDate]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetNumBillByDate]
@checkIn date, @checkOut date
AS 
BEGIN
	SELECT COUNT(*)
	FROM dbo.Bill AS b,dbo.TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.status = 1
	AND t.id = b.idTable
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetTableList]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetTableList]
AS
BEGIN
    -- Lấy danh sách bàn từ bảng TableFood
    SELECT * 
    FROM TableFood
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBill]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertBill]
@idTable INT
AS
BEGIN
	INSERT dbo.Bill 
	        ( DateCheckIn ,
	          DateCheckOut ,
	          idTable ,
	          status,
	          discount
	        )
	VALUES  ( GETDATE() , -- DateCheckIn - date
	          NULL , -- DateCheckOut - date
	          @idTable , -- idTable - int
	          0,  -- status - int
	          0
	        )
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBillInfo]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertBillInfo]
@idBill INT, @idFood INT, @count INT
AS
BEGIN

	DECLARE @isExitsBillInfo INT
	DECLARE @foodCount INT = 1
	
	SELECT @isExitsBillInfo = id, @foodCount = b.count 
	FROM dbo.BillInfo AS b 
	WHERE idBill = @idBill AND idFood = @idFood

	IF (@isExitsBillInfo > 0)
	BEGIN
		DECLARE @newCount INT = @foodCount + @count
		IF (@newCount > 0)
			UPDATE dbo.BillInfo	SET count = @foodCount + @count WHERE idFood = @idFood
		ELSE
			DELETE dbo.BillInfo WHERE idBill = @idBill AND idFood = @idFood
	END
	ELSE
	BEGIN
		INSERT	dbo.BillInfo
        ( idBill, idFood, count )
		VALUES  ( @idBill, -- idBill - int
          @idFood, -- idFood - int
          @count  -- count - int
          )
	END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Login]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Login]
    @Username NVARCHAR(50),
    @Password NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT UserName, DisplayName, Type
    FROM Account
    WHERE UserName = @Username AND PassWord = @Password;
END;
GO
/****** Object:  StoredProcedure [dbo].[USP_SwitchTabel]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SwitchTabel]
@idTable1 INT, @idTable2 int
AS BEGIN

	DECLARE @idFirstBill int
	DECLARE @idSeconrdBill INT
	
	DECLARE @isFirstTablEmty INT = 1
	DECLARE @isSecondTablEmty INT = 1
	
	
	SELECT @idSeconrdBill = id FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
	SELECT @idFirstBill = id FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'
	
	IF (@idFirstBill IS NULL)
	BEGIN
		PRINT '0000001'
		INSERT dbo.Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          idTable ,
		          status
		        )
		VALUES  ( GETDATE() , -- DateCheckIn - date
		          NULL , -- DateCheckOut - date
		          @idTable1 , -- idTable - int
		          0  -- status - int
		        )
		        
		SELECT @idFirstBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
		
	END
	
	SELECT @isFirstTablEmty = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idFirstBill
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'
	
	IF (@idSeconrdBill IS NULL)
	BEGIN
		PRINT '0000002'
		INSERT dbo.Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          idTable ,
		          status
		        )
		VALUES  ( GETDATE() , -- DateCheckIn - date
		          NULL , -- DateCheckOut - date
		          @idTable2 , -- idTable - int
		          0  -- status - int
		        )
		SELECT @idSeconrdBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
		
	END
	
	SELECT @isSecondTablEmty = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idSeconrdBill
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'

	SELECT id INTO IDBillInfoTable FROM dbo.BillInfo WHERE idBill = @idSeconrdBill
	
	UPDATE dbo.BillInfo SET idBill = @idSeconrdBill WHERE idBill = @idFirstBill
	
	UPDATE dbo.BillInfo SET idBill = @idFirstBill WHERE id IN (SELECT * FROM IDBillInfoTable)
	
	DROP TABLE IDBillInfoTable
	
	IF (@isFirstTablEmty = 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable2
		
	IF (@isSecondTablEmty= 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable1
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SwitchTable]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SwitchTable]
    @idTable1 INT,
    @idTable2 INT
AS
BEGIN
    -- Cập nhật trạng thái bàn 1 thành "Có người ngồi"
    UPDATE TableFood
    SET status = 'Có người ngồi'
    WHERE id = @idTable1;  -- Thực hiện thay đổi trạng thái bàn đầu tiên

    -- Cập nhật trạng thái bàn 2 thành "Trống"
    UPDATE TableFood
    SET status = 'Trống'
    WHERE id = @idTable2;  -- Thực hiện thay đổi trạng thái bàn thứ hai
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateAccount]    Script Date: 10/05/2025 2:40:06 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_UpdateAccount]
@userName NVARCHAR(100), @displayName NVARCHAR(100), @password NVARCHAR(100), @newPassword NVARCHAR(100)
AS
BEGIN
	DECLARE @isRightPass INT = 0
	
	SELECT @isRightPass = COUNT(*) FROM dbo.Account WHERE USERName = @userName AND PassWord = @password
	
	IF (@isRightPass = 1)
	BEGIN
		IF (@newPassword IS NULL OR @newPassword = '')
		BEGIN
			UPDATE dbo.Account SET DisplayName = @displayName WHERE UserName = @userName
		END		
		ELSE
			UPDATE dbo.Account SET DisplayName = @displayName, PassWord = @newPassword WHERE UserName = @userName
	end
END
GO
