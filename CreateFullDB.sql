create database dbSample;
USE dbSample;

create table CurrencyType(
  CurrencyTypeId integer not null identity(1,1) primary key,
  CurrencyCode varchar(5) not null,
  CurrencyName nvarchar(50)
);

insert into dbSample.dbo.CurrencyType (CurrencyCode, CurrencyName) values
('USD', 'ABD Dolarý'),
('EUR', 'Avrupa Para Birimi'),
('AUD', 'Avustralya Dolarý'),
('DKK', 'Danimarka Kronu'),
('GBP', 'Ýngiliz Sterlini'),
('CHF', 'Ýsviçre Frangý'),
('SEK', 'Ýsveç Kronu'),
('CAD', 'Kanada Dolarý'),
('KWD', 'Kuveyt Dinarý'),
('NOK', 'Norveç Kronu'),
('SAR', 'Suudi Arabistan Riyali'),
('JPY', 'Japon Yeni');

create table CurrencyDailyRate(
  CurrencyDailyRateId integer not null identity(1,1) primary key,
  CurrencyDate date not null,
  CurrencyTypeId integer not null,
  BuyingRate float default 0,
  SellingRate float default 0,
  CONSTRAINT FK_CurrencyDailyRate_CurrencyType FOREIGN KEY (CurrencyTypeId)     
    REFERENCES CurrencyType (CurrencyTypeId)
);
create table Customer(
  CustomerId integer not null identity(1,1) primary key,
  CustomerName nvarchar(100) null,
  AddressLine1 nvarchar(50) null,
  AddressLine2 nvarchar(50) null,
  AddressLine3 nvarchar(50) null,
  City nvarchar(50) null,
  Country nvarchar(50) null,
  PostCode nvarchar(20) null,
  ContactPerson nvarchar(50) null,
  Phone varchar(15) null,
  Fax varchar(15) null,
  ContactEMail nvarchar(100) null,
  CurrencyTypeId integer,
  TotalDebit float default 0,
  TotalCredit float default 0,
  Balance float default 0,
  PaymentDueDate integer default 0,
  InBlackList bit not null default 0,
  IsActive bit not null default 1,
  CONSTRAINT FK_Customer_CurrencyType FOREIGN KEY (CurrencyTypeId)     
    REFERENCES CurrencyType (CurrencyTypeId)
);


insert into [dbSample].dbo.Customer 
(CustomerName, AddressLine1, AddressLine2, AddressLine3, City, Country, ContactPerson, Phone, Fax, ContactEMail) 
values
('Kart Dekorasyon Malzemeleri ve Müt.Hiz. A.Þ.', 'Bedesten Sok. Katmerli Han No:4/13 Kat:3', 'Karaköy', '', 'Ýstanbul', 'Türkiye', 'Ahmet Alagöz', '0532717717', '02127127272', 'a-alagoz@gmail.com'),
('Damak Þekercilik ve Pastacýlýk Ltd.', 'Limon Sok. Hacýoðlu Ap. No:12/1', 'Göztepe', '', 'Ýstanbul', 'Türkiye', 'Murat Yapan', '05327177818', '02127127273', 'muratyapan@damak.com.tr');

create table Supplier(
  SupplierId integer not null identity(1,1) primary key,
  SupplierName nvarchar(100) null,
  AddressLine1 nvarchar(50) null,
  AddressLine2 nvarchar(50) null,
  AddressLine3 nvarchar(50) null,
  City nvarchar(50) null,
  Country nvarchar(50) null,
  PostCode nvarchar(20) null,
  ContactPerson nvarchar(50) null,
  Phone varchar(15) null,
  Fax varchar(15) null,
  ContactEMail nvarchar(100) null,
  CurrencyTypeId integer,
  TotalDebit float default 0,
  TotalCredit float default 0,
  Balance float default 0,
  PaymentDueDate integer default 0,
  InBlackList bit not null default 0,
  IsActive bit not null default 1,
  CONSTRAINT FK_Supplier_CurrencyType FOREIGN KEY (CurrencyTypeId)     
    REFERENCES CurrencyType (CurrencyTypeId)
);

insert into Supplier 
(SupplierName, AddressLine1, AddressLine2, AddressLine3, City, Country, ContactPerson, Phone, Fax, ContactEMail) 
values
('Kartel Yemek ve Ýkram Üretim ve Satýþ A.Þ.', '', 'Ümraniye', '', 'Ýstanbul', 'Türkiye', 'Mehmet Yurdan', '0532717719', '02127127274', 'mehmetyurdan@gmail.com'),
('Alaylý Otomotiv San. ve Tic. A.Þ.', 'Yalý Cad. Nur Han No:15/44 Kat 4', 'Karaköy', '', 'Ýstanbul', 'Türkiye', 'Yelda Saran', '05327177819', '02127127275', 'yeldasaran@alayliotomotiv.com.tr');


create table InventoryGroup(
  InventoryGroupId integer not null identity(1,1) primary key,
  InventoryGroupName nvarchar(100) not null
);

insert into InventoryGroup (InventoryGroupName) values 
('Kaðýt'),
('Defter'),
('Kalem'),
('Ders kitabý'),
('Edebi kitaplar'),
('Oyuncak'),
('Diðer'),
('Sarf malzemeleri'),
('Hizmet');



create table Inventory(
  InventoryId integer not null identity(1,1) primary key,
  InventoryGroupId integer not null,
  MainSupplierId integer null,
  InventoryCode nvarchar(30) not null,
  InventoryName nvarchar(100) not null,
  SpecCode nvarchar(20) null,
  StoragePlace nvarchar(100) null,
  PictureFileName nvarchar(100) null,
  Measurements nvarchar(50) null,
  CurrencyTypeId integer null,
  BuyingPrice float null,
  SellingPrice float null,
  VatPercentage float null,
  TotalIncomingQtty float default 0,
  TotalOutgoingQtty float default 0,
  TotalIncomingAmount float default 0,
  TotalOutgoingAmount float default 0,

  OtvAmount float default 0,
  UnitDesc nvarchar(10) null,

  ReorderPoint float default 0,
  BufferStock float default 0,
  IsActive bit default 1,

  CONSTRAINT FK_Inventory_InventoryGroup FOREIGN KEY (InventoryGroupId)     
    REFERENCES InventoryGroup (InventoryGroupId)
);
use dbSample;
insert into Inventory 
(InventoryGroupId, MainSupplierId, InventoryCode, InventoryName,                        SpecCode, StoragePlace, Measurements, CurrencyTypeId, BuyingPrice, SellingPrice, VatPercentage, OtvAmount, UnitDesc, ReorderPoint, BufferStock)
  values
(1,                0,              'KAG80-1',	  'Kaðýt 80 gram 1. hamur',				 '',       'C18R5',      'A4,80gr',    null, 15,  19,  18, null, 'Paket', 100, 20),
(1, 0,							   'KAG90-1',	  'Kaðýt 90 gram 1. hamur',				 '',       'C18R6',      'A4,90gr',    null, 20,  25,  18, null, 'Paket', 40, 5),
(2, 0,                             'DEFHMO160-3', 'Defter Harita Metot 1 orta 3. hamur', '',	   'C18R4',		 'B3,60yaprak',null, 10,  13,  18, null, 'Adet',  90, 10),
(3, 0,                             'RSKLSA3',     'Resim Kalemi Siyah A3',				 'kkk',    'R-B18',      '',           2,    1.2, 1.4, 18, null, 'Adet', 80, 10);

create table PurchaseInvoiceHeader(
  PurchaseInvoiceHeaderId integer not null identity(1, 1) primary key,
  InvoiceDate datetime not null,
  InvoiceNumber nvarchar(20),
  SupplierId integer not null,
  SpecCode nvarchar(20) null,
  InvDescription nvarchar(100) null,
  CurrencyTypeId integer,
  CurrencyRate float,
  TotalAmount float,
  VatPercentage1 float,
  VatAmount1 float,
  VatPercentage2 float,
  VatAmount2 float,
  VatPercentage3 float,
  VatAmount3 float,
  TotalOtvAmount float,
  DueDate integer default 0,
  Paid bit default 0,
  MailAddress1 nvarchar(50) NULL,
  MailAddress2 nvarchar(50) NULL,
  MailAddress3 nvarchar(50) NULL,
  MailCity nvarchar(50) NULL,
  MailCountry nvarchar(50) NULL,
  MailPostCode nvarchar(20) NULL,
  CONSTRAINT FK_PurchaseInvoiceHeader_Supplier FOREIGN KEY (SupplierId)     
    REFERENCES Supplier (SupplierId),
  CONSTRAINT FK_PurchaseInvoiceHeader_CurrencyType FOREIGN KEY (CurrencyTypeId)     
    REFERENCES CurrencyType (CurrencyTypeId)
);

create table PurchaseInvoiceDetail(
  PurchaseInvoiceDetailId integer not null identity(1,1) primary key,
  PurchaseInvoiceHeaderId integer not null,
  InventoryId integer not null,
  Quantity float not null default 0,
  UnitPrice float not null,
  VatPercentage float default 0,
  VatAmount float default 0,
  OtvAmount float default 0,
  TotalAmount float,
  SpecCode varchar(20) null,
  LineDescription nvarchar(100) null,
  InvoiceDate datetime not null,
  SupplierId integer not null,
  CurrencyTypeId integer,
  CurrencyRate float,

  CONSTRAINT FK_PurchaseInvoiceDetail_PurchaseInvoiceHeader FOREIGN KEY (PurchaseInvoiceHeaderId)     
    REFERENCES PurchaseInvoiceHeader (PurchaseInvoiceHeaderId),
  CONSTRAINT FK_PurchaseInvoiceDetail_Inventory FOREIGN KEY (InventoryId)     
    REFERENCES Inventory (InventoryId)
);

create table SalesInvoiceHeader(
  SalesInvoiceHeaderId integer not null identity(1,1) primary key,
  InvoiceDate datetime not null,
  InvoiceNumber nvarchar(20),
  CustomerId integer not null,
  SpecCode varchar(20) null,
  InvDescription nvarchar(100) null,
  CurrencyTypeId integer,
  CurrencyRate float,
  TotalAmount float,
  VatPercentage1 float,
  VatAmount1 float,
  VatPercentage2 float,
  VatAmount2 float,
  VatPercentage3 float,
  VatAmount3 float,
  TotalOtvAmount float,
  DueDate integer default 0,
  Paid bit default 0,
  DeliveryAddress1 nvarchar(50) null,
  DeliveryAddress2 nvarchar(50) null,
  DeliveryAddress3 nvarchar(50) null,
  DeliveryCity nvarchar(50) null,
  DeliveryCountry nvarchar(50) null,
  DeliveryPostCode nvarchar(20) null,
  CONSTRAINT FK_SalesInvoiceHeader_Customer FOREIGN KEY (CustomerId)     
    REFERENCES Customer (CustomerId),
  CONSTRAINT FK_SalesInvoiceHeader_CurrencyType FOREIGN KEY (CurrencyTypeId)     
    REFERENCES CurrencyType (CurrencyTypeId)
);

create table SalesInvoiceDetail(
  SalesInvoiceDetailId integer not null identity(1,1) primary key,
  SalesInvoiceHeaderId integer not null,
  InventoryId integer not null,
  Quantity float not null default 0,
  UnitPrice float not null,
  VatPercentage float default 0,
  VatAmount float default 0,
  OtvAmount float default 0,
  TotalAmount float,
  SpecCode nvarchar(20),
  LineDescription nvarchar(100) null,
  InvoiceDate datetime not null,
  CustomerId integer not null,
  CurrencyTypeId integer,
  CurrencyRate float,
  CONSTRAINT FK_SalesInvoiceDetail_SalesInvoiceHeader FOREIGN KEY (SalesInvoiceHeaderId)     
    REFERENCES SalesInvoiceHeader (SalesInvoiceHeaderId),
  CONSTRAINT FK_SalesInvoiceDetail_Inventory FOREIGN KEY (InventoryId)     
    REFERENCES Inventory (InventoryId)
);

create table secUser(
  UserId integer not null identity(1,1) primary key,
  UserName varchar(50) not null,
  Pswd varchar(150) not null,
  IsActive bit not null default 1
);

insert into secUser(UserName, Pswd) values ('m1', 'a'), ('m2', 'a'), ('m3', 'a');

create table secGroup(
  GroupId integer not null identity(1,1) primary key,
  GroupName varchar(50) not null,
  IsActive bit not null default 1
);

insert into secGroup(GroupName) values('Admin'), ('Satýþ'), ('Muhasebe'), ('Depo');

create table secGroupUser(
  GroupId integer not null, 
  UserId integer not null,
  CONSTRAINT secGroupUser_pk PRIMARY KEY (GroupId, UserId)
);

insert into secGroupUser values(1, 1), (2,2), (3,3), (4,3);

create table secPermission(
  PermissionId integer not null primary key,
  PermDescription nvarchar(50),
  ParentId integer default 0,
  IsActive bit not null default 1
);

insert into secPermission(PermissionId, PermDescription, ParentId) values 
   (1, 'Tüm iþlemler', 0),
   (100, 'Güvenlik yetkileri', 1),
   (101, 'Kullanýcý kayýtlarý', 100),
   (102, 'Kullanýcý ekleme', 101),
   (103, 'Kullanýcý düzelt', 101),
   (104, 'Kullanýcý sil', 101),
   (105, 'Kullanýcý incele', 101),
   (111, 'Grup kayýtlarý', 100),
   (112, 'Grup ekleme', 111),
   (113, 'Grup düzelt', 111),
   (114, 'Grup sil', 111),
   (115, 'Grup incele', 111),
   (121, 'Ýzin kayýtlarý', 100),
   (122, 'Ýzin ekleme', 121),
   (123, 'Ýzin düzelt', 121),
   (124, 'Ýzin sil', 121),
   (125, 'Ýzin incele', 121),
   
   (500, 'Döviz iþlemleri', 1),
   (510, 'Döviz kodlarý', 500),
   (511, 'Döviz kodu ekle', 510),
   (512, 'Döviz kodu düzelt', 510),
   (513, 'Döviz kodu sil', 510),
   (514, 'Döviz kodu incele', 510),

   (520, 'Döviz kurlarý', 500),
   (521, 'Günlük kur giriþleri', 520),
   (522, 'Günlük kurlarý indir', 520),
   (523, 'Günlük kur raporlarý', 520),

   (1000, 'Ticari sistem tüm iþlemler', 1),
   (1010, 'Müþteri iþlemleri', 1000),
   (1011, 'Müþteri ekle', 1010),
   (1012, 'Müþteri düzelt', 1010),
   (1013, 'Müþteri sil', 1010),
   (1014, 'Müþteri ekle', 1010),

   (1020, 'Satýcý firma iþlemleri', 1000),
   (1021, 'Satýcý firma ekle', 1020),
   (1022, 'Satýcý firma düzelt', 1020),
   (1023, 'Satýcý firma sil', 1020),
   (1024, 'Satýcý firma ekle', 1020),

   (1030, 'Stok grubu iþlemleri', 1000),
   (1031, 'Stok grubu ekle', 1030),
   (1032, 'Stok grubu düzelt', 1030),
   (1033, 'Stok grubu sil', 1030),
   (1034, 'Stok grubu incele', 1030),

   (1040, 'Stok iþlemleri', 1000),
   (1041, 'Stok ekle', 1040),
   (1042, 'Stok düzelt', 1040),
   (1043, 'Stok sil', 1040),
   (1044, 'Stok incele', 1040),

   (1050, 'Satýnalma fatura iþlemleri', 1000),
   (1051, 'Satýnalma faturasý ekle', 1050),
   (1052, 'Satýnalma faturasý düzelt', 1050),
   (1053, 'Satýnalma faturasý sil', 1050),
   (1054, 'Satýnalma faturasý incele', 1050),

   (1060, 'Satýþ fatura iþlemleri', 1000),
   (1061, 'Satýþ faturasý ekle', 1060),
   (1062, 'Satýþ faturasý düzelt', 1060),
   (1063, 'Satýþ faturasý sil', 1060),
   (1064, 'Satýþ faturasý incele', 1060);

create table secUserPermission(
  UserId integer,
  PermissionId integer,
  CONSTRAINT secUserPermission_pk PRIMARY KEY (UserId, PermissionId),
  CONSTRAINT FK_secUserPermission_secUser FOREIGN KEY (UserId)     
    REFERENCES secUser (UserId),
  CONSTRAINT FK_secUserPermission_secPermission FOREIGN KEY (PermissionId)     
    REFERENCES secPermission (PermissionId)
);


create table secGroupPermission(
  GroupId integer,
  PermissionId integer,
  CONSTRAINT secGroupPermission_pk PRIMARY KEY (GroupId, PermissionId),
  CONSTRAINT FK_secGroupPermission_secGroup FOREIGN KEY (GroupId)     
    REFERENCES secGroup (GroupId),
  CONSTRAINT FK_secGroupPermission_secPermission FOREIGN KEY (PermissionId)     
    REFERENCES secPermission (PermissionId)
);

insert into secGroupPermission values(1, 1), (2, 1060), (3, 1030), (3, 1040), (3, 1050), (3, 1060);

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mustafa Özpýnar
-- Create date: 13.6.2019 Perþembe
-- Description:	
-- =============================================
CREATE PROCEDURE secUserLogin(@UserName varchar(50), @Password varchar(100), @Userid int out, @Result int out)
AS
BEGIN
	SET NOCOUNT ON;
	declare @cnt int;
	set @result=-1;

	select top 1 @userid=UserId from secUser as A where (A.Username=@username) and (A.Pswd=@password) and (A.IsActive is not null and A.IsActive <> 0); 

	if @@ROWCOUNT=0 
	begin
	  set @Result=-101;
	  return -101
	end
	else
	begin
	  set @Result=1;
	  return 1;
	end
END;

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mustafa Özpýnar
-- Create date: 13.6.2019 Perþembe
-- Description:	
-- =============================================

CREATE FUNCTION secinUserBasePermissions (@UserId int) RETURNS @tblRet TABLE 
(
   PermissionId int,
   ParentId int
)
AS
BEGIN
	insert into @tblRet 
	SELECT aUP.PermissionId, P.ParentId from secUserPermission as aUP inner join secPermission as P on (P.PermissionId=aUP.PermissionId)
	where (UserId=@UserId)
	union
	SELECT aGP.PermissionId, P.ParentId from secGroupPermission as aGP inner join secPermission as P on (P.PermissionId=aGP.PermissionId)
	where (GroupId in (SELECT GroupId FROM secGroupUser where (UserId=@UserId)))	 
  	RETURN;
END;

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Mustafa Özpýnar
-- Create date: 13.6.2019 Perþembe
-- Description:	This procedure gives if user has one of rights or not. @RequiredRights separated with comma values and it's sufficiant to have one of them.
-- =============================================
create PROCEDURE secUserAuthorize(@UserName varchar(50), @RequiredRights varchar(200), @Result int out)
AS
BEGIN
	declare @retval int;
	declare @UserId int;
	select @UserId=UserId from secUser where UserName=@UserName;
	if ISNULL(@UserId,0)=0 
	  return -1;

    with ctePermissions as(
	  select PermissionId, ParentId, 0 as Level from secinUserBasePermissions(@UserId)
	  union all
	  select p.PermissionId, p.ParentId, Level + 1 from  secPermission p
	     inner join ctePermissions c on c.PermissionId=p.ParentId 
		 where ISNULL(p.[IsActive], 1)=1 
	)
	select @retval=count(*) from ctePermissions where ','+@RequiredRights+',' like '%,'+CAST(PermissionId as varchar(20))+',%'
	return @retval;
END;


------------------------------------------------------------------------------------------------------------------------------------------------------
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE trigger PurchaseInvoiceHeader_SupplierUpdate ON PurchaseInvoiceHeader FOR INSERT, UPDATE, DELETE
AS 
  DECLARE @SupplierId integer = -1;
  DECLARE @InvCurrencyId integer = -1;
  DECLARE @InvCurrencyRate float = 0;
  DECLARE @InvDate date;
  DECLARE @InvAmount float;

  DECLARE @SupplierCurrencyId integer = -1;
  DECLARE @SupplierCurrencyRate float = 0;
  DECLARE @wCredit float;

  if EXISTS(select * from deleted)
  begin
    select @SupplierId=H.SupplierId, @InvCurrencyId=H.CurrencyTypeId, @InvCurrencyRate=H.CurrencyRate,  @InvAmount=H.TotalAmount,
           @SupplierCurrencyId=S.CurrencyTypeId, @SupplierCurrencyRate=CR.SellingRate  from deleted H 
             left outer join Supplier S on (S.SupplierId=H.SupplierId) 
		     left outer join CurrencyDailyRate CR on (CR.CurrencyDailyRateId=S.CurrencyTypeId and CR.CurrencyDate=H.InvoiceDate);

    if (ISNULL(@SupplierCurrencyId, -1)=-1)
	begin
	  SELECT @wCredit = ISNULL(@InvAmount, 0);
	end
	else
	if (ISNULL(@InvCurrencyId, -1)=ISNULL(@SupplierCurrencyId, -1)) 
    begin
      --SELECT @SupplierCurrencyRate = ISNULL(@InvCurrencyRate, 0)
	  SELECT @wCredit = ISNULL(@InvAmount, 0);
    end
    else
    begin
      SELECT @SupplierCurrencyRate=SellingRate from CurrencyDailyRate where CurrencyDate=@InvDate and CurrencyTypeId=@SupplierCurrencyId
	  if @SupplierCurrencyRate is null
	    SELECT @SupplierCurrencyRate = ISNULL(@InvCurrencyRate, 0)
	
	  if ISNULL(@SupplierCurrencyRate, 0)=0 or ISNULL(@InvCurrencyRate, 0)=0
	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0)
	  else
	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0) / ISNULL(@SupplierCurrencyRate, 1) 
    end
    update Supplier set TotalCredit = IsNull(TotalCredit, 0) - ISNULL(@wCredit, 0) where SupplierId=@SupplierId;
  end;

  if EXISTS(select * from inserted)
  begin
    select @SupplierId=H.SupplierId, @InvCurrencyId=H.CurrencyTypeId, @InvCurrencyRate=H.CurrencyRate,  @InvAmount=H.TotalAmount,
           @SupplierCurrencyId=S.CurrencyTypeId, @SupplierCurrencyRate=CR.SellingRate  from inserted H 
             left outer join Supplier S on (S.SupplierId=H.SupplierId) 
		     left outer join CurrencyDailyRate CR on (CR.CurrencyDailyRateId=S.CurrencyTypeId and CR.CurrencyDate=H.InvoiceDate);

	
    if (ISNULL(@SupplierCurrencyId, -1)=-1)
	begin
	  SELECT @wCredit = ISNULL(@InvAmount, 0);
	end
	else
	if (ISNULL(@InvCurrencyId, -1)=ISNULL(@SupplierCurrencyId, -1)) 
    begin
      --SELECT @SupplierCurrencyRate = ISNULL(@InvCurrencyRate, 0)
	  SELECT @wCredit = ISNULL(@InvAmount, 0);
    end
    else
    begin
      SELECT @SupplierCurrencyRate=SellingRate from CurrencyDailyRate where CurrencyDate=@InvDate and CurrencyTypeId=@SupplierCurrencyId
	  if @SupplierCurrencyRate is null
	    SELECT @SupplierCurrencyRate = ISNULL(@InvCurrencyRate, 0)

	  if ISNULL(@SupplierCurrencyRate, 0)=0 or ISNULL(@InvCurrencyRate, 0)=0
	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0)
	  else
	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0) / ISNULL(@SupplierCurrencyRate, 1) 
    end
    update Supplier set TotalCredit = IsNull(TotalCredit, 0) + ISNULL(@wCredit, 0) where SupplierId=@SupplierId;
  end;
  
------------------------------------------------------------------------------------------------------------------------------------------------------

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger PurchaseInvoiceDetail_InventoryUpdate ON PurchaseInvoiceDetail FOR INSERT, UPDATE, DELETE
AS 
  DECLARE @InvCurrencyId integer = -1;
  DECLARE @InvCurrencyRate float = 0;
  DECLARE @InvDate date;

  DECLARE @InventoryId integer = -1;
  DECLARE @InventoryCurrencyId integer;
  DECLARE @InventoryCurrencyRate float;

  DECLARE @IncomingQtty float;
  --DECLARE @OutgoingQtty float;
  DECLARE @IncomingAmount float;
  --DECLARE @OutgoingAmount float;

  DECLARE @wAmount float;
  if EXISTS(select * from deleted)
  begin
    select @InventoryId=D.InventoryId, @InvCurrencyId=D.CurrencyTypeId, @IncomingQtty=D.Quantity, @wAmount=D.TotalAmount, 
           @InventoryCurrencyId=INVENTORY.CurrencyTypeId, @InventoryCurrencyRate=CUR.SellingRate from deleted D
        left outer join Inventory INVENTORY on(INVENTORY.InventoryId=D.InventoryId)
	    left outer join CurrencyDailyRate CUR on(CUR.CurrencyTypeId=INVENTORY.CurrencyTypeId and CUR.CurrencyDate=D.InvoiceDate);

    if (ISNULL(@InvCurrencyId, -1)=ISNULL(@InventoryCurrencyId, -1)) 
    begin
	  SELECT @IncomingAmount = @wAmount;
    end
    else
    begin
	  if (ISNULL(@InventoryCurrencyRate, 0)=0)
	  begin
	    SELECT @IncomingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0);
	  end
	  else
	  begin
        SELECT @IncomingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0) / ISNULL(@InventoryCurrencyRate, 0);
	  end
    end
	

    update Inventory set
      TotalIncomingQtty = ISNULL(TotalIncomingQtty, 0) - ISNULL(@IncomingQtty, 0),
      --TotalOutgoingQtty = ISNULL(TotalOutgoingQtty, 0) - ISNULL(@OutgoingQtty, 0),
      TotalIncomingAmount = ISNULL(TotalIncomingAmount, 0) - ISNULL(@IncomingAmount, 0)
      --TotalOutgoingAmount = ISNULL(TotalOutgoingAmount, 0) - ISNULL(@OutgoingAmount, 0)
    where
      InventoryId = @InventoryId;
  end

  if EXISTS(select * from inserted)
  begin
    select @InventoryId=D.InventoryId, @InvCurrencyId=D.CurrencyTypeId, @IncomingQtty=D.Quantity, @wAmount=D.TotalAmount, 
           @InventoryCurrencyId=INVENTORY.CurrencyTypeId, @InventoryCurrencyRate=CUR.SellingRate from inserted D
        left outer join Inventory INVENTORY on(INVENTORY.InventoryId=D.InventoryId)
	    left outer join CurrencyDailyRate CUR on(CUR.CurrencyTypeId=INVENTORY.CurrencyTypeId and CUR.CurrencyDate=D.InvoiceDate);

     if (ISNULL(@InvCurrencyId, -1)=ISNULL(@InventoryCurrencyId, -1)) 
    begin
	  SELECT @IncomingAmount = @wAmount;
    end
    else
    begin
	  if (ISNULL(@InventoryCurrencyRate, 0)=0)
	  begin
	    SELECT @IncomingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0);
	  end
	  else
	  begin
        SELECT @IncomingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0) / ISNULL(@InventoryCurrencyRate, 0);
	  end
    end

    update Inventory set
      TotalIncomingQtty = ISNULL(TotalIncomingQtty, 0) + ISNULL(@IncomingQtty, 0),
      --TotalOutgoingQtty = ISNULL(TotalOutgoingQtty, 0) + ISNULL(@OutgoingQtty, 0),
      TotalIncomingAmount = ISNULL(TotalIncomingAmount, 0) + ISNULL(@IncomingAmount, 0)
      --TotalOutgoingAmount = ISNULL(TotalOutgoingAmount, 0) + ISNULL(@OutgoingAmount, 0)
    where
      InventoryId = @InventoryId;
  end

------------------------------------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  Trigger [dbo].[SalesInvoiceHeader_SupplierUpdate]    Script Date: 14.07.2019 23:23:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE trigger SalesInvoiceHeader_SupplierUpdate ON SalesInvoiceHeader FOR INSERT, UPDATE, DELETE
AS 
  DECLARE @CustomerId integer = -1;
  DECLARE @InvCurrencyId integer = -1;
  DECLARE @InvCurrencyRate float = 0;
  DECLARE @InvDate date;
  DECLARE @InvAmount float;

  DECLARE @CustomerCurrencyId integer = -1;
  DECLARE @CustomerCurrencyRate float = 0;
  DECLARE @wCredit float;

  if EXISTS(select * from deleted)
  begin
    select @CustomerId=H.CustomerId, @InvCurrencyId=H.CurrencyTypeId, @InvCurrencyRate=H.CurrencyRate,  @InvAmount=H.TotalAmount,
           @CustomerCurrencyId=S.CurrencyTypeId, @CustomerCurrencyRate=CR.SellingRate  from deleted H 
             left outer join Customer S on (S.CustomerId=H.CustomerId) 
		     left outer join CurrencyDailyRate CR on (CR.CurrencyDailyRateId=S.CurrencyTypeId and CR.CurrencyDate=H.InvoiceDate);

    if (ISNULL(@CustomerCurrencyId, -1)=-1)
	begin
	  SELECT @wCredit = ISNULL(@InvAmount, 0);
	end
	else
	if (ISNULL(@InvCurrencyId, -1)=ISNULL(@CustomerCurrencyId, -1)) 
    begin
      --SELECT @CustomerCurrencyRate = ISNULL(@InvCurrencyRate, 0)
	  SELECT @wCredit = ISNULL(@InvAmount, 0);
    end
    else
    begin
      SELECT @CustomerCurrencyRate=SellingRate from CurrencyDailyRate where CurrencyDate=@InvDate and CurrencyTypeId=@CustomerCurrencyId
	  if @CustomerCurrencyRate is null
	    SELECT @CustomerCurrencyRate = ISNULL(@InvCurrencyRate, 0)
	
	  if ISNULL(@CustomerCurrencyRate, 0)=0 or ISNULL(@InvCurrencyRate, 0)=0
	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0)
	  else
	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0) / ISNULL(@CustomerCurrencyRate, 1) 
    end
    update Customer set TotalCredit = IsNull(TotalCredit, 0) - ISNULL(@wCredit, 0) where CustomerId=@CustomerId;
  end;

  if EXISTS(select * from inserted)
  begin
    select @CustomerId=H.CustomerId, @InvCurrencyId=H.CurrencyTypeId, @InvCurrencyRate=H.CurrencyRate,  @InvAmount=H.TotalAmount,
           @CustomerCurrencyId=S.CurrencyTypeId, @CustomerCurrencyRate=CR.SellingRate  from inserted H 
             left outer join Customer S on (S.CustomerId=H.CustomerId) 
		     left outer join CurrencyDailyRate CR on (CR.CurrencyDailyRateId=S.CurrencyTypeId and CR.CurrencyDate=H.InvoiceDate);

	
    if (ISNULL(@CustomerCurrencyId, -1)=-1)
	begin
	  SELECT @wCredit = ISNULL(@InvAmount, 0);
	end
	else
	if (ISNULL(@InvCurrencyId, -1)=ISNULL(@CustomerCurrencyId, -1)) 
    begin
      --SELECT @CustomerCurrencyRate = ISNULL(@InvCurrencyRate, 0)
	  SELECT @wCredit = ISNULL(@InvAmount, 0);
    end
    else
    begin
      SELECT @CustomerCurrencyRate=SellingRate from CurrencyDailyRate where CurrencyDate=@InvDate and CurrencyTypeId=@CustomerCurrencyId
	  if @CustomerCurrencyRate is null
	    SELECT @CustomerCurrencyRate = ISNULL(@InvCurrencyRate, 0)

	  if ISNULL(@CustomerCurrencyRate, 0)=0 or ISNULL(@InvCurrencyRate, 0)=0
	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0)
	  else
	    SELECT @wCredit = ISNULL(@InvCurrencyRate, 0) * ISNULL(@InvAmount, 0) / ISNULL(@CustomerCurrencyRate, 1) 
    end
    update Customer set TotalCredit = IsNull(TotalCredit, 0) + ISNULL(@wCredit, 0) where CustomerId=@CustomerId;
  end;
  
------------------------------------------------------------------------------------------------------------------------------------------------------

GO
/****** Object:  Trigger [dbo].[SalesInvoiceDetail_InventoryUpdate]    Script Date: 14.07.2019 23:09:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger SalesInvoiceDetail_InventoryUpdate ON SalesInvoiceDetail FOR INSERT, UPDATE, DELETE
AS 
  DECLARE @InvCurrencyId integer = -1;
  DECLARE @InvCurrencyRate float = 0;
  DECLARE @InvDate date;

  DECLARE @InventoryId integer = -1;
  DECLARE @InventoryCurrencyId integer;
  DECLARE @InventoryCurrencyRate float;

  --DECLARE @IncomingQtty float;
  DECLARE @OutgoingQtty float;
  --DECLARE @IncomingAmount float;
  DECLARE @OutgoingAmount float;

  DECLARE @wAmount float;
  if EXISTS(select * from deleted)
  begin
    select @InventoryId=D.InventoryId, @InvCurrencyId=D.CurrencyTypeId, @OutgoingQtty=D.Quantity, @wAmount=D.TotalAmount, 
           @InventoryCurrencyId=INVENTORY.CurrencyTypeId, @InventoryCurrencyRate=CUR.SellingRate from deleted D
        left outer join Inventory INVENTORY on(INVENTORY.InventoryId=D.InventoryId)
	    left outer join CurrencyDailyRate CUR on(CUR.CurrencyTypeId=INVENTORY.CurrencyTypeId and CUR.CurrencyDate=D.InvoiceDate);

    if (ISNULL(@InvCurrencyId, -1)=ISNULL(@InventoryCurrencyId, -1)) 
    begin
	  SELECT @OutgoingAmount = @wAmount;
    end
    else
    begin
	  if (ISNULL(@InventoryCurrencyRate, 0)=0)
	  begin
	    SELECT @OutgoingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0);
	  end
	  else
	  begin
        SELECT @OutgoingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0) / ISNULL(@InventoryCurrencyRate, 0);
	  end
    end
	

    update Inventory set
      TotalOutgoingQtty = ISNULL(TotalOutgoingQtty, 0) - ISNULL(@OutgoingQtty, 0),
      TotalOutgoingAmount = ISNULL(TotalOutgoingAmount, 0) - ISNULL(@OutgoingAmount, 0)
    where
      InventoryId = @InventoryId;
  end

  if EXISTS(select * from inserted)
  begin
    select @InventoryId=D.InventoryId, @InvCurrencyId=D.CurrencyTypeId, @OutgoingQtty=D.Quantity, @wAmount=D.TotalAmount, 
           @InventoryCurrencyId=INVENTORY.CurrencyTypeId, @InventoryCurrencyRate=CUR.SellingRate from inserted D
        left outer join Inventory INVENTORY on(INVENTORY.InventoryId=D.InventoryId)
	    left outer join CurrencyDailyRate CUR on(CUR.CurrencyTypeId=INVENTORY.CurrencyTypeId and CUR.CurrencyDate=D.InvoiceDate);

     if (ISNULL(@InvCurrencyId, -1)=ISNULL(@InventoryCurrencyId, -1)) 
    begin
	  SELECT @OutgoingAmount = @wAmount;
    end
    else
    begin
	  if (ISNULL(@InventoryCurrencyRate, 0)=0)
	  begin
	    SELECT @OutgoingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0);
	  end
	  else
	  begin
        SELECT @OutgoingAmount = ISNULL(@wAmount, 0) * ISNULL(@InvCurrencyRate, 0) / ISNULL(@InventoryCurrencyRate, 0);
	  end
    end

    update Inventory set
      TotalOutgoingQtty = ISNULL(TotalOutgoingQtty, 0) + ISNULL(@OutgoingQtty, 0),
      TotalOutgoingAmount = ISNULL(TotalOutgoingAmount, 0) + ISNULL(@OutgoingAmount, 0)
    where
      InventoryId = @InventoryId;
  end
