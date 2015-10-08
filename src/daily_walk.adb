with
  Ada.Exceptions,
  Ada.Strings.Unbounded,
  Ada.Text_IO;

procedure Daily_Walk is
   task Output is
      entry Put_Line (Item : in String);
   end Output;

   protected Door is
      procedure Unlock;
      procedure Lock;
      function Is_Locked return Boolean;
   private
      Locked : Boolean := False;
   end Door;

   task Alarm is
      entry Arm;
   end Alarm;

   task body Alarm is
      Armed : Boolean := False;
   begin
      loop
         select
            accept Arm;
            delay 60.0;
            Armed := True;
         or
            delay 0.1;
            if Armed and not Door.Is_Locked then
               Output.Put_Line ("Alarm ringing.");
            end if;
         end select;
      end loop;
   end Alarm;

   protected body Door is
      function Is_Locked return Boolean is
      begin
         return Locked;
      end Is_Locked;

      procedure Lock is
      begin
         Locked := True;
      end Lock;

      procedure Unlock is
      begin
         Locked := False;
      end Unlock;
   end Door;

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
   Door.Unlock;
   Output.Put_Line ("Arming alarm...");
   Alarm.Arm;
   Output.Put_Line ("Waiting 30 seconds...");
   delay 30.0;
   Output.Put_Line ("Locking door...");
   Door.Lock;

   abort Alarm;
end Daily_Walk;
