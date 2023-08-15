//+------------------------------------------------------------------+
//|                                             TimeRangeEAPanel.mq5 |
//|                                                   Amir Nabizadeh |
//|                                                  Britishadam.com |
//+------------------------------------------------------------------+
#property copyright "Amir Nabizadeh"
#property link      "Britishadam.com"
#property version   "1.00"


//+------------------------------------------------------------------+
//| Include                                                          |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>
#include <GraphicalPanel.mqh>

//+------------------------------------------------------------------+
//| Global variables                                                          |
//+------------------------------------------------------------------+
CGraphicalPanel panel;
bool isTradeOpen = false;
CTrade trade;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
  // create panel
  if(!panel.Oninit()){return INIT_FAILED;}

  return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
  // destroy panel
  panel.Destroy(reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
  string cSymbol = _Symbol;
  string cHigh = DoubleToString(iHigh(_Symbol, Period(), 0));
  string cLow = DoubleToString(iLow(_Symbol, Period(), 0));
  string cOpen = DoubleToString(iOpen(_Symbol, Period(),0));
  string cClose = DoubleToString(iClose(_Symbol, Period(), 0));
  string spread = IntegerToString(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD));
  
  panel.Update(cSymbol,cHigh,cLow,cOpen,cClose,spread);
}

//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam){
  panel.PanelChartEvent(id,lparam,dparam,sparam);
}