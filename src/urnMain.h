/***************************************************************
 * Name:      urnMain.h
 * Purpose:   Defines Application Frame
 * Author:    Brian Takita (brian.takita@gmail.com)
 * Created:   2008-07-18
 * Copyright: Brian Takita ()
 * License:
 **************************************************************/

#ifndef URNMAIN_H
#define URNMAIN_H



#include "urnApp.h"


#include "GUIFrame.h"

class urnFrame: public GUIFrame
{
    public:
        urnFrame(wxFrame *frame);
        ~urnFrame();
    private:
        virtual void OnClose(wxCloseEvent& event);
        virtual void OnQuit(wxCommandEvent& event);
        virtual void OnAbout(wxCommandEvent& event);
};

#endif // URNMAIN_H
