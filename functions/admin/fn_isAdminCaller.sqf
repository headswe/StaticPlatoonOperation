// Server: true when the current call is local to the server or was remote-executed by a logged-in admin.
if (!isRemoteExecuted) exitWith { true };
private _owner = remoteExecutedOwner;
// owner 2 is the server, which is also the host on a player-hosted game
_owner == 2 || {(admin _owner) > 0}
