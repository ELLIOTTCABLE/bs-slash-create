type imageFormat = [ `jpg | `jpeg | `png | `webp | `gif ]

type requireAllOptions

(* FIXME: functional `filter` argument NYI *)
(* FIXME: type the `resolve` argument *)
external requireAllOptions :
  dirname:string ->
  ?excludeDirs:Js.Re.t ->
  ?filter:Js.Re.t ->
  ?map:(name:string -> path:string -> string) ->
  ?recursive:bool ->
  ?resolve:(< .. > Js.t -> < .. > Js.t) ->
  unit ->
  requireAllOptions = ""
  [@@bs.obj]

type syncCommandOptions

external syncCommandOptions :
  ?deleteCommands:bool ->
  ?skipGuildErrors:bool ->
  ?syncGuilds:bool ->
  unit ->
  syncCommandOptions = ""
  [@@bs.obj]

module SlashCreator = struct
  type t

  type options

  external options :
    applicationID:string ->
    ?publicKey:string ->
    ?token:string ->
    ?serverHost:string ->
    ?serverPort:int ->
    ?endpointPath:string ->
    ?autoAcknowledgeSource:bool ->
    ?defaultImageFormat:imageFormat ->
    ?defaultImageSize:int ->
    ?latencyThreshold:int ->
    ?maxSignatureTimestamp:int ->
    ?ratelimiterOffset:int ->
    ?requestTimeout:int ->
    ?unknownCommandResponse:bool ->
    unit ->
    options = ""
    [@@bs.obj]

  external createWith : options -> t = "SlashCreator"
    [@@bs.new] [@@bs.module "slash-create"]

  external commandsPath : t -> string option = "" [@@bs.get]

  external registerCommandsInPath : string -> t = "" [@@bs.send.pipe: t]

  external registerCommandsIn : requireAllOptions -> t = "" [@@bs.send.pipe: t]

  external syncCommandsWith : syncCommandOptions -> t = "syncCommands" [@@bs.send.pipe: t]

  let syncCommands ?deleteCommands ?skipGuildErrors ?syncGuilds creator =
     syncCommandsWith
       (syncCommandOptions ?deleteCommands ?skipGuildErrors ?syncGuilds ())
       creator
end

module SlashCommand = struct
  type options

  external options :
    name:string ->
    description:string ->
    ?guildIDs:string array ->
    (* ?options: *)
    ?requiredPermissions:string array ->
    (* ?throttling: *)
    ?unknown:bool ->
    unit ->
    options = ""
    [@@bs.obj]

  type context

  type t =
     < commandName : string
     ; (* creator: *) description : string
     ; filePath : string option
     ; guildIDs : string array
     ; (* options: *) requiredPermissions : string array
     ; (* throttling: *) unknown : bool
     ; hasPermission : context -> ([`String of string | `Bool of bool][@unwrap]) [@set]
     >
     Js.t

  external createWith : options -> t = "SlashCommand"
    [@@bs.new] [@@bs.module "slash-create"]
end
