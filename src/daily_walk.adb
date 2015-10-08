with
  Ada.Exceptions,
  Ada.Numerics.Float_Random,
  Ada.Strings.Unbounded,
  Ada.Text_IO;

procedure Daily_Walk is
   Generator : Ada.Numerics.Float_Random.Generator;

   function Random (Lower_Bound, Upper_Bound : Duration) return Duration;

   function Random (Lower_Bound, Upper_Bound : Duration) return Duration is
      Value  : Float;
      Result : Duration;
   begin
      loop
         Value := Ada.Numerics.Float_Random.Random (Generator);
         Result :=
           Lower_Bound + Duration (Float (Upper_Bound - Lower_Bound) * Value);

         if Result in Lower_Bound .. Upper_Bound then
            return Result;
         end if;
      end loop;
   end Random;

   task Output is
      entry Put_Line (Item : in String);
   end Output;

   protected Door is
      procedure Unlock;
      procedure Lock;
      function Is_Locked return Boolean;

      pragma Unreferenced (Unlock);
   private
      Locked : Boolean := False;
   end Door;

   task Alarm is
      entry Arm;
   end Alarm;

   protected type Barrier (Count : Positive) is
      procedure Release;
      entry Wait;
   private
      To_Go : Natural := Count;
   end Barrier;

   task type Alice_Or_Bob (Name : access String);

   task body Alarm is
      Armed : Boolean := False;
   begin
      loop
         select
            accept Arm;
            Output.Put_Line ("Alarm is counting down.");
            delay 6.0;
            Armed := True;
            Output.Put_Line ("Alarm is armed.");
         or
            delay 0.1;
            if Armed and not Door.Is_Locked then
               Output.Put_Line ("Alarm ringing.");
               exit;
            end if;
         end select;

         exit when Armed and Door.Is_Locked;
      end loop;
   end Alarm;

   Ready_For_Alarm : Barrier (Count => 2);
   Ready_To_Go     : Barrier (Count => 2);

   task body Alice_Or_Bob is
      Time : Duration;
   begin
      Output.Put_Line (Name.all & " started getting ready.");
      Time := Random (Lower_Bound => 6.0,
                      Upper_Bound => 9.0);
      delay Time;
      Output.Put_Line (Name.all & " spent" & Duration'Image (Time) &
                       " seconds getting ready.");

      Ready_For_Alarm.Release;
      Ready_For_Alarm.Wait;

      select
         Alarm.Arm;
         Output.Put_Line (Name.all & " armed the alarm.");
      else
         Output.Put_Line (Name.all & " didn't arm the alarm.");
      end select;

      Output.Put_Line (Name.all & " started putting on shoes.");
      Time := Random (Lower_Bound => 3.5,
                      Upper_Bound => 4.5);
      delay Time;
      Output.Put_Line (Name.all & " spent" & Duration'Image (Time) &
                       " seconds putting on shoes.");

      Ready_To_Go.Release;
      Ready_To_Go.Wait;

      Door.Lock;
   end Alice_Or_Bob;

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

   protected body Barrier is
      procedure Release is
      begin
         To_Go := To_Go - 1;
      end Release;

      entry Wait when To_Go = 0 is
      begin
         null;
      end Wait;
   end Barrier;

begin
   Output.Put_Line ("Let's go for a walk!");

   declare
      Alice : Alice_Or_Bob (Name => new String'("Alice"));
      Bob   : Alice_Or_Bob (Name => new String'("Bob"));
   begin
      null;
   end;
end Daily_Walk;
