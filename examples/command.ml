let default =
   let open SlashCreate.SlashCommand in
   let command =
      createWith (options ~name:"hello" ~description:"Says hello to you." ())
   in
   command.hasPermission <- (fun _ctx -> permissionOfBool false) ;
   command.onBlock <-
     wrapOnBlockHandler (fun ctx -> function
       | `permission perm -> failwith "nyi"
       | `throttling arg -> failwith "nyi") ;
   command
