package Gopher_Concurrency_Exercises.Duration is
   function Random (Lower_Bound, Upper_Bound : Standard.Duration)
                   return Standard.Duration;

   Seconds : constant Standard.Duration :=  1.0;
   Minutes : constant Standard.Duration := 60.0;
   Hours   : constant Standard.Duration := 60.0 * Minutes;
end Gopher_Concurrency_Exercises.Duration;
