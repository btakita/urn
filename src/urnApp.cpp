/***************************************************************
 * Name:      urnApp.cpp
 * Purpose:   Code for Application Class
 * Author:    Brian Takita (brian.takita@gmail.com)
 * Created:   2008-07-18
 * Copyright: Brian Takita ()
 * License:
 **************************************************************/

#ifdef WX_PRECOMP
#include "wx_pch.h"
#endif

#ifdef __BORLANDC__
#pragma hdrstop
#endif //__BORLANDC__

#include "urnApp.h"
#include "urnMain.h"

IMPLEMENT_APP(urnApp);

bool urnApp::OnInit()
{
    urnFrame* frame = new urnFrame(0L);
    
    frame->Show();
    
    return true;
}
