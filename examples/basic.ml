external __dirname : string = "__dirname" [@@bs.val]

let _ =
   SlashCreate.SlashCreator.(
     createWith
       (params ~applicationID:"12345678901234567" ~publicKey:"CLIENT_PUBLIC_KEY"
          ~token:"BOT_TOKEN_HERE" ())
     |> registerCommandsInPath (Node.Path.join2 __dirname "commands")
     |> syncCommands)
