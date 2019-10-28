public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max){
	CreateNative("PM_setClientBalance", Native_PM_setClientBalance);
	CreateNative("PM_setClientTime", Native_PM_setClientTime);
	CreateNative("PM_setClientRank", Native_PM_setClientRank);
	
	CreateNative("PM_addToClientBalance", Native_PM_addToClientBalance);
	CreateNative("PM_addToClientTime", Native_PM_addToClientTime);
	CreateNative("PM_IncreaseClientRank", Native_PM_IncreaseClientRank);
	
	CreateNative("PM_getClientBalance", Native_PM_getClientBalance);
	CreateNative("PM_getClientTime", Native_PM_getClientTime);
	CreateNative("PM_getClientRank", Native_PM_getClientRank);
	
	CreateNative("PM_updateClient", Native_PM_updateClient);
	
	CreateNative("PM_isClientLoaded", Native_PM_isClientLoaded);
	
	RegPluginLibrary("playersmanager");
}

public int Native_PM_setClientBalance(Handle hPlugin, int iNumParams){
	int client = GetNativeCell(1);
	int newBalance = GetNativeCell(2);
	g_Players[client].balance = newBalance;
}

public int Native_PM_setClientTime(Handle hPlugin, int iNumParams){
	int client = GetNativeCell(1);
	int newTime = GetNativeCell(2);
	g_Players[client].time = newTime;
}

public int Native_PM_setClientRank(Handle hPlugin, int iNumParams){
	int client = GetNativeCell(1);
	int newRank = GetNativeCell(2);
	g_Players[client].rank = newRank;
}

public int Native_PM_addToClientBalance(Handle hPlugin, int iNumParams){
	int client = GetNativeCell(1);
	int addBalance = GetNativeCell(2);
	g_Players[client].balance += addBalance;
}

public int Native_PM_addToClientTime(Handle hPlugin, int iNumParams){
	int client = GetNativeCell(1);
	int addTime = GetNativeCell(2);
	g_Players[client].time += addTime;
}

public int Native_PM_IncreaseClientRank(Handle hPlugin, int iNumParams){
	int client = GetNativeCell(1);
	g_Players[client].rank++;
}

public int Native_PM_getClientBalance(Handle hPlugin, int iNumParams){
	int client = GetNativeCell(1);
	return g_Players[client].balance;
}

public int Native_PM_getClientTime(Handle hPlugin, int iNumParams){
	int client = GetNativeCell(1);
	return g_Players[client].time;
}

public int Native_PM_getClientRank(Handle hPlugin, int iNumParams){
	int client = GetNativeCell(1);
	return g_Players[client].rank;
}

public int Native_PM_updateClient(Handle hPlugin, int iNumParams){
	int client = GetNativeCell(1);
	g_Players[client].updatePlayer();
}

public int Native_PM_isClientLoaded(Handle hPlugin, int iNumParams){
	int client = GetNativeCell(1);
	return g_Players[client].isLoaded;
}