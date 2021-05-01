type imageFormat = [ `gif | `jpeg | `jpg | `png | `webp ]

type requireAllParams

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
(** Constructs parameters for {!SlashCreator.registerCommandsIn}.

    @see <https://github.com/felixge/node-require-all> These arguments are passed to the
    npm module [node-require-all].
    @param dirname The directory to include source-files from
    @param excludeDirs A matcher for subdirectories to ignore, e.g.
    [ \[%re "^\.(git|svn)$"\] ]
    @param filter A matcher for files to include, e.g. [ \[%re "^(.+Controller)\.js$"\] ]
    @param map Callback to tweak the command-names generated from the filenames
    @param recursive Whether to look for commands in sub-directories
    @param resolve Callback to manipulate how returned values are constructed into
    commands *)

type syncCommandParams

external syncCommandParams :
  ?deleteCommands:bool ->
  ?syncGuilds:bool ->
  ?skipGuildErrors:bool ->
  unit ->
  syncCommandParams = ""
  [@@bs.obj]
(** Constructs parameters for {!SlashCreator.syncCommandsWith}; note that you probably
    want {!SlashCreator.syncCommands} instead. *)

module BitField : sig
  type t = { bitfield : int }
  (** Data structure that "makes it easy to interact with a bitfield."

      (Reduntant JavaScript-side methods are not implemented here; use builtins like
      [land].) *)
end

module UserFlags : sig
  type t = BitField.t
  (** Data structure that makes it easy to interact with a {!User.t.flags} bitfield. *)

  val dISCORD_EMPLOYEE : int

  val pARTNERED_SERVER_OWNER : int

  val hYPESQUAD_EVENTS : int

  val bUG_HUNTER_LEVEL_1 : int

  val hOUSE_BRAVERY : int

  val hOUSE_BRILLIANCE : int

  val hOUSE_BALANCE : int

  val eARLY_SUPPORTER : int

  val tEAM_USER : int

  val sYSTEM : int

  val bUG_HUNTER_LEVEL_2 : int

  val vERIFIED_BOT : int

  val eARLY_VERIFIED_BOT_DEVELOPER : int
end

module Permissions : sig
  type t = BitField.t
  (** Data structure that makes it easy to interact with a {!Member.t.permissions}
      bitfield. *)

  val cREATE_INSTANT_INVITE : int

  val kICK_MEMBERS : int

  val bAN_MEMBERS : int

  val aDMINISTRATOR : int

  val mANAGE_CHANNELS : int

  val mANAGE_GUILD : int

  val aDD_REACTIONS : int

  val vIEW_AUDIT_LOG : int

  val pRIORITY_SPEAKER : int

  val sTREAM : int

  val vIEW_CHANNEL : int

  val sEND_MESSAGES : int

  val sEND_TTS_MESSAGES : int

  val mANAGE_MESSAGES : int

  val eMBED_LINKS : int

  val aTTACH_FILES : int

  val rEAD_MESSAGE_HISTORY : int

  val mENTION_EVERYONE : int

  val uSE_EXTERNAL_EMOJIS : int

  val vIEW_GUILD_INSIGHTS : int

  val cONNECT : int

  val sPEAK : int

  val mUTE_MEMBERS : int

  val dEAFEN_MEMBERS : int

  val mOVE_MEMBERS : int

  val uSE_VAD : int

  val cHANGE_NICKNAME : int

  val mANAGE_NICKNAMES : int

  val mANAGE_ROLES : int

  val mANAGE_WEBHOOKS : int

  val mANAGE_EMOJIS : int
end

module User : sig
  type t = private {
     id : string;  (** The user's ID. *)
     username : string;  (** The user's username. *)
     discriminator : string;  (** The user's discriminator. *)
     avatar : string Js.undefined;  (** The user's avatar hash. *)
     bot : bool;  (** Whether the user is a bot. *)
     (* *)
     flags : UserFlags.t;  (** The public flags for the user. *)
     mention : string;  (** A string that mentions the user. *)
     defaultAvatar : float;
         (** The hash for the default avatar of a user if there is no avatar set. *)
     defaultAvatarURL : string;  (** The URL of the user's default avatar. *)
     avatarURL : string;  (** The URL of the user's avatar. *)
   }
  (** Represents a user on Discord. *)

  external dynamicAvatarURL : ?format:imageFormat -> ?size:int -> string = ""
    [@@bs.send.pipe: t]
  (** Get the user's avatar with the given format and size.

      @param format The format of the avatar
      @param size The size of the avatar *)
end

module Member : sig
  type unresolved

  type t = private {
     id : string;  (** The member's ID *)
     nick : string option;  (** The member's nickname *)
     joinedAt : float;  (** The timestamp the member joined the guild *)
     roles : string array;  (** An array of role IDs that the user has. *)
     premiumSince : float option;  (** The time of when this member boosted the server. *)
     pending : bool;  (** Whether the member is pending verification *)
     user : User.t;  (** The user object for this member *)
     (* *)
     mention : string;  (** The string that mentions this member. *)
     displayName : string;  (** The display name for this member. *)
     mute : bool;  (** Whether the user is muted in voice channels *)
     deaf : bool;  (** Whether the user is deafened in voice channels *)
     permissions : Permissions.t;  (** The permissions the member has. *)
   }
end

(* FORMAT MEEEEEEE *)
module Role : sig
  type t = private {
     id : string;  (** The role's ID *)
     name : string;  (** The role's name *)
     position : int;  (** The role's position *)
     color : int;  (** The role's color integer *)
     hoist : bool;  (** Whether the role is being hoisted *)
     managed : bool;  (** Whether the role is being managed by an application *)
     mentionable : bool;  (** Whether the role is mentionable by everyone *)
     (* *)
     mention : string;  (** The string that mentions this role. *)
     colorHex : string;  (** The role's color in hexadecimal, with a leading hashtag *)
     permissions : Permissions.t;  (** The permissions the member has. *)
   }
  (** Represents a resolved role object. *)
end

module Channel : sig
  type t = private {
     id : string;  (** The channel's ID *)
     name : string;  (** The channel's name *)
     _type : int;  (** The channel's type *)
     (* *)
     mention : string;  (** The string that mentions this channel. *)
   }
  (** Represents a resolved channel object. *)
end

module Message : sig
  type attachment

  type allowance
  (** Abstract construct-only sum-type of [bool] and [string array] for
      {!allowedMentions}. *)

  external blanketAllowance : bool -> allowance = "%identity"
  (** Constructs an {!allowedMentions} {!allowance} from a [bool]. *)

  external specificAllowance : string array -> allowance = "%identity"
  (** Constructs an {!allowedMentions} {!allowance} from an array of [string]s. *)

  type allowedMentions = {
     everyone : bool;
     roles : allowance Js.undefined;
     users : allowance Js.undefined;
   }
  (** The allowed mentions for a {!Message.t}. *)

  type editParams = {
     content : string Js.undefined;  (** The message content. *)
     embeds : Js.Json.t array Js.undefined;  (** The embeds of the message. *)
     allowMentions : allowedMentions;
         (** The mentions allowed to be used in this message. *)
   }
  (** The options for {!Message.edit}. *)

  type followUpParams = {
     content : string Js.undefined;  (** The message content. *)
     embeds : Js.Json.t array Js.undefined;  (** The embeds of the message. *)
     allowMentions : allowedMentions;
         (** The mentions allowed to be used in this message. *)
     flags : int Js.undefined;  (** Whether to use TTS for the content. *)
     tts : bool Js.undefined;  (** The flags to use in the message. *)
   }
  (** The options for {!CommandContext.sendFollowUp}. *)

  type params = {
     content : string Js.undefined;  (** The message content. *)
     embeds : Js.Json.t array Js.undefined;  (** The embeds of the message. *)
     allowMentions : allowedMentions;
         (** The mentions allowed to be used in this message. *)
     flags : int Js.undefined;  (** Whether to use TTS for the content. *)
     tts : bool Js.undefined;  (** The flags to use in the message. *)
     ephemeral : bool Js.undefined;
         (** Whether or not the message should be ephemeral.

             Ignored if `flags` is defined. *)
     includeSource : bool Js.undefined;
         (** Whether or not to include the source of the interaction in the message. *)
   }
  (** The options for {!CommandContext.send}. *)

  type t = private {
     id : string;  (** The message's ID *)
     _type : int;  (** The message type *)
     content : string;  (** The content of the message *)
     channelID : string;  (** The ID of the channel the message is in *)
     author : User.t;  (** The author of the message *)
     attachments : attachment array;  (** The message's attachments *)
     embeds : Js.Json.t array;  (** The message's embeds *)
     mentions : string array;  (** The message's user mentions *)
     roleMentions : string array;  (** The message's role mentions *)
     mentionedEveryone : bool;  (** Whether the message mentioned everyone/here *)
     tts : bool;  (** Whether the message used TTS *)
     timestamp : float;  (** The timestamp of the message *)
     editedTimestamp : float Js.undefined;
         (** The timestamp of when the message was last edited *)
     flags : int;  (** The message's flags *)
     webhookID : string;  (** The message's webhook ID *)
   }
  (** Represents a Discord message. *)

  type unknown

  external delete : t -> unknown Js.Promise.t = "" [@@bs.send]
  (** Deletes this message. *)

  external edit :
    t -> ([ `Content of string | `Params of editParams ][@bs.unwrap]) -> t Js.Promise.t
    = ""
    [@@bs.send]
  (** Edits this message.

      @param self The message to edit
      @param options The message content, or a structure of message options *)
end

module SlashCreator : sig
  type t
  (** The main class for using commands and interactions. *)

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
    ?allowedMentions:Message.allowedMentions ->
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
  (** Constructs parameters for {!SlashCreator.createWith}.

      @param applicationID Your application's ID
      @param publicKey The public key for your application. Required for webservers.
      @param token The bot/client token for the application. Recommended to set this in
      your config.
      @param endpointPath The path where the server will listen for interactions.
      @param serverPort The port where the server will listen on.
      @param serverHost The host where the server will listen on.
      @param unknownCommandResponse Whether to respond to an unknown command with an
      ephemeral message. If an unknown command is registered, this is ignored.
      @param autoAcknowledgeSource Whether to include source in the auto-acknowledgement
      timeout.
      @param allowedMentions The default allowed mentions for all messages.
      @param defaultImageFormat The default format to provide user avatars in.
      @param defaultImageSize The default image size to provide user avatars in.
      @param latencyThreshold The average latency where SlashCreate will start emitting
      warnings for.
      @param ratelimiterOffset A number of milliseconds to offset the ratelimit timing
      calculations by.
      @param requestTimeout A number of milliseconds before requests are considered timed
      out.
      @param maxSignatureTimestamp A number of milliseconds before requests with a
      timestamp past that time get rejected.
      @param agent A HTTP Agent used to proxy requests *)

  external createWith : params -> t = "SlashCreator"
    [@@bs.new] [@@bs.module "slash-create"]
  (** Construct a {!SlashCreator.t}; accepts options constructed by {!val:params}. *)

  external commandsPath : t -> string Js.undefined = ""
    [@@bs.get]
  (** The path where the commands were loaded from. See {!registerCommandsIn},
      {!registerCommandsInPath}. *)

  external registerCommandsInPath : string -> t = ""
    [@@bs.send.pipe: t]
  (** Registers all commands in a directory. The files must export a Command class
      constructor or instance. This is a short form for {!registerCommandsIn}.

      @param path The path to the directory

      @see <https://slash-create.js.org/#/docs/main/latest/class/SlashCreator?scrollTo=registerCommandsIn> *)

  external registerCommandsIn : requireAllParams -> t = ""
    [@@bs.send.pipe: t]
  (** Registers all commands in a directory. The files must export a Command class
      constructor or instance. See {!registerCommandsInPath} for a shorter form.

      @param requireAllParams Parameters constructed with {!val:requireAllParams}

      @see <https://slash-create.js.org/#/docs/main/latest/class/SlashCreator?scrollTo=registerCommandsIn> *)

  external syncCommandsWith : syncCommandParams -> t = "syncCommands" [@@bs.send.pipe: t]

  val syncCommands :
    ?deleteCommands:bool -> ?skipGuildErrors:bool -> ?syncGuilds:bool -> t -> t
  (** Sync all commands with Discord. This ensures that commands exist when handling them.

      This requires you to have your token set in the creator config.

      @param deleteCommands Whether to delete commands that do not exist in the creator.
      @param syncGuilds Whether to sync guild-specific commands.
      @param skipGuildErrors Whether to skip over guild syncing errors. (Guild syncs most
      likely can error if that guild no longer exists.) *)
end

module CommandContext : sig
  type t = private {
     creator : SlashCreator.t;  (** The creator of the command. *)
     interactionToken : string;  (** The interaction's token. *)
     interactionID : string;  (** The interaction's ID. *)
     channelID : string;  (** The channel ID that the command was invoked in. *)
     guildID : string Js.undefined;  (** The guild ID that the command was invoked in. *)
     member : Member.unresolved;  (** The member that invoked the command. *)
     user : User.t;  (** The user that invoked the command. *)
     (* *)
     commandName : string;  (** The command's name. *)
     commandID : string;  (** The command's ID. *)
     options : Js.Json.t;  (** The options given to the command. *)
     subcommands : string array;  (** The subcommands the member used in order. *)
     invokedAt : float;  (** The time when the context was created. *)
     mutable initiallyResponded : bool;  (** Whether the initial response was made. *)
     (* *)
     users : User.t Js.Dict.t;  (** The resolved users of the interaction. *)
     members : Member.t Js.Dict.t;  (** The resolved members of the interaction. *)
     roles : Role.t Js.Dict.t;  (** The resolved roles of the interaction. *)
     channels : Channel.t Js.Dict.t;  (** The resolved channels of the interaction. *)
     (* *)
     expired : bool;
         (** Whether the interaction has expired. Interactions last 15 minutes. *)
   }

  external acknowledge : t -> ?includeSource:bool -> unit -> bool Js.Promise.t = ""
    [@@bs.send]
  (** Acknowleges the interaction. Including source will send a message showing only the
      source.

      @param includeSource Whether to include the source in the acknowledgement *)

  external delete : t -> ?messageID:string -> unit -> unit Js.Promise.t = ""
    [@@bs.send]
  (** Deletes a message. If the message ID was not defined, the original message is used.

      @param messageID The message's ID *)

  external edit :
    t ->
    messageID:string ->
    ([ `Content of string | `Params of Message.editParams ][@bs.unwrap]) ->
    Message.t Js.Promise.t = ""
    [@@bs.send]
  (** Edits a message.

      @param self The context within which to send the message
      @param messageID The message's ID
      @param options The message content, or a structure of message options *)

  external editOriginal :
    t ->
    ([ `Content of string | `Params of Message.editParams ][@bs.unwrap]) ->
    Message.t Js.Promise.t = ""
    [@@bs.send]
  (** Edits the original message. This is put on a timeout of 150 ms for webservers to
      account for Discord recieving and processing the original response.

      Note: This will error with ephemeral messages or acknowledgements.

      @param self The context within which to edit the message
      @param options The message content, or a structure of message options *)

  external _send :
    t ->
    ([ `Content of string | `Params of Message.params ][@bs.unwrap]) ->
    Js.Json.t Js.Promise.t = ""
    [@@bs.send]

  external assertIsMessage : Js.Json.t Js.Dict.t -> Message.t = "%identity"

  val send :
    t ->
    [ `Content of string | `Params of Message.params ] ->
    [ `Initial of bool | `Message of Message.t ] Js.Promise.t
  (** Sends a message, if it already made an initial response, this will create a
      follow-up message. This will return a boolean if it's an initial response, otherwise
      a {!Message.t} will be returned.

      Note that when making a follow-up message, the {!Message.ephemeral} and
      {!Message.includeSource} are ignored.

      @param self The context within which to send the message
      @param options The message content, or a structure of message options *)

  external sendFollowUp :
    t ->
    ([ `Content of string | `Params of Message.followUpParams ][@bs.unwrap]) ->
    Message.t Js.Promise.t = ""
    [@@bs.send]
  (** Sends a follow-up message.

      @param self The context within which to send the message
      @param options The message content, or a structure of message options *)
end

module SlashCommand : sig
  module Option : sig
    type fixedValue
    (** Abstract construct-only sum-type of [string] and [number] for {!choice}. *)

    external fixedValueOfString : string -> fixedValue = "%identity"
    (** Constructs an {!choice} {!fixedValue} from a [string]. *)

    external fixedValueOfFloat : float -> fixedValue = "%identity"
    (** Constructs an {!choice} {!fixedValue} from a [float]. *)

    external fixedValueOfInt : int -> fixedValue = "%identity"
    (** Constructs an {!choice} {!fixedValue} from a [int]. *)

    type choice = { name : string; value : fixedValue }
    (** One fixed choice for a user to pick from. *)

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
           (** The type of option this one is. *)
       name : string;  (** The name of the option. *)
       description : string;  (** The description of the option. *)
       default : bool Js.undefined;
           (** The first required option the user has to complete. *)
       required : bool Js.undefined;  (** Whether the command is required. *)
       choices : choice array Js.undefined;
           (** The choices of the option. If set, these are the only values a user can
               pick from. *)
       options : t array Js.undefined;
           (** The sub-options for the option. This can only be used for sub-commands and
               sub-command groups. *)
     }
    (** An option in an application command. Don't construct directly; use
        {!SlashCommand.opt}. *)
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
  (** Helper to construct a {!Option.t}. *)

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
  (** Construct the options for a {!SlashCommand.t}; pass to {!createWith}.

      @param name The name of the command.
      @param description The description of the command.
      @param guildIDs The guild ID(s) that this command will be assigned to.
      @param options The command's options.
      @param requiredPermissions The required permission(s) for this command.
      @param throttling The throttling options for the command.
      @param unknown Whether this command is used for unknown commands. messages. *)

  type permission
  (** Abstract construct-only sum-type of [string] and [bool] for {!t.hasPermission}
      handlers to return. *)

  external permissionOfBool : bool -> permission = "%identity"
  (** Constructs an {!t.hasPermission} {!permission} from a [bool]. *)

  external permissionWithErrorMessage : string -> permission = "%identity"
  (** Constructs an {!t.hasPermission} {!permission} from a [string]. *)

  type response
  (** Abstract construct-only sum-type of [string] and {!Message.params} for {!t.run}
      handlers to return. *)

  external responseOfString : string -> response = "%identity"
  (** Constructs an {!t.run} {!response} from a [string]. *)

  external responseOfMsg : Message.params -> response = "%identity"
  (** Constructs an {!t.run} {!response} from {!Message.params}. *)

  type onBlockHandler = CommandContext.t -> string -> Js.Json.t -> unit
  (** Type of handlers for {!onBlock}.

      @param ctx Command context the command is running from
      @param reason Reason that the command was blocked (built-in reasons are
      ["permission"], ["throttling"])
      @param data Additional data associated with the
      block.

      - permission: [response] ([Json.JSONString]) to send
      - throttling: [throttle] ([Json.JSONObject]), [remaining] ([Json.JSONNumber]) time
        in seconds *)

  type t = {
     commandName : string;  (** The command's name. *)
     description : string;  (** The command's description. *)
     options : Option.t array;  (** The options for the command. *)
     guildIDs : string array;  (** The guild ID(s) for the command. *)
     requiredPermissions : string array;
         (** The permissions required to use this command. *)
     throttling : throttlingParams;  (** The throttling options for this command. *)
     unknown : bool;  (** Whether this command is used for unknown commands. *)
     mutable filePath : string Js.undefined;
         (** The file path of the command. Used for refreshing the require cache.

             Set this to [__filename] in the constructor to enable cache clearing:

             {[
               external __filename : string = "__filename" [@@bs.val]
               command.filePath <- Js.Undefined.return __filename ;
             ]} *)
     creator : SlashCreator.t;  (** The creator responsible for this command. *)
     (* *)
     mutable hasPermission : CommandContext.t -> permission;
         (** Checks whether the context member has permission to use the command.

             @param ctx The triggering context
             @return permission Whether the member has permission, or an error message to
             respond with if they don't *)
     mutable onBlock : onBlockHandler;
         (** Called when the command is prevented from running; you probably want to use
             {!wrapOnBlockHandler}. *)
     mutable onError : Js.Exn.t -> CommandContext.t -> unit;
         (** Called when the command produces an error while running.

             @param err Error that was thrown
             @param ctx Command context the command is running from *)
     mutable run : CommandContext.t -> response Js.undefined Js.Promise.t;
         (** Runs the command.

             @param ctx The context of the interaction *)
   }

  external createWith : params -> t = "SlashCommand"
    [@@bs.new] [@@bs.module "slash-create"]
  (** Construct a {!SlashCommand.t}; accepts options constructed by {!val:params}. *)

  type throttleStatus = { throttle : throttlingParams; remaining : int }

  type strictOnBlockHandler =
     CommandContext.t -> [ `permission of string | `throttling of throttleStatus ] -> unit
  (** Strongly-typed version of the {!t.onBlock} handler. *)

  val wrapOnBlockHandler : strictOnBlockHandler -> onBlockHandler
  (** Wraps a strongly-typed handler to set {!t.onBlock} with. *)
end
