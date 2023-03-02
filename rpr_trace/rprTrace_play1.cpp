#include "rprTrace_player.h"
int RprTracePlayer::play1()
{
	dataFile.open("rprTrace_data.bin", std::ios::in | std::ios::binary);
	if ( dataFile.fail() || !dataFile.is_open() ) { CheckFrStatus(RPR_ERROR_INTERNAL_ERROR); return RPR_ERROR_INTERNAL_ERROR; }
//status = rprContextSetParameterByKey1u(context_0x000002BE10DDECB0,RPR_CONTEXT_TRACING_ENABLED,(rpr_uint)1);  RPRTRACE_CHECK
//Mesh creation
	if ( pData1 ) { free(pData1); pData1=NULL; }
	if ( pData2 ) { free(pData2); pData2=NULL; }
	if ( pData3 ) { free(pData3); pData3=NULL; }
	if ( pData4 ) { free(pData4); pData4=NULL; }
	if ( pData5 ) { free(pData5); pData5=NULL; }
	if ( pData6 ) { free(pData6); pData6=NULL; }
	if ( pData7 ) { free(pData7); pData7=NULL; }
	if ( pData8 ) { free(pData8); pData8=NULL; }
	if ( pData9 ) { free(pData9); pData9=NULL; }
	ClearPPData();
	dataFile.close();
	return RPR_SUCCESS;
}

//End of trace.

