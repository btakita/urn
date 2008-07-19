/***************************************************************
 * Name:      urnApp.h
 * Purpose:   Defines Application Class
 * Author:    Brian Takita (brian.takita@gmail.com)
 * Created:   2008-07-18
 * Copyright: Brian Takita ()
 * License:
 **************************************************************/

#ifndef URNAPP_H
#define URNAPP_H

#include <wx/app.h>

class urnApp : public wxApp
{
    public:
        virtual bool OnInit();
};

#endif // URNAPP_H
