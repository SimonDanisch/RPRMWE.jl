#include "rprTrace_playList.h"
#include <fstream>

#include <RadeonProRender.h>
#include <RadeonProRender_MaterialX.h>
#include <Math/matrix.h>
#include <Math/mathutils.h>

#define RPRTRACE_CHECK  CheckFrStatus(status);
#define RPRTRACE_DEV 1

class RprTracePlayer
{
private:
	std::fstream dataFile;
	void* pData1 = 0;
	void* pData2 = 0;
	void* pData3 = 0;
	void* pData4 = 0;
	void* pData5 = 0;
	void* pData6 = 0;
	void* pData7 = 0;
	void* pData8 = 0;
	void* pData9 = 0;
	std::vector<void*> ppData1;
	std::vector<void*> ppData2;
	std::vector<void*> ppData3;
	std::vector<void*> ppData4;
	std::vector<void*> ppData5;
	std::vector<void*> ppData6;
	std::vector<void*> ppData7;
	std::vector<void*> ppData8;
	std::vector<void*> ppData9;

	rpr_int status = RPR_SUCCESS;

	#include "rprTrace_variables.h"
	void SeekFStream_64(std::fstream& s, unsigned long long pos);
	void ClearPPData();
	void CheckFrStatus(rpr_int status);
	#define RPRTRACINGMACRO__PLAYLIST_BEG  int
	#define RPRTRACINGMACRO__PLAYLIST_END  
	RPRTRACINGMACRO__PLAYLIST;
	#undef RPRTRACINGMACRO__PLAYLIST_BEG
	#undef RPRTRACINGMACRO__PLAYLIST_END
public:
	rpr_int PlayAll();
	void init();
};
