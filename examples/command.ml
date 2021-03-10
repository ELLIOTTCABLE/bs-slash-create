external __filename : string = "" [@@bs.val]

let default =
   let open SlashCreate.SlashCommand in
   let command =
      createWith (options ~name:"hello" ~description:"Says hello to you." ())
   in
   command.filePath <- Some __filename ;

   command.hasPermission <- (fun _ctx -> permissionOfBool false) ;

   command.onBlock <-
     wrapOnBlockHandler (fun ctx -> function
       | `permission perm -> failwith "nyi"
       | `throttling arg -> failwith "nyi") ;

   command.run <- (fun ctx ->
      let open Js in
      Promise.resolve @@ Undefined.return @@ responseOfString "hi") ;

   command
