with
  Ada.Exceptions,
  Ada.Strings.Unbounded,
  Ada.Text_IO;

procedure Daily_Walk is
   task Output is
      entry Put_Line (Item : in String);
   end Output;

   task body Output is
      use Ada.Exceptions, Ada.Strings.Unbounded, Ada.Text_IO;
      Buffer : Unbounded_String;
   begin
      loop
         select
            accept Put_Line (Item : in String) do
               Buffer := To_Unbounded_String (Item);
            end Put_Line;
            Put_Line (File => Standard_Output,
                      Item => To_String (Buffer));
         or
            terminate;
         end select;
      end loop;
   exception
      when E : others =>
         Put_Line (File => Standard_Error,
                   Item => "Output: " & Exception_Name (E) & ": " &
                           Exception_Message (E));
   end Output;
begin
   Output.Put_Line ("Hello world.");
end Daily_Walk;
