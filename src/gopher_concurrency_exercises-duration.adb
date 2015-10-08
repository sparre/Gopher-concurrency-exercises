with
  Ada.Numerics.Float_Random;

package body Gopher_Concurrency_Exercises.Duration is
   Generator : Ada.Numerics.Float_Random.Generator;

   function Random (Lower_Bound, Upper_Bound : Standard.Duration)
                   return Standard.Duration is
      Value  : Float;
      Result : Standard.Duration;
   begin
      loop
         Value := Ada.Numerics.Float_Random.Random (Generator);
         Result :=
           Lower_Bound +
           Standard.Duration (Float (Upper_Bound - Lower_Bound) * Value);

         if Result in Lower_Bound .. Upper_Bound then
            return Result;
         end if;
      end loop;
   end Random;
begin
   Ada.Numerics.Float_Random.Reset (Generator);
end Gopher_Concurrency_Exercises.Duration;
