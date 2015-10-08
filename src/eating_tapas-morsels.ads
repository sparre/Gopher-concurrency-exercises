package Eating_Tapas.Morsels is
   type Count is range 0 .. 10;
   subtype Initial_Count is Count range 5 .. Count'Last;

   function Random return Count;
end Eating_Tapas.Morsels;
