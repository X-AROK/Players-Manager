#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "X-AROK"
#define PLUGIN_VERSION "1.00b"

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

public Plugin myinfo = 
{
	name = "Players Manager",
	author = PLUGIN_AUTHOR,
	description = "",
	version = PLUGIN_VERSION,
	url = ""
};

Database g_hDatabase;

enum struct Player{
	int client;
	
	int id;
	char steamId[64];
	int balance;
	int time;
	int rank;
	
	bool isLoaded;
		
	void initPlayer(int client){
		this.client = client;
		GetClientAuthId(this.client, AuthId_Engine, this.steamId, 64, true);
		
		LoadPlayerFromDb(this.client, this.steamId);
	}
	
	void updatePlayer(){
		char szQuery[256];
		FormatEx(szQuery, sizeof(szQuery), "UPDATE `users` SET `balance` = '%i', `time` = '%i', `rank` = '%i' WHERE `steamid` = '%s';", this.balance, this.time, this.rank, this.steamId);
		g_hDatabase.Query(SQL_Callback_UpdateClient, szQuery);
	}
}

Player g_Players[MAXPLAYERS + 1];

#include "PlayersManager/natives.sp"


/*********************************
*
*			EVENTS
*
**********************************/
public void OnPluginStart(){
	Database.Connect(ConnectCallBack, "excetra");
}
public void OnPluginEnd(){
	for (int i = 1; i <= MAXPLAYERS; i++){
		if(g_Players[i].isLoaded){
			g_Players[i].updatePlayer();
		}
	}
}
public void OnClientAuthorized(int client){
	if(!IsFakeClient(client)){
		g_Players[client].initPlayer(client);
	}
}
public void OnClientDisconnect(int client){
	if(g_Players[client].isLoaded){
		g_Players[client].updatePlayer();
		g_Players[client].isLoaded = false;
	}
}

/*********************************
*
*			FUNC
*
**********************************/
void LoadPlayerFromDb(int client, char[] steamId){
	char szQuery[256];
	FormatEx(szQuery, sizeof(szQuery), "SELECT * FROM `users` WHERE `steamid` = '%s';", steamId);
	g_hDatabase.Query(SQL_Callback_SelectClient, szQuery, GetClientUserId(client));
}

/*********************************
*
*			CALLBACKS
*
**********************************/
public void ConnectCallBack (Database hDB, const char[] szError, any data){
	if (hDB == null || szError[0]){
		SetFailState("Database failure: %s", szError);
		return;
	}
	g_hDatabase = hDB;
	g_hDatabase.SetCharset("utf8");
}

public void SQL_Callback_SelectClient(Database hDatabase, DBResultSet results, const char[] sError, any iUserID){
	if(sError[0]){
		LogError("SQL_Callback_SelectClient: %s", sError);
		return;
	}
	int iClient = GetClientOfUserId(iUserID);
	if(iClient){
		if(results.FetchRow()){
			g_Players[iClient].id = results.FetchInt(0);
			results.FetchString(1, g_Players[iClient].steamId, 64);
			g_Players[iClient].balance = results.FetchInt(2);
			g_Players[iClient].time = results.FetchInt(3);
			g_Players[iClient].rank = results.FetchInt(4);
			g_Players[iClient].isLoaded = true;
		}
		else{
			char szQuery[256], szAuth[64];
			GetClientAuthId(iClient, AuthId_Engine, szAuth, 64, true);
			FormatEx(szQuery, sizeof(szQuery), "INSERT INTO `users` (`steamid`) VALUES ('%s');", szAuth);
			g_hDatabase.Query(SQL_Callback_InsertClient, szQuery, GetClientUserId(iClient));
		}
	}
}

public void SQL_Callback_InsertClient(Database hDatabase, DBResultSet results, const char[] sError, any iUserID){
	if(sError[0]){
		LogError("SQL_Callback_InsertClient: %s", sError);
		return;
	}
	int iClient = GetClientOfUserId(iUserID);
	if(iClient){
		char szAuth[64];
		GetClientAuthId(iClient, AuthId_Engine, szAuth, 64, true);
		LoadPlayerFromDb(iClient, szAuth);
	}
}

public void SQL_Callback_UpdateClient(Database hDatabase, DBResultSet results, const char[] sError, any data){
	if(sError[0]){
		LogError("SQL_Callback_UpdateClient: %s", sError);
		return;
	}
}