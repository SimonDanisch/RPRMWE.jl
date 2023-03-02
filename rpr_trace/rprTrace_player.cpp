// Trace of Radeon ProRender API calls.
// API version of trace = 0x0000000000200217
// RPR_VERSION_BUILD = 0x00000000C1DD1D1B

#include "rprTrace_player.h"
#include "rprTrace_playList.h"
#define RPRTRACINGMACRO__PLAYLIST_BEG  status =
#define RPRTRACINGMACRO__PLAYLIST_END  CheckFrStatus(status);  if (status!=RPR_SUCCESS) {return status;} 
rpr_int RprTracePlayer::PlayAll()
{
	RPRTRACINGMACRO__PLAYLIST;
	return RPR_SUCCESS;
}
#undef RPRTRACINGMACRO__PLAYLIST_BEG
#undef RPRTRACINGMACRO__PLAYLIST_END

void RprTracePlayer::init()
{
}

void RprTracePlayer::SeekFStream_64(std::fstream& s, unsigned long long pos)
{
	const unsigned long long step = 0x010000000;
	s.seekg(0, std::ios::beg);
	unsigned long long nbStep = pos / (unsigned long long)step;
	for (unsigned long long i = 0; i < nbStep; i++)
	{
		s.seekg(step, std::ios::cur);
	}
	unsigned long long remainder_64 = pos % (unsigned long long)step;
	long remainder_32 = remainder_64;
	s.seekg(remainder_32, std::ios::cur);
}

void RprTracePlayer::ClearPPData()
{
	for(int i=0; i < ppData1.size(); i++) { if ( ppData1[i] ) free(ppData1[i]); } ppData1.clear();
	for(int i=0; i < ppData2.size(); i++) { if ( ppData2[i] ) free(ppData2[i]); } ppData2.clear();
	for(int i=0; i < ppData3.size(); i++) { if ( ppData3[i] ) free(ppData3[i]); } ppData3.clear();
	for(int i=0; i < ppData4.size(); i++) { if ( ppData4[i] ) free(ppData4[i]); } ppData4.clear();
	for(int i=0; i < ppData5.size(); i++) { if ( ppData5[i] ) free(ppData5[i]); } ppData5.clear();
	for(int i=0; i < ppData6.size(); i++) { if ( ppData6[i] ) free(ppData6[i]); } ppData6.clear();
	for(int i=0; i < ppData7.size(); i++) { if ( ppData7[i] ) free(ppData7[i]); } ppData7.clear();
	for(int i=0; i < ppData8.size(); i++) { if ( ppData8[i] ) free(ppData8[i]); } ppData8.clear();
	for(int i=0; i < ppData9.size(); i++) { if ( ppData9[i] ) free(ppData9[i]); } ppData9.clear();
}


void RprTracePlayer::CheckFrStatus(rpr_int status)
{
	if ( status != RPR_SUCCESS )
	{
		//manage error here
		int a = 0;
	}
}


RprTracePlayer player;
int main()
{
	player.init();
	rpr_int retCode = player.PlayAll();
	return retCode;
}
