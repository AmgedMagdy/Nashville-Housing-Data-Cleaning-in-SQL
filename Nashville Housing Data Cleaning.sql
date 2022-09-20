
-- Exploring Data

Select * From NashvilleData.dbo.NashvilleData
Select saledate FROM NashvilleData.dbo.NashvilleData





-- Converting Date Column

SELECT *  FROM NashvilleData.dbo.NashvilleData
WHERE [SaleDate] is null or [SaleDate] = ''


ALTER TABLE NashvilleData.dbo.NashvilleData 
ADD SaleDateConverted DATE;

UPDATE NashvilleData.dbo.NashvilleData 
SET SaleDateConverted = CONVERT(date, SaleDate)





-- Populate Property Address: Fix missing addresses based on Same ParcelID = Same Address

SELECT tb1.ParcelID, tb1.PropertyAddress, isnull(tb1.propertyaddress, tb2.propertyaddress)  
FROM NashvilleData.dbo.NashvilleData tb1
Join NashvilleData.dbo.NashvilleData tb2
	on tb1.[ParcelID] = tb2.[ParcelID]
	AND tb1.[UniqueID ] <> tb2.[UniqueID ]
WHERE tb1.[PropertyAddress] is null


UPDATE tb1
SET tb1.PropertyAddress = isnull(tb1.propertyaddress, tb2.propertyaddress)
FROM NashvilleData.dbo.NashvilleData tb1
Join NashvilleData.dbo.NashvilleData tb2
	on tb1.[ParcelID] = tb2.[ParcelID]
	AND tb1.[UniqueID ] <> tb2.[UniqueID ]
WHERE tb1.[PropertyAddress] is null






-- SEPARATING THE ADDRESS (into: Address, City): Using SUBSTRING, CHARINDEX 

SELECT
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) AS AddressName,
SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) + 2, LEN(PropertyAddress)) AS CityName
FROM NashvilleData.dbo.NashvilleData 
 
 
 
 ALTER TABLE NashvilleData.dbo.NashvilleData
 ADD PropertyStreet Nvarchar(255);

 UPDATE NashvilleData.dbo.NashvilleData
 SET PropertyStreet = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1)
 FROM NashvilleData.dbo.NashvilleData 



 ALTER TABLE NashvilleData.dbo.NashvilleData
 ADD  PropertyCity Nvarchar(255);

 UPDATE NashvilleData.dbo.NashvilleData
 SET  PropertyCity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) + 2, LEN(PropertyAddress))
 FROM NashvilleData.dbo.NashvilleData 







-- SEPARATING THE OWNER ADDRESS (into: Address, City, State) : using PARSENAME

Select OwnerAddress
From NashvilleData.dbo.NashvilleData 


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleData.dbo.NashvilleData 



ALTER TABLE NashvilleData.dbo.NashvilleData 
Add OwnerStreet Nvarchar(255);

Update NashvilleData.dbo.NashvilleData 
SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleData.dbo.NashvilleData 
Add OwnerCity Nvarchar(255);

Update NashvilleData.dbo.NashvilleData 
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleData.dbo.NashvilleData 
Add OwnerState Nvarchar(255);

Update NashvilleData.dbo.NashvilleData 
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From NashvilleData.dbo.NashvilleData 




--Alter Table NashvilleData.dbo.NashvilleData 
--Drop column [PropertyAddress], [OwnerAddress]






-- Changing Y/N to Yes/No in "Sold as Vacant" Column:


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleData.dbo.NashvilleData 
Group by SoldAsVacant
order by 2



Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleData.dbo.NashvilleData 


Update NashvilleData.dbo.NashvilleData 
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	   




-- Remove Duplicates: Using CTE

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleData.dbo.NashvilleData 

--order by ParcelID
)

--Select *
--From RowNumCTE
--Where row_num > 1
--Order by PropertyAddress

DELETE 
From RowNumCTE
Where row_num > 1





Select *
From NashvilleData.dbo.NashvilleData 


--------------------------------------------------------------------







