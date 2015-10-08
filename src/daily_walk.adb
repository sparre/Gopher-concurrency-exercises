with
  Gopher_Concurrency_Exercises.Duration,
  Gopher_Concurrency_Exercises.Text_IO;

procedure Daily_Walk is
   use Gopher_Concurrency_Exercises.Duration;
   use Gopher_Concurrency_Exercises.Text_IO;

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
            Put_Line ("Alarm is counting down.");
            delay 60.0;
            Armed := True;
            Put_Line ("Alarm is armed.");
         or
            delay 0.1;
            if Armed and not Door.Is_Locked then
               Put_Line ("Alarm ringing.");
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
      Put_Line (Name.all & " started getting ready.");
      Time := Random (Lower_Bound => 60.0,
                      Upper_Bound => 90.0);
      delay Time;
      Put_Line (Name.all & " spent" & Duration'Image (Time) &
                " seconds getting ready.");

      Ready_For_Alarm.Release;
      Ready_For_Alarm.Wait;

      select
         Alarm.Arm;
         Put_Line (Name.all & " armed the alarm.");
      else
         Put_Line (Name.all & " didn't arm the alarm.");
      end select;

      Put_Line (Name.all & " started putting on shoes.");
      Time := Random (Lower_Bound => 35.0,
                      Upper_Bound => 45.0);
      delay Time;
      Put_Line (Name.all & " spent" & Duration'Image (Time) &
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
   Put_Line ("Let's go for a walk!");

   declare
      Alice : Alice_Or_Bob (Name => new String'("Alice"));
      Bob   : Alice_Or_Bob (Name => new String'("Bob"));
   begin
      null;
   end;
end Daily_Walk;
