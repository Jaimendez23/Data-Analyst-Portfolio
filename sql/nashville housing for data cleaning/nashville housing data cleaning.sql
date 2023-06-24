-- create table
create table nashHousing(
	UniqueID int,
	ParcelID float,
	LandUse	varchar(50),
	PropertyAddress	varchar(100),
	SaleDate date,
	SalePrice float,
	LegalReference varchar(50),
	SoldAsVacant varchar(10),
	OwnerName varchar(100),
	OwnerAddress varchar(100),
	Acreage	float,
	TaxDistrict	varchar(100),
	LandValue	float,
	BuildingValue	float,
	TotalValue	float,
	YearBuilt	int,
	Bedrooms	smallint,
	FullBath	smallint,
	HalfBath smallint
)

-- altering the table because of wrong data type
alter table nashhousing
alter column parcelid TYPE varchar(50)

--importing file 
COPY nashhousing FROM 'C:\Userssql\nashville housing for data cleaning\nashville.csv' CSV HEADER;


--populate property address 
SELECT nh1.parcelid, nh1.propertyaddress, nh2.parcelid, nh2.propertyaddress, Coalesce(nh1.propertyaddress, nh2.propertyaddress)
FROM nashhousing AS nh1
JOIN nashhousing AS nh2
ON nh1.parcelid = nh2.parcelid
AND nh1.uniqueid <> nh2.uniqueid
WHERE nh1.propertyaddress IS NULL;

update nashhousing
set propertyaddress = Coalesce(nh1.propertyaddress, nh2.propertyaddress)
FROM nashhousing AS nh1
JOIN nashhousing AS nh2
ON nh1.parcelid = nh2.parcelid
AND nh1.uniqueid <> nh2.uniqueid
WHERE nh1.propertyaddress IS NULL;

--breaking address into individual columns (address, city, state)
SELECT
  TRIM(substring(propertyaddress, 1, position(',' IN propertyaddress) -1)) as address,
  TRIM(SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress) + 1)) AS city
from nashhousing

alter table nashhousing 
add splitaddress varchar(100)

alter table nashhousing
add splitscity varchar(100)

update nashhousing
SET splitaddress = TRIM(substring(propertyaddress, 1, position(',' IN propertyaddress) -1))

update nashhousing 
set splitscity = TRIM(SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress) + 1))


SELECT
  TRIM(SPLIT_PART(REPLACE(owneraddress, ',', '.'), '.', 1)) AS part1,
  TRIM(SPLIT_PART(REPLACE(owneraddress, ',', '.'), '.', 2)) AS part2,
  TRIM(SPLIT_PART(REPLACE(owneraddress, ',', '.'), '.', 3)) AS part3
FROM nashhousing;

alter table nashhousing 
add ownersplitaddress varchar(100)

alter table nashhousing
add ownersplitcity varchar(100)

alter table nashhousing
add ownersplitstate varchar(100)

update nashhousing
SET ownersplitaddress = TRIM(SPLIT_PART(REPLACE(owneraddress, ',', '.'), '.', 1))

update nashhousing 
set ownersplitcity = TRIM(SPLIT_PART(REPLACE(owneraddress, ',', '.'), '.', 2))

update nashhousing 
set ownersplitstate = TRIM(SPLIT_PART(REPLACE(owneraddress, ',', '.'), '.', 3))


--changing the "y" and "n" to "yes" and "no" in sold as vacant column
select distinct(soldasvacant), count(soldasvacant)
from nashhousing
group by soldasvacant
order by 2

select soldasvacant , 
case when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	END
From nashhousing

update nashhousing 
SET soldasvacant = case when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	END

--REMOVE duplicate
with  rownumcte as (
select *, ROW_NUMBER() OVER (partition by 
							 parcelid,propertyaddress, saleprice, saledate,legalreference 
							 order by uniqueid) as row_num
from nashhousing
order by parcelid

)

DELETE FROM nashhousing
WHERE (parcelid, propertyaddress, saleprice, saledate, legalreference) IN (
  SELECT parcelid, propertyaddress, saleprice, saledate, legalreference
  FROM (
    SELECT parcelid, propertyaddress, saleprice, saledate, legalreference,
           ROW_NUMBER() OVER (PARTITION BY parcelid, propertyaddress, saleprice, saledate, legalreference ORDER BY uniqueid) AS row_num
    FROM nashhousing
  ) sub
  WHERE row_num > 1
);


select * from nashhousing
