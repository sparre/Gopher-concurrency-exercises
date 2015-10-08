with
  Eating_Tapas.Strings;

package Eating_Tapas.Table is
   protected Instance is
      entry Set;
      entry Pick (Got :    out Strings.Description);
      function Food_Left return Boolean;
   private
      Ready        : Boolean := False;
      Empty_Dishes : Natural := 5;
   end Instance;
end Eating_Tapas.Table;
