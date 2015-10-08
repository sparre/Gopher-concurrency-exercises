with
  Gopher_Concurrency_Exercises.Duration,
  Gopher_Concurrency_Exercises.Text_IO;

procedure Internet_Café is
   protected Sequencer is
      procedure Get (Value :    out Positive);
   private
      Last : Natural := 0;
   end Sequencer;

   task type Tourist;

   protected Manager is
      entry Get_Access;
      procedure Leave_Machine;
   private
      Available_Machines : Natural := 8;
   end Manager;

   protected body Manager is
      entry Get_Access when Available_Machines > 0 is
      begin
         Available_Machines := Available_Machines - 1;
      end Get_Access;

      procedure Leave_Machine is
      begin
         Available_Machines := Available_Machines + 1;
         pragma Assert (Available_Machines <= 8);
      end Leave_Machine;
   end Manager;

   protected body Sequencer is
      procedure Get (Value :    out Positive) is
      begin
         Last  := Last + 1;
         Value := Last;
      end Get;
   end Sequencer;

   task body Tourist is
      use Gopher_Concurrency_Exercises.Duration;
      use Gopher_Concurrency_Exercises.Text_IO;

      ID   : Positive;
      Time : Duration;
   begin
      Sequencer.Get (ID);
      Time := Random (Lower_Bound => 15 * Minutes,
                      Upper_Bound =>  3 * Hours);

      Manager.Get_Access;
      Put_Line ("Tourist" & Positive'Image (ID) & " is online.");
      delay Time / 3600.0;
      Manager.Leave_Machine;
      Put_Line ("Tourist" & Positive'Image (ID) & " is done, having spent" &
                  Positive'Image (Positive (Time / Minutes)) &
                  " minutes online.");
   end Tourist;

begin
   declare
      Tourists : array (1 .. 25) of Tourist with Unreferenced;
   begin
      null;
   end;

   Gopher_Concurrency_Exercises.Text_IO.Put_Line
     ("The place is empty, let's close up and go to the beach!");
end Internet_Café;
