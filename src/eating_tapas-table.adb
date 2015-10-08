with
  Ada.Numerics.Discrete_Random;

with
  Eating_Tapas.Morsels;

package body Eating_Tapas.Table is
   type Dish_Index is range 1 .. 5;
   package Random_Dish_Indices is
      new Ada.Numerics.Discrete_Random (Dish_Index);
   Index_Generator : Random_Dish_Indices.Generator;
   function Random return Dish_Index;

   function Random return Dish_Index is
   begin
      return Random_Dish_Indices.Random (Index_Generator);
   end Random;

   protected type Dish is
      entry Fill (Kind  : in     Strings.Description;
                  Count : in     Morsels.Initial_Count);
      entry Pick (Got :    out Strings.Description;
                  Last :    out Boolean);
   private
      Remaining   : Morsels.Count := 0;
      Description : Strings.Description;
   end Dish;

   Dishes : array (Dish_Index) of Dish;

   use type Morsels.Count;
   use type Strings.Description;

   protected body Dish is
      entry Fill (Kind  : in     Strings.Description;
                  Count : in     Morsels.Initial_Count) when Remaining = 0 is
      begin
         Description := Kind;
         Remaining := Count;
      end Fill;

      entry Pick (Got  :    out Strings.Description;
                  Last :    out Boolean) when Remaining > 0 is
      begin
         Remaining := Remaining - 1;
         Got       := Description;
         Last      := Remaining = 0;
      end Pick;
   end Dish;

   protected body Instance is
      function Food_Left return Boolean is
      begin
         return Ready;
      end Food_Left;

      entry Pick (Got :    out Strings.Description) when Ready is
         Dish : Dish_Index := Random;
         Last : Boolean;
      begin
         loop
            select
               pragma Warnings (Off);
               Dishes (Dish).Pick (Got, Last);
               pragma Warnings (On);

               if Last then
                  Empty_Dishes := Empty_Dishes + 1;
                  Ready        := Empty_Dishes < Dishes'Length;
               end if;

               exit;
            else
               Dish := Random;
            end select;
         end loop;
      end Pick;

      entry Set when not Ready is
      begin
         pragma Warnings (Off);
         Dishes (1).Fill (Kind  => +"chorizo",
                          Count => Morsels.Random);
         Dishes (2).Fill (Kind  => +"chopitos",
                          Count => Morsels.Random);
         Dishes (3).Fill (Kind  => +"pimientos de padrón",
                          Count => Morsels.Random);
         Dishes (4).Fill (Kind  => +"croquetas",
                          Count => Morsels.Random);
         Dishes (5).Fill (Kind  => +"patatas bravas",
                          Count => Morsels.Random);
         pragma Warnings (On);

         Empty_Dishes := 0;
         Ready        := True;
      end Set;
   end Instance;
end Eating_Tapas.Table;
