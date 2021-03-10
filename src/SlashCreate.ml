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

  type context

  type message

  type permission

  type data

  external permissionOfBool : bool -> permission = "%identity"

  external permissionWithErrorMessage : string -> permission = "%identity"

  type t = {
     commandName : string;
     (* creator: *) description : string;
     filePath : string option;
     guildIDs : string array;
     (* options: *) requiredPermissions : string array;
     (* throttling: *) unknown : bool;
     mutable hasPermission : context -> permission;
     mutable onBlock :
       context -> string -> Js.Json.t -> message Js.Nullable.t Js.Promise.t option;
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


  let handleOnBlock :
      (context ->
      [ `permission of string | `throttling of throttleStatus ] ->
      message Js.Nullable.t Js.Promise.t option) ->
      t ->
      unit =
    fun f self ->
     let wrapper :
         context -> string -> Js.Json.t -> message Js.Nullable.t Js.Promise.t option =
       fun ctx reason data ->
        let f = f ctx in
        let open Js in
        match (reason, Json.classify data) with
        | "permission", JSONString s -> f @@ `permission s
        | "throttling", JSONObject o -> f @@ `throttling (throttleStatusOfJson o)
        | _ -> failwith ("Unimplemented onBlock reason: " ^ reason)
     in
     self.onBlock <- wrapper
end
