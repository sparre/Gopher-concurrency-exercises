with
  Ada.Numerics.Discrete_Random;

package body Eating_Tapas.Morsels is
   package Randomizer is new Ada.Numerics.Discrete_Random (Initial_Count);
   Generator : Randomizer.Generator;

   function Random return Count is
   begin
      return Randomizer.Random (Generator);
   end Random;
begin
   Randomizer.Reset (Generator);
end Eating_Tapas.Morsels;
