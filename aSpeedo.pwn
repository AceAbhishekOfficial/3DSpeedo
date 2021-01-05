

#include <a_samp>
#include <zcmd>

#define COLOR_LIGHTGREEN 0x24FF0AB9


public OnFilterScriptInit()
{
	print("\n----------------------------------");
	print(" 3D SPEEDOMETER BY ACE_ABHISHEK");
	print("        Version 1.0.0.1");
	print("----------------------------------\n");

}

new PlayerSpeed[MAX_PLAYERS];
new PlayerSpeedObject[MAX_PLAYERS];
new PlayerSpeedObject2[MAX_PLAYERS];
stock GetPlayerSpeedInt(playerid)
{
	new Float:svx, Float:svy, Float:svz;
	GetVehicleVelocity(GetPlayerVehicleID(playerid),svx,svy,svz);
	new Float:s1 = floatsqroot( ((svx*svx) + (svy*svy) + (svz*svz)) ) * 100;
	new speed = floatround(s1,floatround_round);
	return speed;
}

forward UpdateSpeedo(playerid);
public UpdateSpeedo(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid)) return 0;
	new msg[26];
	new spd =GetPlayerSpeedInt(playerid);
	format(msg,sizeof(msg),"{24FF0A}%i{FFFFFF} km/h",spd);
	SetPlayerObjectMaterialText(playerid,PlayerSpeedObject[playerid], msg, 0,  40, "Quartz MS", 30, 1, -13346097, 0, 2);
	SetPlayerObjectMaterialText(playerid,PlayerSpeedObject2[playerid], msg, 0,  40, "Quartz MS", 30, 1, -13346097, 0, 1);
	SetTimerEx("UpdateSpeedo",100,false,"i",playerid);
	return 1;
}
public OnGameModeInit()
{

	return 1;
}


public OnPlayerConnect(playerid)
{
	PlayerSpeed[playerid]=1;
	PlayerSpeedObject[playerid]=-1;
	return 1;
}

CMD:speedo(playerid,params[])
{
	
	if(PlayerSpeed[playerid]==1)
	{
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[Server] : Speedometer off");
		PlayerSpeed[playerid]=0;
		DestroyPlayerObject(playerid,PlayerSpeedObject[playerid]);
		DestroyPlayerObject(playerid,PlayerSpeedObject2[playerid]);
		return 1;
	}
	else if(PlayerSpeed[playerid]==0)
	{
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "[Server] : Speedometer on");
		PlayerSpeed[playerid]=1;
		if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER)		
		{
			UpdateSpeedo(playerid);
			PlayerSpeedObject[playerid] =CreatePlayerObject(playerid, 19327,0.0,0.0,-1000.0,0.0,0.0,0.0,100.0);
			SetPlayerObjectMaterial(playerid, PlayerSpeedObject[playerid], 0, 8487, "ballyswater", "waterclear256", 0x00000000);
			PlayerSpeedObject2[playerid] =CreatePlayerObject(playerid, 19327,0.0,0.0,-1000.0,0.0,0.0,180.0,100.0);
			SetPlayerObjectMaterial(playerid, PlayerSpeedObject2[playerid], 0, 8487, "ballyswater", "waterclear256", 0x00000000);
			SetTimerEx("AttachSpeedBoard", 1000, false, "ii", playerid,GetPlayerVehicleID(playerid));
		}
		return 1;

	}
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(PlayerSpeed[playerid]==0) return 1;
	UpdateSpeedo(playerid);
	if(newstate == PLAYER_STATE_DRIVER)
	{
		PlayerSpeedObject[playerid] =CreatePlayerObject(playerid, 19327,0.0,0.0,-1000.0,0.0,0.0,0.0,100.0);
		SetPlayerObjectMaterial(playerid, PlayerSpeedObject[playerid], 0, 8487, "ballyswater", "waterclear256", 0x00000000);
		PlayerSpeedObject2[playerid] =CreatePlayerObject(playerid, 19327,0.0,0.0,-1000.0,0.0,0.0,180.0,100.0);
		SetPlayerObjectMaterial(playerid, PlayerSpeedObject2[playerid], 0, 8487, "ballyswater", "waterclear256", 0x00000000);
		
		SetTimerEx("AttachSpeedBoard", 1000, false, "ii", playerid,GetPlayerVehicleID(playerid));
	}
	if(newstate != PLAYER_STATE_DRIVER)
	{
		DestroyPlayerObject(playerid,PlayerSpeedObject[playerid]);
		DestroyPlayerObject(playerid,PlayerSpeedObject2[playerid]);
	}

	return 1;
}

forward AttachSpeedBoard(playerid,vehid);
public AttachSpeedBoard(playerid,vehid)
{
	new Float:X, Float:Y, Float:Z;
	GetVehicleModelInfo(GetVehicleModel(vehid), VEHICLE_MODEL_INFO_SIZE, X, Y, Z);	
	new Float:sx, Float:sy,Float:sz;
	GetVehicleModelInfo(GetVehicleModel(vehid), VEHICLE_MODEL_INFO_FRONTSEAT, sx,sy, sz);
	
	if(IsAMotorBike(vehid) || IsABike(vehid))
	{
		AttachPlayerObjectToVehicle(playerid, PlayerSpeedObject[playerid] ,vehid, sx-2.5*X, sy ,sz+0.2, 0.000, 0.000, 0.000);
		AttachPlayerObjectToVehicle(playerid, PlayerSpeedObject2[playerid] ,vehid, sx-2.5*X, sy ,sz+0.2, 0.000, 0.000, 180.000);
	}
	else
	{
		AttachPlayerObjectToVehicle(playerid, PlayerSpeedObject[playerid] ,vehid, sx-1.2*X , sy, sz+0.2, 0.000, 0.000, 0.000);
		AttachPlayerObjectToVehicle(playerid, PlayerSpeedObject2[playerid] ,vehid, sx-1.2*X , sy, sz+0.2, 0.000, 0.000, 180.000);
	}
	//else if(vehid == 444 || vehid == 556 || vehid == 557) //monster trucks
	// 	AttachPlayerObjectToVehicle(playerid, PlayerSpeedObject[playerid] ,vehid, 3.0, 0.0 ,0.2, 0.000, 0.000, 0.000);
	return 1;
}
stock IsABike(carid) 
{
	switch(GetVehicleModel(carid))
	{
		case 509, 481, 510: return 1;
	}
	return 0;
}

stock IsAMotorBike(carid)
{
	switch(GetVehicleModel(carid)) 
	{
		case 509, 510, 462, 448, 581, 522, 461, 521, 523, 463, 586, 468, 471: return 1;
	}
	return 0;
}

