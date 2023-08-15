//+------------------------------------------------------------------+
//|                                               GraphicalPanel.mqh |
//|                                                   Amir Nabizadeh |
//|                                                  Britishadam.com |
//+------------------------------------------------------------------+
#property copyright "Amir Nabizadeh"
#property link      "Britishadam.com"

//+------------------------------------------------------------------+
//| Include 1                                                        |
//+------------------------------------------------------------------+
#include <Controls\Defines.mqh>

//+------------------------------------------------------------------+
//| Define statements to change default dialoge settings             |
//+------------------------------------------------------------------+
#undef CONTROLS_FONT_NAME
#undef CONTROLS_DIALOG_COLOR_CLIENT_BG
#define CONTROLS_FONT_NAME                "Consolas"
#define CONTROLS_DIALOG_COLOR_CLIENT_BG   C'0x20,0x20,0x20'


//+------------------------------------------------------------------+
//| Include 2                                                        |
//+------------------------------------------------------------------+
#include <Controls\Dialog.mqh>
#include <Controls\Label.mqh>
#include <Controls\Button.mqh>

//+------------------------------------------------------------------+
//| Inputs                                                           |
//+------------------------------------------------------------------+
input group "==== Panel Inputs ===="
static input int InpPanelWidth = 300;               // width in pixel
static input int InpPanelHeight = 300;              // height in pixel
static input int InpPanelFontSize = 11;             // font size
static input int InpPanelTxtColor = clrWhiteSmoke;  // text color

//+------------------------------------------------------------------+
//| class CGraphicalPanel                                            |
//+------------------------------------------------------------------+
class CGraphicalPanel : public CAppDialog
{
   private:
      // private variables
      bool m_f_color;
      
      // labels
      CLabel m_lSymbol;
      CLabel m_lOpen;
      CLabel m_lClose;
      CLabel m_lHigh;
      CLabel m_lLow;
      CLabel m_lSpread;
      
      // buttons
      CButton m_bBuy;
      CButton m_bSell;
      
   
      // private methods
      void OnClickBuyButton();
      bool CheckInputs();
      bool CreatePanel();
   
   
   public:
      // public methods
      void CGraphicalPanel();
      void ~CGraphicalPanel();
      bool Oninit();
      void Update(string symbol,string high,string low,string open,string close,string spread);
      
      // chart event handler
      void PanelChartEvent(const int id, const long &lparam, const double &param, const string &param);
   
};

// constructor
void CGraphicalPanel::CGraphicalPanel(void){}

// deconstractor
void CGraphicalPanel::~CGraphicalPanel(void){}

bool CGraphicalPanel::Oninit(void)
{
   // check user inputs
   if(!CheckInputs()){return false;}
   // create panel
   if(!this.CreatePanel()){return false;}
   
   return true;
}

bool CGraphicalPanel::CheckInputs(void)
{
   if(InpPanelWidth<0)
     {
      Print("Panel width <= 0");
      return false;
     }
   if(InpPanelHeight<0)
     {
      Print("Panel height <= 0");
      return false;
     }
   if(InpPanelFontSize<0)
     {
      Print("Panel font size <= 0");
      return false;
     }
     
     return true;
}

void CGraphicalPanel::Update(string symbol,string high,string low,string open,string close,string spread)
{
   m_lSymbol.Text(symbol);
   m_lHigh.Text(  "High:   "+high);
   m_lLow.Text(   "Low:    "+low);
   m_lOpen.Text(  "Open:   "+open);
   m_lClose.Text( "Close:  "+close);
   m_lSpread.Text("Spread: "+spread);
}

bool CGraphicalPanel::CreatePanel(void)
{
   // create dialog panel
   this.Create(NULL,"British Adam!!!!",0,0,0,InpPanelWidth,InpPanelHeight);
   
   
   m_lSymbol.Create(NULL,"lSymbol",0,10,10,1,1);
   m_lSymbol.Text("Symbol");
   m_lSymbol.Color(clrLime);
   m_lSymbol.FontSize(InpPanelFontSize);
   this.Add(m_lSymbol);
   
   m_lHigh.Create(NULL,"lHigh",0,10,30,1,1);
   m_lHigh.Text("High:");
   m_lHigh.Color(InpPanelTxtColor);
   m_lHigh.FontSize(InpPanelFontSize);
   this.Add(m_lHigh);
   
   m_lLow.Create(NULL,"lLow",0,10,50,1,1);
   m_lLow.Text("Low:");
   m_lLow.Color(InpPanelTxtColor);
   m_lLow.FontSize(InpPanelFontSize);
   this.Add(m_lLow);
   
   m_lOpen.Create(NULL,"lOpen",0,10,70,1,1);
   m_lOpen.Text("Open:");
   m_lOpen.Color(InpPanelTxtColor);
   m_lOpen.FontSize(InpPanelFontSize);
   this.Add(m_lOpen);
   
   m_lClose.Create(NULL,"lClose",0,10,90,1,1);
   m_lClose.Text("Close:");
   m_lClose.Color(InpPanelTxtColor);
   m_lClose.FontSize(InpPanelFontSize);
   this.Add(m_lClose);
   
   m_lSpread.Create(NULL,"lSpread",0,10,110,1,1);
   m_lSpread.Text("Spread:");
   m_lSpread.Color(InpPanelTxtColor);
   m_lSpread.FontSize(InpPanelFontSize);
   this.Add(m_lSpread);
   
   
   m_bBuy.Create(NULL,"bBuy",0,30,150,120,180);
   m_bBuy.Text("Buy");
   m_bBuy.Color(clrAntiqueWhite);
   m_bBuy.ColorBackground(clrDarkGreen);
   m_bBuy.FontSize(InpPanelFontSize);
   this.Add(m_bBuy);
   
   m_bSell.Create(NULL,"bSell",0,150,150,240,180);
   m_bSell.Text("Sell");
   m_bSell.Color(clrAntiqueWhite);
   m_bSell.ColorBackground(clrDarkRed);
   m_bSell.FontSize(InpPanelFontSize);
   this.Add(m_bSell);
   
   // run panel
   if(!Run()){Print("Failed to run panel"); return false;}
     
   // refresh chart
   ChartRedraw();
   
   return true;
}

void CGraphicalPanel::PanelChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
{
   // call chart event method of base class
   ChartEvent(id,lparam,dparam,sparam);
   
   // check if button was pressed
   if(id==CHARTEVENT_OBJECT_CLICK && sparam=="bChangeColor")
   {
      OnClickBuyButton();
   }
   
   // if 
}

void CGraphicalPanel::OnClickBuyButton(void)
{
   
   ChartRedraw();
}