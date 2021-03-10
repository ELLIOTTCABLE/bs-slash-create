let default =
   let open SlashCreate.SlashCommand in
   let command = createWith (options ~name:"hello" ~description:"Says hello to you." ()) in
   (* command##commandName #= "hi"; *)
   command##hasPermission #= (fun x -> `Bool false);
   command
