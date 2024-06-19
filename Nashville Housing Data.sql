
--cleaning SQL Queries
select * from project..nashvillehousingdata

--Standardize Date Format


Select saleDate2, CONVERT(date , SaleDate)
from project..nashvillehousingdata

update project..nashvillehousingdata
set saleDate = CONVERT(date , SaleDate)

alter table project..nashvillehousingdata
add saledate2 Date;

update project..nashvillehousingdata 
set SaleDate2 = CONVERT(date,SaleDate)

--populate property address data

select* from project..nashvillehousingdata --where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress , ISNULL(a.PropertyAddress ,b.PropertyAddress)
from project..nashvillehousingdata a join project..nashvillehousingdata b
on a.ParcelID =b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.PropertyAddress ,b.PropertyAddress)
from project..nashvillehousingdata a join project..nashvillehousingdata b
on a.ParcelID =b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking  out adress into Individual Colums(Address,City,State)

select propertyaddress from project..nashvillehousingdata



select SUBSTRING(propertyaddress,1, charindex(',', PropertyAddress)-1) as Address , 
SUBSTRING(propertyaddress,CHARINDEX(',' , PropertyAddress )+1, len(PropertyAddress)) as Address 
from project..nashvillehousingdata

alter table project..nashvillehousingdata
add PropertySplitAddress nvarchar(255);

update project..nashvillehousingdata 
set PropertySplitAddress =  SUBSTRING(propertyaddress,1, charindex(',', PropertyAddress)-1) 

alter table project..nashvillehousingdata
add PropertySplitCity nvarchar(255);

update project..nashvillehousingdata 
set PropertySplitCity = SUBSTRING(propertyaddress,CHARINDEX(',' , PropertyAddress )+1, len(PropertyAddress))

select *from project..nashvillehousingdata

select owneraddress from project..nashvillehousingdata

select PARSENAME(replace(owneraddress,',','.'),1) ,
PARSENAME(replace(owneraddress,',','.'),2), 
PARSENAME(replace(owneraddress,',','.'),3) 
from project..nashvillehousingdata

alter table project..nashvillehousingdata
add OwnerSplitAddress nvarchar(255);

update project..nashvillehousingdata 
set OwnerSplitAddress =  PARSENAME(replace(owneraddress,',','.'),1) 

alter table project..nashvillehousingdata
add OwnerSplitCity nvarchar(255);

update project..nashvillehousingdata 
set OwnerSplitCity = PARSENAME(replace(owneraddress,',','.'),2) 


alter table project..nashvillehousingdata
add OwnerSplitState nvarchar(255);

update project..nashvillehousingdata 
set OwnerSplitState = PARSENAME(replace(owneraddress,',','.'),3) 

select* from project..nashvillehousingdata

--change Y and N in the sold and vacant field

select distinct(soldasvacant), COUNT(soldasvacant) from project..nashvillehousingdata
group by SoldAsVacant order by 2

select soldasvacant ,
case when soldasvacant =  'Y' then 'Yes'
 when soldasvacant =  'N' then 'No'
 ELSE SoldasVacant END
 FROM Project..nashvillehousingdata


Update nashvillehousingdata 
set SoldasVacant = case when soldasvacant =  'Y' then 'Yes'
 when soldasvacant =  'N' then 'No'
 ELSE SoldasVacant 
 END
 from project..nashvillehousingdata

--Remove Duplicates


WITH RowNumCTE as(
select * ,
ROW_NUMBER() 
OVER 
(PARTITION BY PARCELID, propertyaddress,saleprice,saledate,legalReference ORDER BY UNIQUEID)
row_num

from project..nashvillehousingdata --ORDER BY ParcelID 
)
--delete from RowNumCTE Where row_num>1 Order By PropertyAddress
select * from RowNumCTE Where row_num>1 Order By PropertyAddress

--Delete Used Columns

select* from project..nashvillehousingdata

alter table project..nashvillehousingdata
drop column OwnerAddress,TaxDistrict,PropertyAddress

alter table project..nashvillehousingdata
drop column SaleDate


