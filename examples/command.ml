external __filename : string = "__filename" [@@bs.val]

let default =
   let open SlashCreate.SlashCommand in
   let command =
      createWith
        (params ~name:"hello" ~description:"Says hello to you."
           ~options:
             [|
               opt ~_type:`string ~name:"food" ~description:"What food do you like?" ();
             |]
           ())
   in
   command.filePath <- Js.Undefined.return __filename ;

   command.hasPermission <- (fun _ctx -> permissionOfBool false) ;

   command.onBlock <-
     wrapOnBlockHandler (fun ctx -> function
       | `permission perm -> failwith "nyi"
       | `throttling arg -> failwith "nyi") ;

   command.run <-
     (fun ctx ->
       let open Js in
       Promise.resolve @@ Undefined.return @@ responseOfString "hi") ;

   command
