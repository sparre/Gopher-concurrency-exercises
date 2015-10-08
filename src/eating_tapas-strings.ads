with
  Ada.Strings.Unbounded;

package Eating_Tapas.Strings is
   type Name is new Ada.Strings.Unbounded.Unbounded_String;
   function "+" (Item : in Name) return String renames To_String;
   function "+" (Item : in String) return Name renames To_Unbounded_String;

   type Description is new Ada.Strings.Unbounded.Unbounded_String;
   function "+" (Item : in Description) return String renames To_String;
   function "+" (Item : in String) return Description
     renames To_Unbounded_String;
end Eating_Tapas.Strings;
