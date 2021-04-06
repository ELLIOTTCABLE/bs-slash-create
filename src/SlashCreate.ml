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
  ?syncGuilds:bool ->
  ?skipGuildErrors:bool ->
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
    ?endpointPath:string ->
    ?serverHost:string ->
    ?serverPort:int ->
    ?unknownCommandResponse:bool ->
    ?autoAcknowledgeSource:bool ->
    (* FIXME: NYI ?allowedMentions:??? -> *)
    ?defaultImageFormat:imageFormat ->
    ?defaultImageSize:int ->
    ?latencyThreshold:int ->
    ?ratelimiterOffset:int ->
    ?requestTimeout:int ->
    ?maxSignatureTimestamp:int ->
    (* FIXME: NYI ?agent:??? -> *)
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

module BitField = struct
  type t = { bitfield : int }
end

module UserFlags = struct
  type t = BitField.t

  let dISCORD_EMPLOYEE = 1

  let pARTNERED_SERVER_OWNER = 1 lsl 1

  let hYPESQUAD_EVENTS = 1 lsl 2

  let bUG_HUNTER_LEVEL_1 = 1 lsl 3

  let hOUSE_BRAVERY = 1 lsl 6

  let hOUSE_BRILLIANCE = 1 lsl 7

  let hOUSE_BALANCE = 1 lsl 8

  let eARLY_SUPPORTER = 1 lsl 9

  let tEAM_USER = 1 lsl 10

  let sYSTEM = 1 lsl 12

  let bUG_HUNTER_LEVEL_2 = 1 lsl 14

  let vERIFIED_BOT = 1 lsl 16

  let eARLY_VERIFIED_BOT_DEVELOPER = 1 lsl 17
end

module Permissions = struct
  type t = BitField.t

  let cREATE_INSTANT_INVITE = 1 lsl 0

  let kICK_MEMBERS = 1 lsl 1

  let bAN_MEMBERS = 1 lsl 2

  let aDMINISTRATOR = 1 lsl 3

  let mANAGE_CHANNELS = 1 lsl 4

  let mANAGE_GUILD = 1 lsl 5

  let aDD_REACTIONS = 1 lsl 6

  let vIEW_AUDIT_LOG = 1 lsl 7

  let pRIORITY_SPEAKER = 1 lsl 8

  let sTREAM = 1 lsl 9

  let vIEW_CHANNEL = 1 lsl 10

  let sEND_MESSAGES = 1 lsl 11

  let sEND_TTS_MESSAGES = 1 lsl 12

  let mANAGE_MESSAGES = 1 lsl 13

  let eMBED_LINKS = 1 lsl 14

  let aTTACH_FILES = 1 lsl 15

  let rEAD_MESSAGE_HISTORY = 1 lsl 16

  let mENTION_EVERYONE = 1 lsl 17

  let uSE_EXTERNAL_EMOJIS = 1 lsl 18

  let vIEW_GUILD_INSIGHTS = 1 lsl 19

  let cONNECT = 1 lsl 20

  let sPEAK = 1 lsl 21

  let mUTE_MEMBERS = 1 lsl 22

  let dEAFEN_MEMBERS = 1 lsl 23

  let mOVE_MEMBERS = 1 lsl 24

  let uSE_VAD = 1 lsl 25

  let cHANGE_NICKNAME = 1 lsl 26

  let mANAGE_NICKNAMES = 1 lsl 27

  let mANAGE_ROLES = 1 lsl 28

  let mANAGE_WEBHOOKS = 1 lsl 29

  let mANAGE_EMOJIS = 1 lsl 30
end

module User = struct
  type t = private {
     id : string;
     username : string;
     discriminator : string;
     avatar : string Js.undefined;
     bot : bool;
     (* *)
     flags : UserFlags.t;
     mention : string;
     defaultAvatar : float;
     defaultAvatarURL : string;
     avatarURL : string;
   }

  external dynamicAvatarURL : ?format:imageFormat -> ?size:int -> string = ""
    [@@bs.send.pipe: t]
end

module Member = struct
  (* FIXME: This is private, I think? *)
  type unresolved

  type t = private {
     id : string;
     nick : string option;
     joinedAt : float;
     roles : string array;
     premiumSince : float option;
     pending : bool;
     user : User.t;
     (* *)
     mention : string;
     displayName : string;
     (* *)
     mute : bool;
     deaf : bool;
     (* *)
     permissions : Permissions.t;
   }
end

module Message = struct
  (* TODO: NYI *)
  type attachment

  type allowance

  external blanketAllowance : bool -> allowance = "%identity"

  external specificAllowance : string array -> allowance = "%identity"

  type allowedMentions = {
     everyone : bool;
     roles : allowance Js.undefined;
     users : allowance Js.undefined;
   }

  type editParams = {
     content : string Js.undefined;
     embeds : Js.Json.t array Js.undefined;
     allowMentions : allowedMentions;
   }

  type followUpParams = {
     content : string Js.undefined;
     embeds : Js.Json.t array Js.undefined;
     allowMentions : allowedMentions;
     flags : int Js.undefined;
     tts : bool Js.undefined;
   }

  type params = {
     content : string Js.undefined;
     embeds : Js.Json.t array Js.undefined;
     allowMentions : allowedMentions;
     flags : int Js.undefined;
     tts : bool Js.undefined;
     ephemeral : bool Js.undefined;
     includeSource : bool Js.undefined;
   }

  type t = private {
     id : string;
     _type : int;
     content : string;
     channelID : string;
     author : User.t;
     attachments : attachment array;
     (* TODO: is this JSON? *)
     embeds : Js.Json.t array;
     mentions : string array;
     roleMentions : string array;
     mentionedEveryone : bool;
     tts : bool;
     timestamp : float;
     editedTimestamp : float Js.undefined;
     flags : int;
     webhookID : string;
   }

  (* FIXME: typeme *)
  type unknown

  external delete : t -> unknown Js.Promise.t = "" [@@bs.send]

  external edit :
    t -> ([ `Content of string | `Params of editParams ][@bs.unwrap]) -> t Js.Promise.t
    = ""
    [@@bs.send]
end

module CommandContext = struct
  type channel (* TODO: NYI *)

  type role (* TODO: NYI *)

  type t = private {
     creator : SlashCreator.t;
     (* TODO: NYI: data: *)
     interactionToken : string;
     interactionID : string;
     channelID : string;
     guildID : string Js.undefined;
     member : Member.unresolved;
     user : User.t;
     (* *)
     commandName : string;
     commandID : string;
     options : Js.Json.t;
     subcommands : string array;
     invokedAt : float;
     mutable initiallyResponded : bool;
     (* *)
     users : User.t Js.Dict.t;
     members : Member.t Js.Dict.t;
     roles : role Js.Dict.t;
     channels : channel Js.Dict.t;
     (* *)
     expired : bool;
   }

  external acknowledge : t -> ?includeSource:bool -> unit -> bool Js.Promise.t = ""
    [@@bs.send]

  external delete : t -> ?messageID:string -> unit -> unit Js.Promise.t = "" [@@bs.send]

  external edit :
    t ->
    messageID:string ->
    ([ `Content of string | `Params of Message.editParams ][@bs.unwrap]) ->
    Message.t Js.Promise.t = ""
    [@@bs.send]

  external editOriginal :
    t ->
    ([ `Content of string | `Params of Message.editParams ][@bs.unwrap]) ->
    Message.t Js.Promise.t = ""
    [@@bs.send]

  external _send :
    t ->
    ([ `Content of string | `Params of Message.params ][@bs.unwrap]) ->
    Js.Json.t Js.Promise.t = ""
    [@@bs.send]

  external assertIsMessage : Js.Json.t Js.Dict.t -> Message.t = "%identity"

  let send :
      t ->
      [ `Content of string | `Params of Message.params ] ->
      [ `Initial of bool | `Message of Message.t ] Js.Promise.t =
    fun t x ->
     let open Js in
     _send t x
     |> Promise.then_ (fun rv ->
            match Json.classify rv with
            | JSONFalse -> Promise.resolve @@ `Initial false
            | JSONTrue -> Promise.resolve @@ `Initial true
            | JSONObject o -> Promise.resolve @@ `Message (assertIsMessage o)
            | _ -> failwith "unexpected return-value from send()")


  external sendFollowUp :
    t ->
    ([ `Content of string | `Params of Message.followUpParams ][@bs.unwrap]) ->
    Message.t Js.Promise.t = ""
    [@@bs.send]
end

module SlashCommand = struct
  module Option = struct
    type fixedValue

    external fixedValueOfString : string -> fixedValue = "%identity"

    external fixedValueOfFloat : float -> fixedValue = "%identity"

    external fixedValueOfInt : int -> fixedValue = "%identity"

    type choice = { name : string; value : fixedValue }

    type t = private {
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
       default : bool Js.undefined;
       required : bool Js.undefined;
       choices : choice array Js.undefined;
       options : t array Js.undefined;
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

  type permission

  external permissionOfBool : bool -> permission = "%identity"

  external permissionWithErrorMessage : string -> permission = "%identity"

  type response

  external responseOfString : string -> response = "%identity"

  external responseOfMsg : Message.params -> response = "%identity"

  type onBlockHandler = CommandContext.t -> string -> Js.Json.t -> unit

  (* FIXME: This should be [private], but needs setters for the mutable handlers. *)
  type t = {
     commandName : string;
     description : string;
     options : Option.t array;
     guildIDs : string array;
     requiredPermissions : string array;
     throttling : throttlingParams;
     unknown : bool;
     mutable filePath : string Js.undefined;
     creator : SlashCreator.t;
     (* *)
     mutable hasPermission : CommandContext.t -> permission;
     mutable onBlock : onBlockHandler;
     mutable onError : Js.Exn.t -> CommandContext.t -> unit;
     mutable run : CommandContext.t -> response Js.undefined Js.Promise.t;
   }

  external createWith : params -> t = "SlashCommand"
    [@@bs.new] [@@bs.module "slash-create"]

  type throttleStatus = { throttle : throttlingParams; remaining : int }

  let failmsg =
     "throttleStatusOfJson: argument doesn't match ThrottlingParams signature"
     [@@bs.inline]


  let throttlingParamsOfJson o =
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
               throttle = throttlingParamsOfJson throttleObj;
               remaining = int_of_float remainingFl;
             }
         | _ -> failwith failmsg)
     | _ -> failwith failmsg


  type strictOnBlockHandler =
     CommandContext.t -> [ `permission of string | `throttling of throttleStatus ] -> unit

  let wrapOnBlockHandler : strictOnBlockHandler -> onBlockHandler =
    fun f ctx reason data ->
     let f = f ctx in
     let open Js in
     match (reason, Json.classify data) with
     | "permission", JSONString s -> f @@ `permission s
     | "throttling", JSONObject o -> f @@ `throttling (throttleStatusOfJson o)
     | _ -> failwith ("Unimplemented onBlock reason: " ^ reason)
end
