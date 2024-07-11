USE [DatabaseDesign-GID11]
GO
/****** Object:  Table [dbo].[ATM-Machine]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ATM-Machine](
	[ATM_ID] [int] NOT NULL,
	[ATM_Address] [varchar](150) NULL,
	[Status] [varchar](10) NULL,
	[CashAvailable] [int] NULL,
	[Afflilated_BranchID] [int] NULL,
	[TerminalFee] [int] NULL,
 CONSTRAINT [PK_ATM-Machine] PRIMARY KEY CLUSTERED 
(
	[ATM_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transaction]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transaction](
	[TransactionID] [int] NOT NULL,
	[Card_ID] [char](13) NULL,
	[Type] [varchar](20) NULL,
	[Status] [varchar](10) NULL,
	[ATM_ID] [int] NULL,
	[TransactionTime] [datetime] NULL,
	[PreviousBalance] [int] NULL,
	[NewBalance] [int] NULL,
 CONSTRAINT [PK_Transaction] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[miniStatmentView]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[miniStatmentView]
AS
Select T.TransactionID as [Tr#],T.TransactionTime [Date/Time],T.Card_ID [Card#], (SELECT ATM_Address FROM [ATM-Machine] Where ATM_ID = T.ATM_ID) AS  ATM ,T.[Status],T.[Type],T.PreviousBalance [PREVIOUS CASH], T.NewBalance [NEW CASH],  ABS(PreviousBalance - NewBalance)  as [DEDUCTION/DEPOSIT] from [Transaction] T where Card_ID = '1111111111111' 

GO
/****** Object:  Table [dbo].[Account]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[AccountNumber] [int] NOT NULL,
	[Balance] [int] NULL,
	[OpeningDate] [datetime] NULL,
	[Bank_ID] [int] NULL,
	[Type] [int] NULL,
	[FounderCustomerID] [int] NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[AccountNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bank]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bank](
	[Bank_ID] [int] NOT NULL,
	[BankName] [varchar](50) NULL,
	[Helpline] [varchar](50) NULL,
	[HQLocation] [varchar](150) NULL,
	[Alias] [varchar](5) NULL,
 CONSTRAINT [PK_Bank] PRIMARY KEY CLUSTERED 
(
	[Bank_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Beneficiaries]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Beneficiaries](
	[FounderCustomerID] [int] NULL,
	[LinkedUser] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Branch]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branch](
	[Branch_ID] [int] NOT NULL,
	[Bank_ID] [int] NULL,
	[BranchName] [varchar](50) NULL,
	[Location] [varchar](150) NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[Branch_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Card_]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Card_](
	[Card_Number] [char](13) NOT NULL,
	[PIN] [int] NULL,
	[Type] [int] NULL,
	[Bank_ID] [int] NULL,
	[AccountNumber] [int] NULL,
	[ExpiryDate] [datetime] NULL,
	[Issuer] [varchar](30) NULL,
	[issueDate] [datetime] NULL,
 CONSTRAINT [PK_Card_] PRIMARY KEY CLUSTERED 
(
	[Card_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CashDeposit]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CashDeposit](
	[TransactionID] [int] NOT NULL,
	[CashDeposited] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Age] [int] NULL,
	[Phone] [int] NULL,
	[Address] [varchar](150) NULL,
	[BirthDate] [date] NULL,
 CONSTRAINT [PK_Customer-] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Inquiry]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Inquiry](
	[TransactionID] [int] NULL,
	[BalanceAvailable] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Parts]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parts](
	[PartID] [varchar](10) NOT NULL,
	[PartName] [nvarchar](50) NULL,
	[ATM_ID] [int] NULL,
	[Price] [int] NULL,
	[DeploymentDate] [datetime] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_Parts] PRIMARY KEY CLUSTERED 
(
	[PartID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transfer]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transfer](
	[TransactionID] [int] NULL,
	[CashTransfered] [int] NULL,
	[TransferedToAcc] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Withdrawl]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Withdrawl](
	[TransactionID] [int] NULL,
	[CashWithdrawn] [int] NULL
) ON [PRIMARY]
GO
INSERT [dbo].[Account] ([AccountNumber], [Balance], [OpeningDate], [Bank_ID], [Type], [FounderCustomerID]) VALUES (12345678, 79020, CAST(N'2020-05-04T00:00:00.000' AS DateTime), 2, 4, 1)
INSERT [dbo].[Account] ([AccountNumber], [Balance], [OpeningDate], [Bank_ID], [Type], [FounderCustomerID]) VALUES (32121224, 80500, CAST(N'2019-02-09T00:00:00.000' AS DateTime), 3, 4, 2)
GO
INSERT [dbo].[ATM-Machine] ([ATM_ID], [ATM_Address], [Status], [CashAvailable], [Afflilated_BranchID], [TerminalFee]) VALUES (1, N'Khushali  Bhagbanpura Branch Lahore', N'Active', 99500, 3, 20)
INSERT [dbo].[ATM-Machine] ([ATM_ID], [ATM_Address], [Status], [CashAvailable], [Afflilated_BranchID], [TerminalFee]) VALUES (2, N'Bank Al-Habib Mughalpura Branch Lahore', N'Active', 70000, 4, 20)
GO
INSERT [dbo].[Bank] ([Bank_ID], [BankName], [Helpline], [HQLocation], [Alias]) VALUES (1, N'Habib Bank Limited', N'(021) 111 111 425', N' 9th Floor, HBL Tower, Jinnah Avenue, Blue Area, Karachi', N'HBL')
INSERT [dbo].[Bank] ([Bank_ID], [BankName], [Helpline], [HQLocation], [Alias]) VALUES (2, N'United Bank Limited', N'(+9221) 111 825 888', N'17th Floor Park Place Building Sh.Karachi', N'UBL')
INSERT [dbo].[Bank] ([Bank_ID], [BankName], [Helpline], [HQLocation], [Alias]) VALUES (3, N'Bank Al-Habib', N'(021) 111 014 014', N'Plot No. 784/75, Islamabad Corporate Centro, Opposite CMT and SD, Golra Road, Islamabad.', N'BAL')
INSERT [dbo].[Bank] ([Bank_ID], [BankName], [Helpline], [HQLocation], [Alias]) VALUES (4, N'Mezaan Bank Limited', N'111 331 332', N'Meezan House, C-25 Estate Avenue, SITE, Karachi', N'MBL')
INSERT [dbo].[Bank] ([Bank_ID], [BankName], [Helpline], [HQLocation], [Alias]) VALUES (5, N'Khushali ', N'021 111 727 273', N' The Director Consumer Protection Department - SBP 5th Floor, SBP Main Building, I. I. Chundrigar Road Karachi', N'KMB')
INSERT [dbo].[Bank] ([Bank_ID], [BankName], [Helpline], [HQLocation], [Alias]) VALUES (6, N'Allied Bank Limited', N'111 225 225', N' Allied Tower, Abdali Road, Multan', N'ABL')
GO
INSERT [dbo].[Branch] ([Branch_ID], [Bank_ID], [BranchName], [Location]) VALUES (1, 2, N'Mughalura branch', N'Lahore')
INSERT [dbo].[Branch] ([Branch_ID], [Bank_ID], [BranchName], [Location]) VALUES (2, 4, N'Multan Road branch', N'Vehari')
INSERT [dbo].[Branch] ([Branch_ID], [Bank_ID], [BranchName], [Location]) VALUES (3, 5, N'Bhagbanpura Branch', N'Lahore')
INSERT [dbo].[Branch] ([Branch_ID], [Bank_ID], [BranchName], [Location]) VALUES (4, 3, N'Mughalpura Branch', N'Lahore')
INSERT [dbo].[Branch] ([Branch_ID], [Bank_ID], [BranchName], [Location]) VALUES (5, 1, N'Band Road Branch', N'Lahore')
INSERT [dbo].[Branch] ([Branch_ID], [Bank_ID], [BranchName], [Location]) VALUES (6, 2, N'Androon Sher Lahore Branch', N'Lahore')
INSERT [dbo].[Branch] ([Branch_ID], [Bank_ID], [BranchName], [Location]) VALUES (7, 2, N'Tandliaanwala Branch', N'Multan')
INSERT [dbo].[Branch] ([Branch_ID], [Bank_ID], [BranchName], [Location]) VALUES (8, 1, N'UET Branch', N'Texila')
INSERT [dbo].[Branch] ([Branch_ID], [Bank_ID], [BranchName], [Location]) VALUES (9, 1, N'Comsats Branch', N'Faislabad')
INSERT [dbo].[Branch] ([Branch_ID], [Bank_ID], [BranchName], [Location]) VALUES (10, 3, N'Shala Mar Bagh branch', NULL)
GO
INSERT [dbo].[Card_] ([Card_Number], [PIN], [Type], [Bank_ID], [AccountNumber], [ExpiryDate], [Issuer], [issueDate]) VALUES (N'1111111111111', 1111, 4, 1, 12345678, CAST(N'2023-06-12T00:00:00.000' AS DateTime), N'Link1', CAST(N'2011-04-01T00:00:00.000' AS DateTime))
INSERT [dbo].[Card_] ([Card_Number], [PIN], [Type], [Bank_ID], [AccountNumber], [ExpiryDate], [Issuer], [issueDate]) VALUES (N'2222222222222', 1111, 3, 2, 32121224, CAST(N'2028-01-01T00:00:00.000' AS DateTime), N'Link1', CAST(N'2019-02-11T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[CashDeposit] ([TransactionID], [CashDeposited]) VALUES (35, 1500)
INSERT [dbo].[CashDeposit] ([TransactionID], [CashDeposited]) VALUES (36, 1000)
INSERT [dbo].[CashDeposit] ([TransactionID], [CashDeposited]) VALUES (37, 1500)
INSERT [dbo].[CashDeposit] ([TransactionID], [CashDeposited]) VALUES (38, 1000)
INSERT [dbo].[CashDeposit] ([TransactionID], [CashDeposited]) VALUES (39, 1000)
INSERT [dbo].[CashDeposit] ([TransactionID], [CashDeposited]) VALUES (40, 1000)
INSERT [dbo].[CashDeposit] ([TransactionID], [CashDeposited]) VALUES (41, 1000)
GO
INSERT [dbo].[Customer] ([CustomerID], [FirstName], [LastName], [Age], [Phone], [Address], [BirthDate]) VALUES (1, N'Ali', N'Ahmed', 20, NULL, N'bhagbanpura,Lahore', CAST(N'2001-01-23' AS Date))
INSERT [dbo].[Customer] ([CustomerID], [FirstName], [LastName], [Age], [Phone], [Address], [BirthDate]) VALUES (2, N'Talha', N'Shamas', NULL, NULL, N'Peer Colony', CAST(N'2003-01-01' AS Date))
GO
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (1, N'1111111111111', N'cash withdrawal', N'Completed', 1, CAST(N'2022-04-29T09:37:08.950' AS DateTime), 19000, 17000)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (2, N'1111111111111', N'cash withdrawal', N'Completed', 1, CAST(N'2022-04-29T09:42:24.327' AS DateTime), 17000, 16500)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (3, N'1111111111111', N'cash withdrawal', N'Completed', 1, CAST(N'2022-04-29T10:17:41.683' AS DateTime), 15000, 12000)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (4, N'1111111111111', N'Cash deposit', N'Completed', 1, CAST(N'2022-04-29T10:19:27.263' AS DateTime), 12000, 16000)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (5, N'1111111111111', N'cash withdrawal', N'Completed', 1, CAST(N'2022-04-29T10:37:12.270' AS DateTime), 16000, 2000)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (6, N'1111111111111', N'cash withdrawal', N'Completed', 1, CAST(N'2022-04-29T10:42:05.330' AS DateTime), 14000, 9000)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (7, N'1111111111111', N'cash withdrawal', N'Completed', 1, CAST(N'2022-04-29T10:49:30.430' AS DateTime), 9000, 4000)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (8, N'1111111111111', N'cash withdrawal', N'Completed', 1, CAST(N'2022-04-29T10:52:12.107' AS DateTime), 4000, 1000)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (9, N'1111111111111', N'cash withdrawal', N'Completed', 1, CAST(N'2022-04-29T12:02:59.987' AS DateTime), 100000, 99500)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (10, N'1111111111111', N'cash withdrawal', N'Completed', 1, CAST(N'2022-04-29T12:04:08.320' AS DateTime), 99500, 98500)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (11, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T14:01:56.250' AS DateTime), 98500, 500)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (12, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T14:31:23.693' AS DateTime), 117980, 116980)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (13, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T17:34:39.720' AS DateTime), 116960, 116460)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (14, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T17:39:48.613' AS DateTime), 116440, 115940)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (15, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T17:53:28.350' AS DateTime), 115920, 114920)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (16, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T17:53:44.470' AS DateTime), 114900, 112900)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (17, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T17:54:43.810' AS DateTime), 112880, 111880)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (18, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T17:54:50.060' AS DateTime), 112880, 111880)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (19, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T18:10:14.600' AS DateTime), 110840, 109840)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (20, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T18:12:00.993' AS DateTime), 109820, 108820)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (21, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T18:13:18.970' AS DateTime), 108800, 107800)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (22, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T18:14:35.260' AS DateTime), 107780, 106780)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (23, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T18:17:41.893' AS DateTime), 106760, 105760)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (24, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T18:19:51.603' AS DateTime), 105740, 85740)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (25, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T18:42:06.327' AS DateTime), 85720, 84720)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (26, N'1111111111111', N'1', N'Completed', 1, CAST(N'2022-04-29T18:46:02.430' AS DateTime), 84700, 84180)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (27, N'1111111111111', N'Cash Withdrawal', N'Completed', 1, CAST(N'2022-04-29T20:21:04.403' AS DateTime), 84180, 82160)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (28, N'1111111111111', N'Cash Withdrawal', N'Completed', 1, CAST(N'2022-04-29T21:58:42.310' AS DateTime), 82160, 81140)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (29, N'1111111111111', N'Cash Withdrawal', N'Completed', 1, CAST(N'2022-04-29T22:59:49.557' AS DateTime), 81140, 79120)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (30, N'1111111111111', N'Cash Withdrawal', N'Completed', 1, CAST(N'2022-04-29T23:03:09.473' AS DateTime), 79120, 78100)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (31, N'1111111111111', N'Cash Withdrawal', N'Completed', 1, CAST(N'2022-04-29T23:04:05.767' AS DateTime), 78100, 76080)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (32, N'1111111111111', N'Cash Withdrawal', N'Completed', 1, CAST(N'2022-04-29T23:04:49.297' AS DateTime), 76080, 74060)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (33, N'1111111111111', N'Cash Withdrawal', N'Completed', 1, CAST(N'2022-04-29T23:07:18.800' AS DateTime), 74060, 73040)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (34, N'1111111111111', N'Cash Withdrawal', N'Completed', 1, CAST(N'2022-04-29T23:20:19.097' AS DateTime), 73040, 71020)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (35, N'1111111111111', N'Cash Deposit', N'Completed', 1, CAST(N'2022-04-30T00:51:20.350' AS DateTime), 71020, 69500)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (36, N'1111111111111', N'Cash Deposit', N'Completed', 1, CAST(N'2022-04-30T00:52:47.567' AS DateTime), 72520, 71500)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (37, N'1111111111111', N'Cash Deposit', N'Completed', 1, CAST(N'2022-04-30T01:06:13.527' AS DateTime), 73520, 75000)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (38, N'1111111111111', N'Cash Deposit', N'Completed', 1, CAST(N'2022-04-30T01:27:27.850' AS DateTime), 75020, 76000)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (39, N'1111111111111', N'Cash Deposit', N'Completed', 1, CAST(N'2022-04-30T01:37:14.160' AS DateTime), 76020, 77000)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (40, N'1111111111111', N'Account Transfer', N'Completed', 1, CAST(N'2022-04-30T03:55:43.750' AS DateTime), 77020, 78000)
INSERT [dbo].[Transaction] ([TransactionID], [Card_ID], [Type], [Status], [ATM_ID], [TransactionTime], [PreviousBalance], [NewBalance]) VALUES (41, N'1111111111111', N'Account Transfer', N'Completed', 1, CAST(N'2022-04-30T03:56:05.057' AS DateTime), 77020, 78000)
GO
INSERT [dbo].[Transfer] ([TransactionID], [CashTransfered], [TransferedToAcc]) VALUES (2, 3000, 32121224)
GO
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (1, 3000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (3, 3000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (4, 3000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (4, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (5, 2000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (6, 5000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (7, 5000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (8, 3000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (15, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (16, 2000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (17, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (18, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (19, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (24, 20000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (26, 500)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (11, 98000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (13, 500)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (20, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (21, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (22, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (23, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (27, 2000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (29, 2000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (34, 2000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (9, 500)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (10, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (12, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (14, 500)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (25, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (28, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (30, 1000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (31, 2000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (32, 2000)
INSERT [dbo].[Withdrawl] ([TransactionID], [CashWithdrawn]) VALUES (33, 1000)
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Account_Customer-] FOREIGN KEY([FounderCustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [FK_Account_Customer-]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [FK_Bank_Account] FOREIGN KEY([Bank_ID])
REFERENCES [dbo].[Bank] ([Bank_ID])
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [FK_Bank_Account]
GO
ALTER TABLE [dbo].[ATM-Machine]  WITH CHECK ADD  CONSTRAINT [FK_ATM-Machine_Branch] FOREIGN KEY([Afflilated_BranchID])
REFERENCES [dbo].[Branch] ([Branch_ID])
GO
ALTER TABLE [dbo].[ATM-Machine] CHECK CONSTRAINT [FK_ATM-Machine_Branch]
GO
ALTER TABLE [dbo].[Beneficiaries]  WITH CHECK ADD  CONSTRAINT [FK_Beneficiaries_Customer-] FOREIGN KEY([FounderCustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[Beneficiaries] CHECK CONSTRAINT [FK_Beneficiaries_Customer-]
GO
ALTER TABLE [dbo].[Branch]  WITH CHECK ADD  CONSTRAINT [FK_Bank_Branch] FOREIGN KEY([Bank_ID])
REFERENCES [dbo].[Bank] ([Bank_ID])
GO
ALTER TABLE [dbo].[Branch] CHECK CONSTRAINT [FK_Bank_Branch]
GO
ALTER TABLE [dbo].[Card_]  WITH CHECK ADD  CONSTRAINT [FK_Card__Account] FOREIGN KEY([AccountNumber])
REFERENCES [dbo].[Account] ([AccountNumber])
GO
ALTER TABLE [dbo].[Card_] CHECK CONSTRAINT [FK_Card__Account]
GO
ALTER TABLE [dbo].[Card_]  WITH CHECK ADD  CONSTRAINT [FK_Card__Bank] FOREIGN KEY([Bank_ID])
REFERENCES [dbo].[Bank] ([Bank_ID])
GO
ALTER TABLE [dbo].[Card_] CHECK CONSTRAINT [FK_Card__Bank]
GO
ALTER TABLE [dbo].[CashDeposit]  WITH CHECK ADD  CONSTRAINT [FK_CashDeposit_Transaction] FOREIGN KEY([TransactionID])
REFERENCES [dbo].[Transaction] ([TransactionID])
GO
ALTER TABLE [dbo].[CashDeposit] CHECK CONSTRAINT [FK_CashDeposit_Transaction]
GO
ALTER TABLE [dbo].[Inquiry]  WITH CHECK ADD  CONSTRAINT [FK_Inquiry_Transaction] FOREIGN KEY([TransactionID])
REFERENCES [dbo].[Transaction] ([TransactionID])
GO
ALTER TABLE [dbo].[Inquiry] CHECK CONSTRAINT [FK_Inquiry_Transaction]
GO
ALTER TABLE [dbo].[Parts]  WITH CHECK ADD  CONSTRAINT [FK_Parts_ATM-Machine] FOREIGN KEY([ATM_ID])
REFERENCES [dbo].[ATM-Machine] ([ATM_ID])
GO
ALTER TABLE [dbo].[Parts] CHECK CONSTRAINT [FK_Parts_ATM-Machine]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_Transaction_ATM-Machine] FOREIGN KEY([ATM_ID])
REFERENCES [dbo].[ATM-Machine] ([ATM_ID])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_Transaction_ATM-Machine]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_Transaction_Card_] FOREIGN KEY([Card_ID])
REFERENCES [dbo].[Card_] ([Card_Number])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_Transaction_Card_]
GO
ALTER TABLE [dbo].[Transfer]  WITH CHECK ADD  CONSTRAINT [FK_Transfer_Transaction] FOREIGN KEY([TransactionID])
REFERENCES [dbo].[Transaction] ([TransactionID])
GO
ALTER TABLE [dbo].[Transfer] CHECK CONSTRAINT [FK_Transfer_Transaction]
GO
ALTER TABLE [dbo].[Withdrawl]  WITH CHECK ADD  CONSTRAINT [FK_Withdrawl_Transaction] FOREIGN KEY([TransactionID])
REFERENCES [dbo].[Transaction] ([TransactionID])
GO
ALTER TABLE [dbo].[Withdrawl] CHECK CONSTRAINT [FK_Withdrawl_Transaction]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [CK_Account] CHECK  (([Balance]>(0)))
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [CK_Account]
GO
ALTER TABLE [dbo].[Account]  WITH CHECK ADD  CONSTRAINT [CK_date] CHECK  (([OpeningDate]>(((1992)-(1))-(1))))
GO
ALTER TABLE [dbo].[Account] CHECK CONSTRAINT [CK_date]
GO
ALTER TABLE [dbo].[ATM-Machine]  WITH CHECK ADD  CONSTRAINT [CK_ATM-Balance] CHECK  (([CashAvailable]>=(0)))
GO
ALTER TABLE [dbo].[ATM-Machine] CHECK CONSTRAINT [CK_ATM-Balance]
GO
ALTER TABLE [dbo].[Card_]  WITH CHECK ADD  CONSTRAINT [CK_expirydate_] CHECK  (([ExpiryDate]>[issueDate]))
GO
ALTER TABLE [dbo].[Card_] CHECK CONSTRAINT [CK_expirydate_]
GO
ALTER TABLE [dbo].[CashDeposit]  WITH CHECK ADD  CONSTRAINT [CK_CashDeposit] CHECK  (([CashDeposited]>(0)))
GO
ALTER TABLE [dbo].[CashDeposit] CHECK CONSTRAINT [CK_CashDeposit]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD CHECK  (([Age]>=(18)))
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [CK_PhoneLength] CHECK  ((len([Phone])=(11)))
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [CK_PhoneLength]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [CK_Transaction] CHECK  (([PreviousBalance]>=(0) AND [NewBalance]>(0)))
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [CK_Transaction]
GO
/****** Object:  StoredProcedure [dbo].[ATMAddresss]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ATMAddresss]
AS
select ATM_Address = BankName+' '+BranchName+' '+B.Locattion FROM Branch B JOIN [ATM-Machine] A ON A.Afflilated_BranchID = B.Branch_ID 
JOIN Bank Ba ON B.Bank_ID = Ba.Bank_ID
GO
/****** Object:  StoredProcedure [dbo].[GetReceipt]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetReceipt]
 @cardID varchar(14)
 AS
SELECT TransactionTime, TransactionID, Card_ID, [Type], (SELECT ATM_Address from [ATM-Machine] WHERE ATM_ID = 1) as ATM, 
(SELECT FirstName+' '+LastName FROM Customer where CustomerID = (Select CustomerID FROM Account where AccountNumber = (SELECT AccountNumber from Card_ where Card_Number = @cardID)))
[NAME], (SELECT CashWithdrawn FROM Withdrawl where TransactionID = (Select MAX(TransactionID) FROM [Transaction])) as Amount, PreviousBalance, NewBalance 
FROM [Transaction] where TransactionID =  (Select MAX(TransactionID) FROM [Transaction])
 
GO
/****** Object:  StoredProcedure [dbo].[GetWithdrawanReceipt]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetWithdrawanReceipt]
@cardID varchar(14)  
AS  SELECT TransactionTime, TransactionID, Card_ID, [Type],
(SELECT ATM_Address from [ATM-Machine] WHERE ATM_ID = 1) as ATM,   
(SELECT FirstName+' '+LastName FROM Customer where CustomerID = 
(Select CustomerID FROM Account where AccountNumber =
(SELECT AccountNumber from Card_ where Card_Number = @cardID)))  [NAME],
(SELECT CashDeposited FROM CashDeposit where TransactionID = (Select MAX(TransactionID) FROM [Transaction])) as Amount, PreviousBalance, NewBalance  
FROM [Transaction] where TransactionID =  (Select MAX(TransactionID) FROM [Transaction])   
GO
/****** Object:  StoredProcedure [dbo].[miniStatment]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[miniStatment]
@CardID varchar(14)
AS
Select TOP(10) T.TransactionID as [Tr#],T.TransactionTime [Date/Time],T.Card_ID [Card#], (SELECT ATM_Address FROM [ATM-Machine] Where ATM_ID = T.ATM_ID) AS  ATM ,T.[Status],T.[Type],T.PreviousBalance [PREVIOUS CASH], T.NewBalance [NEW CASH],  ABS(PreviousBalance - NewBalance)  as [DEDUCTION/DEPOSIT] from [Transaction] T where Card_ID = @CardID Order by [Date/Time] DESC
GO
/****** Object:  StoredProcedure [dbo].[spUpdateAddresss]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateAddresss]
AS
Update [ATM-Machine]
SET ATM_Address = BankName+' '+BranchName+' '+B.Locattion FROM Branch B JOIN [ATM-Machine] A ON A.Afflilated_BranchID = B.Branch_ID 
JOIN Bank Ba ON B.Bank_ID = Ba.Bank_ID where
ATM_Address is NULL;


GO
/****** Object:  StoredProcedure [dbo].[ViewSP]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ViewSP]
AS
SELECT * 
  FROM [DatabaseDesign-GID11].INFORMATION_SCHEMA.ROUTINES
 WHERE ROUTINE_TYPE = 'PROCEDURE'
GO
/****** Object:  Trigger [dbo].[AddBalance]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE TRIGGER [dbo].[AddBalance] 
   ON  [dbo].[Account]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	Update Account set Balance = 0
	where Balance is NULL

END

GO
ALTER TABLE [dbo].[Account] ENABLE TRIGGER [AddBalance]
GO
/****** Object:  Trigger [dbo].[CalculateAge]    Script Date: 4/30/2022 4:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Umair Manzoor>
-- Description:	<Calculate Age of each individual>
-- =============================================
CREATE TRIGGER [dbo].[CalculateAge]
   ON  [dbo].[Customer]
   AFTER INSERT
AS 
BEGIN
	Update Customer
	Set AGE =  datediff(Year,C.Birthdate,getdate())
	From Customer C
	where AGE is Null

END

select datediff(Year,C.Birthdate,getdate()) as age From Customer C
GO
ALTER TABLE [dbo].[Customer] ENABLE TRIGGER [CalculateAge]
GO
