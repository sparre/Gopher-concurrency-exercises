with
  Gopher_Concurrency_Exercises.Duration,
  Gopher_Concurrency_Exercises.Text_IO;
with
  Eating_Tapas.Strings,
  Eating_Tapas.Table;

procedure Eating_Tapas.Run is
   use Gopher_Concurrency_Exercises.Duration;
   use Gopher_Concurrency_Exercises.Text_IO;
   use Strings;

   task type Diner is
      entry Name (Set : in     Strings.Name);
   end Diner;

   task body Diner is
      My_Name : Strings.Name;
   begin
      accept Name (Set : in     Strings.Name) do
         My_Name := Set;
      end Name;

      while Table.Instance.Food_Left loop
         declare
            Morsel : Strings.Description;
         begin
            select
               Table.Instance.Pick (Morsel);
               Put_Line
                 (+My_Name & " is enjoying some " & (+Morsel) & ".");
               delay Random (Lower_Bound => 30 * Seconds,
                             Upper_Bound =>  3 * Minutes);
            else
               Put_Line
                 (+My_Name & " looks for something to eat.");
            end select;
         end;
      end loop;
   end Diner;
begin
   Table.Instance.Set;

   Put_Line ("Bon appétit!");

   declare
      Diners : array (1 .. 4) of Diner;
   begin
      Diners (1).Name (+"Alice");
      Diners (2).Name (+"Bob");
      Diners (3).Name (+"Charlie");
      Diners (4).Name (+"Dave");
   end;

   Put_Line ("That was delicious!");
end Eating_Tapas.Run;
