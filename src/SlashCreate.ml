type imageFormat = [ `jpg | `jpeg | `png | `webp | `gif ]

type requireAllParams

(* FIXME: functional `filter` argument NYI *)
(* FIXME: type the `resolve` argument *)
external requireAllParams :
  dirname:string ->
  ?excludeDirs:Js.Re.t ->
  ?filter:Js.Re.t ->
  ?map:(name:string -> path:string -> string) ->
  ?recursive:bool ->
  ?resolve:(< .. > Js.t -> < .. > Js.t) ->
  unit ->
  requireAllParams = ""
  [@@bs.obj]

type syncCommandParams

external syncCommandParams :
  ?deleteCommands:bool ->
  ?skipGuildErrors:bool ->
  ?syncGuilds:bool ->
  unit ->
  syncCommandParams = ""
  [@@bs.obj]

module SlashCreator = struct
  type t

  type params

  external params :
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
    params = ""
    [@@bs.obj]

  external createWith : params -> t = "SlashCreator"
    [@@bs.new] [@@bs.module "slash-create"]

  external commandsPath : t -> string Js.undefined = "" [@@bs.get]

  external registerCommandsInPath : string -> t = "" [@@bs.send.pipe: t]

  external registerCommandsIn : requireAllParams -> t = "" [@@bs.send.pipe: t]

  external syncCommandsWith : syncCommandParams -> t = "syncCommands" [@@bs.send.pipe: t]

  let syncCommands ?deleteCommands ?skipGuildErrors ?syncGuilds creator =
     syncCommandsWith
       (syncCommandParams ?deleteCommands ?skipGuildErrors ?syncGuilds ())
       creator
end

module SlashCommand = struct
  module Option = struct
    type value

    external valueOfString : string -> value = "%identity"

    external valueOfFloat : float -> value = "%identity"

    external valueOfInt : int -> value = "%identity"

    type choice = { name : string; value : value }

    type t = {
       _type :
         ([ `sub_command
          | `sub_command_group
          | `string
          | `integer
          | `boolean
          | `user
          | `channel ]
         [@int]);
           [@as "type"]
       name : string;
       description : string;
       options : t array Js.undefined;
       choices : choice array Js.undefined;
       default : bool Js.undefined;
       required : bool Js.undefined;
     }
  end

  external opt :
    _type:
      ([ `sub_command
       | `sub_command_group
       | `string
       | `integer
       | `boolean
       | `user
       | `channel ]
      [@int]) ->
    name:string ->
    description:string ->
    ?options:Option.t array ->
    ?choices:Option.choice array ->
    ?default:bool ->
    ?required:bool ->
    unit ->
    Option.t = ""
    [@@obj]

  type params

  type throttlingParams = { duration : int; usages : int }

  external params :
    name:string ->
    description:string ->
    ?guildIDs:string array ->
    ?options:Option.t array ->
    ?requiredPermissions:string array ->
    ?throttling:throttlingParams ->
    ?unknown:bool ->
    unit ->
    params = ""
    [@@bs.obj]

  type context (* TODO: NYI *)

  type message (* TODO: NYI *)

  type messageParams (* TODO: NYI *)

  type permission

  external permissionOfBool : bool -> permission = "%identity"

  external permissionWithErrorMessage : string -> permission = "%identity"

  type response

  external responseOfString : string -> response = "%identity"

  external responseOfMsg : messageParams -> response = "%identity"

  type onBlockHandler =
     context -> string -> Js.Json.t -> message Js.nullable Js.Promise.t Js.undefined

  type t = {
     (* Properties *)
     commandName : string;
     (* TODO: NYI: creator: *)
     description : string;
     guildIDs : string array;
     options : Option.t array;
     requiredPermissions : string array;
     (* TODO: NYI: throttling: *)
     unknown : bool;
     mutable filePath : string Js.undefined;
     (**)
     (* Handlers *)
     mutable hasPermission : context -> permission;
     mutable onBlock : onBlockHandler;
     mutable onError :
       Js.Exn.t -> context -> message Js.nullable Js.Promise.t Js.undefined;
     mutable run : context -> response Js.undefined Js.Promise.t;
   }

  external createWith : params -> t = "SlashCommand"
    [@@bs.new] [@@bs.module "slash-create"]

  type throttleStatus = { throttle : throttlingParams; remaining : int }

  let failmsg =
     "throttleStatusOfJson: argument doesn't match ThrottlingParams signature"
     [@@bs.inline]


  let throttleParamsOfJson o =
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
               throttle = throttleParamsOfJson throttleObj;
               remaining = int_of_float remainingFl;
             }
         | _ -> failwith failmsg)
     | _ -> failwith failmsg


  type strictOnBlockHandler =
     context ->
     [ `permission of string | `throttling of throttleStatus ] ->
     message Js.Nullable.t Js.Promise.t Js.undefined

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
     guildID : string Js.undefined;
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
