CREATE      OR ALTER PROCEDURE [dbo].[USP_DeleteNullOrEmptyRows]   @tableName nvarchar(max)               
AS                  

/*** This stored procedure will accept 1 parameter [tableName] and remove all NULL or BLANK / EMPTY rows from it 

Usage: EXEC dbo.[[USP_DeleteNullOrEmptyRows] @tableName

**/

DECLARE                         
 @nameOfColumns NVARCHAR(MAX),                 
 @completeQuery NVARCHAR(MAX)                
                  
BEGIN    
  SET @tableName = QUOTENAME(@tableName,'[]')    
               
  --Setting variables to blank, because string concatenation doesn't work on NULL variables                
  SET @nameOfColumns = ''             
  SET @completeQuery = ''                 
         
   
  SELECT @nameOfColumns = @nameOfColumns + ',' + 'ISNULL('+QUOTENAME(COLUMN_NAME,'[]')+','''')' + CHAR(13)                
  FROM INFORMATION_SCHEMA.COLUMNS                
  WHERE QUOTENAME(TABLE_NAME,'[]') = @tableName                
            
                
      
      
  --Removing additional comma from the column variable string                
  SET @nameOfColumns = SUBSTRING(@nameOfColumns,2,LEN(@nameOfColumns))              
              
  SET @nameOfColumns = 'Concat('+@nameOfColumns+') = '''''             
                
                
  --Concatenating coalesce query into a complete query, thus making it a single delete query                
  SET @completeQuery = 'DELETE FROM '+ @tableName +' WHERE ' + @nameOfColumns                
  --SELECT @completeQuery          
  EXEC SP_EXECUTESQL @completeQuery             
                
END            


