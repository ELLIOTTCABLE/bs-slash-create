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

  type throttlingOptions = { duration : int; usages : int }

  external options :
    name:string ->
    description:string ->
    ?guildIDs:string array ->
    (* ?options: *)
    ?requiredPermissions:string array ->
    ?throttling:throttlingOptions ->
    ?unknown:bool ->
    unit ->
    options = ""
    [@@bs.obj]

  type context (* TODO: NYI *)

  type message (* TODO: NYI *)

  type messageOptions (* TODO: NYI *)

  type permission

  external permissionOfBool : bool -> permission = "%identity"

  external permissionWithErrorMessage : string -> permission = "%identity"

  type response

  external responseOfString : string -> response = "%identity"

  external responseOfMsg : messageOptions -> response = "%identity"

  type onBlockHandler =
     context -> string -> Js.Json.t -> message Js.Nullable.t Js.Promise.t option

  type t = {
     commandName : string;
     (* TODO: NYI: creator: *) description : string;
     guildIDs : string array;
     (* TODO: NYI: options: *) requiredPermissions : string array;
     (* TODO: NYI: throttling: *) unknown : bool;
     mutable filePath : string option;
     mutable hasPermission : context -> permission;
     mutable onBlock : onBlockHandler;
     mutable onError : Js.Exn.t -> context -> message Js.nullable Js.Promise.t option;
     mutable run : context -> response Js.undefined Js.Promise.t;
   }

  external createWith : options -> t = "SlashCommand"
    [@@bs.new] [@@bs.module "slash-create"]

  type throttleStatus = { throttle : throttlingOptions; remaining : int }

  let failmsg =
     "throttleStatusOfJson: argument doesn't match ThrottlingOptions signature"
     [@@bs.inline]


  let throttleOptionsOfJson o =
     let open Js in
     let get = Dict.get o in
     match (get "duration", get "usages") with
     | Some durationVal, Some usagesVal -> (
         match (Json.classify durationVal, Json.classify usagesVal) with
         | JSONNumber durationFl, JSONNumber usagesFl ->
             { duration = int_of_float durationFl; usages = int_of_float usagesFl }
         | _ -> failwith failmsg)
     | _ -> failwith failmsg


  let throttleStatusOfJson o =
     let open Js in
     let get = Dict.get o in
     match (get "throttle", get "remaining") with
     | Some throttleVal, Some remainingVal -> (
         match (Json.classify throttleVal, Json.classify remainingVal) with
         | JSONObject throttleObj, JSONNumber remainingFl ->
             {
               throttle = throttleOptionsOfJson throttleObj;
               remaining = int_of_float remainingFl;
             }
         | _ -> failwith failmsg)
     | _ -> failwith failmsg


  type strictOnBlockHandler =
     context ->
     [ `permission of string | `throttling of throttleStatus ] ->
     message Js.Nullable.t Js.Promise.t option

  let wrapOnBlockHandler : strictOnBlockHandler -> onBlockHandler =
    fun f ctx reason data ->
     let f = f ctx in
     let open Js in
     match (reason, Json.classify data) with
     | "permission", JSONString s -> f @@ `permission s
     | "throttling", JSONObject o -> f @@ `throttling (throttleStatusOfJson o)
     | _ -> failwith ("Unimplemented onBlock reason: " ^ reason)
end

module CommandContext = struct
  type channel (* TODO: NYI *)

  type unresolvedMember (* TODO: NYI *)

  type member (* TODO: NYI *)

  type role (* TODO: NYI *)

  type user (* TODO: NYI *)

  type message (* TODO: NYI *)

  type messageOptions (* TODO: NYI *)

  type t = {
     channelID : string;
     channels : channel Js.Dict.t;
     commandID : string;
     commandName : string;
     creator : SlashCreator.t;
     (* TODO: NYI: data: *) expired : bool;
     guildID : string option;
     initiallyResponded : bool;
     interactionID : string;
     interactionToken : string;
     invokedAt : float;
     member : unresolvedMember;
     members : member Js.Dict.t;
     options : Js.Json.t;
     (* TODO: wtf? *)
     roles : role Js.Dict.t;
     subcommands : string array;
     user : user;
     users : user Js.Dict.t;
   }

  external acknowledge : t -> ?includeSource:bool -> unit -> bool Js.Promise.t = ""
    [@@bs.send]

  external delete : t -> ?messageID:string -> unit -> unit Js.Promise.t = "" [@@bs.send]

  type editMessageOptions = {
     (* TODO: NYI: allowMentions: *)
     content : string option; (* TODO: NYI: embeds : Js.Json.t array; *)
   }

  type followUpMessageOptions = {
     (* TODO: NYI: allowMentions: *)
     content : string option;
     (* TODO: NYI: embeds : Js.Json.t array; *)
     flags : int option;
     tts : bool option;
   }

  external edit :
    t ->
    messageID:string ->
    ([ `Content of string | `Opts of editMessageOptions ][@bs.unwrap]) ->
    message Js.Promise.t = ""
    [@@bs.send]

  external editOriginal :
    t ->
    ([ `Content of string | `Opts of editMessageOptions ][@bs.unwrap]) ->
    message Js.Promise.t = ""
    [@@bs.send]

  external _send :
    t ->
    ([ `Content of string | `Opts of messageOptions ][@bs.unwrap]) ->
    Js.Json.t Js.Promise.t = ""
    [@@bs.send]

  external coerceToMessage : Js.Json.t Js.Dict.t -> message = "%identity"

  let send :
      t ->
      [ `Content of string | `Opts of messageOptions ] ->
      [ `Initial of bool | `Message of message ] Js.Promise.t =
    fun t x ->
     let open Js in
     _send t x
     |> Promise.then_ (fun rv ->
            match Json.classify rv with
            | JSONFalse -> Promise.resolve @@ `Initial false
            | JSONTrue -> Promise.resolve @@ `Initial true
            | JSONObject o -> Promise.resolve @@ `Message (coerceToMessage o)
            | _ -> failwith "unexpected return-value from send()")


  external sendFollowUp :
    t ->
    ([ `Content of string | `Opts of followUpMessageOptions ][@bs.unwrap]) ->
    message Js.Promise.t = ""
    [@@bs.send]
end
